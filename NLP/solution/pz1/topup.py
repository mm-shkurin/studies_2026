# -*- coding: utf-8 -*-
"""Sequentially fetch missing hh.ru vacancies into the PZ1 cache."""
from __future__ import annotations

import json
import pickle
import re
import time
from pathlib import Path

import pandas as pd
import requests
from bs4 import BeautifulSoup
from nltk.corpus import stopwords
from nltk.stem.snowball import SnowballStemmer
import nltk

nltk.download("stopwords", quiet=True)

OUT = Path(__file__).resolve().parent
WEB_HEADERS = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36"
    ),
    "Accept": "text/html,application/xhtml+xml",
    "Accept-Language": "ru-RU,ru;q=0.9",
}
session = requests.Session()

ids: list[str] = []
page = 0
while len(ids) < 220 and page < 30:
    r = session.get(
        "https://hh.ru/search/vacancy",
        headers=WEB_HEADERS,
        params={"text": "python разработчик", "items_on_page": 50, "page": page},
        timeout=45,
    )
    r.raise_for_status()
    for vid in re.findall(r"/vacancy/(\d+)", r.text):
        if vid not in ids:
            ids.append(vid)
        if len(ids) >= 220:
            break
    page += 1
    time.sleep(0.3)
print("ids", len(ids))

raw = pickle.load(open(OUT / "vacancies_raw.pkl", "rb"))
have = {v["id"] for v in raw}
missing = [i for i in ids if i not in have]
print("have", len(have), "missing", len(missing))


def parse_salary(job):
    base = job.get("baseSalary") or {}
    currency = None
    if isinstance(base.get("currency"), str):
        currency = base.get("currency")
    elif isinstance(base.get("currency"), dict):
        currency = base["currency"].get("name")
    value = base.get("value") or {}
    if isinstance(value, dict):
        return value.get("minValue"), value.get("maxValue"), currency
    if isinstance(value, (int, float)):
        return float(value), float(value), currency
    return None, None, currency


def fetch(vid: str):
    for _ in range(3):
        time.sleep(0.45)
        try:
            r = session.get(f"https://hh.ru/vacancy/{vid}", headers=WEB_HEADERS, timeout=45)
        except Exception:
            time.sleep(1.5)
            continue
        if r.status_code != 200:
            time.sleep(1.5)
            continue
        soup = BeautifulSoup(r.text, "html.parser")
        job = None
        for script in soup.find_all("script", attrs={"type": "application/ld+json"}):
            raws = script.string or script.get_text() or ""
            try:
                data = json.loads(raws)
            except json.JSONDecodeError:
                continue
            cands = data if isinstance(data, list) else [data]
            for item in cands:
                if isinstance(item, dict) and item.get("@type") == "JobPosting":
                    job = item
                    break
            if job:
                break
        if not job:
            time.sleep(1.0)
            continue
        sf, st, cur = parse_salary(job)
        org = job.get("hiringOrganization") or {}
        if isinstance(org, str):
            org = {"name": org}
        loc = job.get("jobLocation")
        if isinstance(loc, list) and loc:
            loc = loc[0]
        area = None
        if isinstance(loc, dict):
            addr = loc.get("address") or {}
            if isinstance(addr, dict):
                area = addr.get("addressLocality") or addr.get("addressRegion")
            elif isinstance(addr, str):
                area = addr
        title = soup.find("h1")
        return {
            "id": str(vid),
            "name": job.get("title") or (title.get_text(strip=True) if title else None),
            "description_html": job.get("description") or "",
            "salary_from": sf,
            "salary_to": st,
            "salary_currency": cur,
            "employer_name": org.get("name"),
            "area": area,
            "published_at": job.get("datePosted"),
            "url": f"https://hh.ru/vacancy/{vid}",
        }
    return None


added = 0
for i, vid in enumerate(missing):
    row = fetch(vid)
    if row:
        raw.append(row)
        added += 1
    if (i + 1) % 20 == 0:
        print(f"progress {i+1}/{len(missing)}, total={len(raw)}, added={added}")
        pickle.dump(raw, open(OUT / "vacancies_raw.pkl", "wb"))

pickle.dump(raw, open(OUT / "vacancies_raw.pkl", "wb"))
print("final raw", len(raw), "added", added)

RU_STOP = set(stopwords.words("russian"))
stemmer = SnowballStemmer("russian")


def clean_html(html: str) -> str:
    text = BeautifulSoup(html or "", "html.parser").get_text(separator=" ")
    text = text.lower()
    text = re.sub(r"http\S+|www\.\S+", " ", text)
    text = re.sub(r"\S+@\S+", " ", text)
    text = re.sub(r"[^а-яёa-z\s]", " ", text, flags=re.IGNORECASE)
    return re.sub(r"\s+", " ", text).strip()


def preprocess(html: str) -> list[str]:
    tokens = [t for t in clean_html(html).split() if t and t not in RU_STOP and len(t) > 2]
    return [stemmer.stem(t) for t in tokens]


for v in raw:
    v["description_text"] = clean_html(v.get("description_html", ""))
    v["tokens"] = preprocess(v.get("description_html", ""))

df = pd.DataFrame(
    [
        {
            "id": v["id"],
            "name": v["name"],
            "description_text": v["description_text"],
            "salary_from": v["salary_from"],
            "salary_to": v["salary_to"],
            "salary_currency": v["salary_currency"],
            "employer_name": v["employer_name"],
            "area": v["area"],
            "published_at": v["published_at"],
            "url": v["url"],
            "tokens": v["tokens"],
            "n_tokens": len(v["tokens"]),
        }
        for v in raw
    ]
)
df.to_pickle(OUT / "vacancies_dataset.pkl")
df.drop(columns=["tokens"]).to_csv(OUT / "vacancies_dataset.csv", index=False, encoding="utf-8-sig")
print("dataset", len(df))
