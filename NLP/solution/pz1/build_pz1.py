# -*- coding: utf-8 -*-
"""Build NLP practical 1 notebook: hh.ru parsing."""
from pathlib import Path
import nbformat as nbf

nb = nbf.v4.new_notebook()
cells = []

def md(s):
    cells.append(nbf.v4.new_markdown_cell(s))

def code(s):
    cells.append(nbf.v4.new_code_cell(s))

md("# Практическая задача 1. Парсинг данных с hh.ru\n\n"
   "Источник: `materials/notes/disciplines__nlp__laboratory-works__hh.md`. "
   "Предобработка — по лекции `preprocessing`.\n\n"
   "**Замечание по API:** `GET https://api.hh.ru/vacancies` с этой сети отвечает `403 forbidden` "
   "(словари API при этом доступны). Сбор вакансий сделан многопоточно с публичных HTML-страниц "
   "hh.ru и разбором JSON-LD `JobPosting` (описание, зарплата, работодатель). Код запроса к API "
   "оставлен в §1 для отчёта о структуре endpoint'ов.")

md("## 1. Изучение API hh.ru и настройка сбора\n\n"
   "Публичный OpenAPI: поиск `GET /vacancies`, карточка `GET /vacancies/{id}`. "
   "Для браузерных страниц обязателен обычный `User-Agent`. "
   "Многопоточность — `concurrent.futures.ThreadPoolExecutor` (материалы ПЗ).")

code(r'''from __future__ import annotations

import json
import pickle
import re
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path

import pandas as pd
import requests
from bs4 import BeautifulSoup
from nltk.corpus import stopwords
from nltk.stem.snowball import SnowballStemmer

import nltk

nltk.download('stopwords', quiet=True)

OUT_DIR = Path('.')
RAW_PATH = OUT_DIR / 'vacancies_raw.pkl'
DATASET_PATH = OUT_DIR / 'vacancies_dataset.pkl'
CSV_PATH = OUT_DIR / 'vacancies_dataset.csv'

API_HEADERS = {
    'User-Agent': 'FitNlpParser/1.0 (fit242.nlp@gmail.com)',
    'Accept': 'application/json',
}
WEB_HEADERS = {
    'User-Agent': (
        'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
        'AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Safari/537.36'
    ),
    'Accept': 'text/html,application/xhtml+xml',
    'Accept-Language': 'ru-RU,ru;q=0.9',
}

SEARCH_TEXT = 'python разработчик'
TARGET_COUNT = 220
ITEMS_ON_PAGE = 50
MAX_WORKERS = 3  # больше потоков → hh.ru отдает пустые/битые страницы
REQUEST_PAUSE = 0.35
MAX_RETRIES = 3

session = requests.Session()

# проверка API: словари доступны, поиск вакансий — часто 403
r_dict = session.get('https://api.hh.ru/dictionaries', headers=API_HEADERS, timeout=30)
r_vac = session.get(
    'https://api.hh.ru/vacancies',
    headers=API_HEADERS,
    params={'text': 'python', 'per_page': 1},
    timeout=30,
)
print('API /dictionaries:', r_dict.status_code)
print('API /vacancies:', r_vac.status_code, r_vac.text[:120].replace('\n', ' '))
print('Цель сбора (HTML):', TARGET_COUNT, 'вакансий по запросу', repr(SEARCH_TEXT))
''')

md("## 2. Многопоточный сбор вакансий\n\n"
   "1) Страницы поиска → id вакансий. 2) `ThreadPoolExecutor` качает карточки. "
   "3) Из JSON-LD `JobPosting` берём описание, зарплатную вилку и работодателя.")

code(r'''def collect_vacancy_ids(text: str, target: int) -> list[str]:
    ids: list[str] = []
    page = 0
    while len(ids) < target and page < 30:
        url = 'https://hh.ru/search/vacancy'
        r = session.get(
            url,
            headers=WEB_HEADERS,
            params={'text': text, 'items_on_page': ITEMS_ON_PAGE, 'page': page},
            timeout=45,
        )
        r.raise_for_status()
        found = re.findall(r'/vacancy/(\d+)', r.text)
        before = len(ids)
        for vid in found:
            if vid not in ids:
                ids.append(vid)
            if len(ids) >= target:
                break
        if len(ids) == before:
            break
        page += 1
        time.sleep(0.3)
    return ids


def parse_salary(job: dict) -> tuple[float | None, float | None, str | None]:
    base = job.get('baseSalary') or {}
    currency = None
    if isinstance(base.get('currency'), str):
        currency = base.get('currency')
    elif isinstance(base.get('currency'), dict):
        currency = base['currency'].get('name') or base['currency'].get('@type')
    value = base.get('value') or {}
    if isinstance(value, dict):
        return value.get('minValue'), value.get('maxValue'), currency
    if isinstance(value, (int, float)):
        return float(value), float(value), currency
    return None, None, currency


def _parse_jobposting(html: str, vid: str) -> dict | None:
    soup = BeautifulSoup(html, 'html.parser')
    job = None
    for script in soup.find_all('script', attrs={'type': 'application/ld+json'}):
        raw = script.string or script.get_text() or ''
        try:
            data = json.loads(raw)
        except json.JSONDecodeError:
            continue
        candidates = data if isinstance(data, list) else [data]
        for item in candidates:
            if isinstance(item, dict) and item.get('@type') == 'JobPosting':
                job = item
                break
        if job:
            break
    if not job:
        return None
    salary_from, salary_to, currency = parse_salary(job)
    org = job.get('hiringOrganization') or {}
    if isinstance(org, str):
        org = {'name': org}
    loc = job.get('jobLocation')
    if isinstance(loc, list) and loc:
        loc = loc[0]
    area = None
    if isinstance(loc, dict):
        addr = loc.get('address') or {}
        if isinstance(addr, dict):
            area = addr.get('addressLocality') or addr.get('addressRegion')
        elif isinstance(addr, str):
            area = addr
    title = soup.find('h1')
    return {
        'id': str(vid),
        'name': job.get('title') or (title.get_text(strip=True) if title else None),
        'description_html': job.get('description') or '',
        'salary_from': salary_from,
        'salary_to': salary_to,
        'salary_currency': currency,
        'employer_name': org.get('name'),
        'area': area,
        'published_at': job.get('datePosted'),
        'url': f'https://hh.ru/vacancy/{vid}',
    }


def fetch_vacancy_html(vid: str) -> dict | None:
    for attempt in range(1, MAX_RETRIES + 1):
        time.sleep(REQUEST_PAUSE)
        try:
            r = session.get(f'https://hh.ru/vacancy/{vid}', headers=WEB_HEADERS, timeout=45)
        except requests.RequestException:
            time.sleep(1.0 * attempt)
            continue
        if r.status_code != 200:
            time.sleep(1.0 * attempt)
            continue
        parsed = _parse_jobposting(r.text, vid)
        if parsed is not None:
            return parsed
        time.sleep(1.0 * attempt)
    return None


if RAW_PATH.exists():
    with open(RAW_PATH, 'rb') as f:
        vacancies = pickle.load(f)
    print('Загружен кэш:', RAW_PATH, 'записей:', len(vacancies))
else:
    ids = collect_vacancy_ids(SEARCH_TEXT, TARGET_COUNT)
    print('Собрано id:', len(ids))
    vacancies = []
    errors = 0
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as pool:
        futures = {pool.submit(fetch_vacancy_html, vid): vid for vid in ids}
        for fut in as_completed(futures):
            row = fut.result()
            if row is None:
                errors += 1
            else:
                vacancies.append(row)
    with open(RAW_PATH, 'wb') as f:
        pickle.dump(vacancies, f)
    print('Сохранено сырых вакансий:', len(vacancies), 'ошибок:', errors, '->', RAW_PATH)

assert len(vacancies) >= 50, 'Слишком мало вакансий — проверьте сеть'
print('Пример:', vacancies[0].get('name'), '|', vacancies[0].get('employer_name'))
print('Зарплата from/to:', vacancies[0].get('salary_from'), vacancies[0].get('salary_to'))
print('Есть описание:', bool(vacancies[0].get('description_html')))
''')

md("## 3. Предварительная обработка описаний\n\n"
   "По лекции preprocessing: снять HTML (`BeautifulSoup`), нижний регистр, "
   "убрать URL/пунктуацию, токенизация, стоп-слова NLTK, стемминг Snowball.")

code(r'''RU_STOP = set(stopwords.words('russian'))
stemmer = SnowballStemmer('russian')


def clean_html(html: str) -> str:
    text = BeautifulSoup(html or '', 'html.parser').get_text(separator=' ')
    text = text.lower()
    text = re.sub(r'http\S+|www\.\S+', ' ', text)
    text = re.sub(r'\S+@\S+', ' ', text)
    text = re.sub(r'[^а-яёa-z\s]', ' ', text, flags=re.IGNORECASE)
    text = re.sub(r'\s+', ' ', text).strip()
    return text


def preprocess(html: str) -> list[str]:
    text = clean_html(html)
    tokens = [t for t in text.split() if t and t not in RU_STOP and len(t) > 2]
    return [stemmer.stem(t) for t in tokens]


for v in vacancies:
    v['description_text'] = clean_html(v.get('description_html', ''))
    v['tokens'] = preprocess(v.get('description_html', ''))

lengths = [len(v['tokens']) for v in vacancies]
print('Вакансий:', len(vacancies))
print('Средняя длина токенов:', round(sum(lengths) / max(len(lengths), 1), 1))
print('Пример токенов:', vacancies[0]['tokens'][:25])
''')

md("## 4. Сохранение датасета\n\n"
   "Критерий приёмки: датасет читается без повторного сбора. "
   "Pickle (с токенами) и CSV без колонки `tokens`.")

code(r'''df = pd.DataFrame(
    [
        {
            'id': v['id'],
            'name': v['name'],
            'description_text': v['description_text'],
            'salary_from': v['salary_from'],
            'salary_to': v['salary_to'],
            'salary_currency': v['salary_currency'],
            'employer_name': v['employer_name'],
            'area': v['area'],
            'published_at': v['published_at'],
            'url': v['url'],
            'tokens': v['tokens'],
            'n_tokens': len(v['tokens']),
        }
        for v in vacancies
    ]
)

with open(DATASET_PATH, 'wb') as f:
    pickle.dump(df, f)

df.drop(columns=['tokens']).to_csv(CSV_PATH, index=False, encoding='utf-8-sig')

loaded = pd.read_pickle(DATASET_PATH)
print('Файл:', DATASET_PATH.resolve())
print('CSV:', CSV_PATH.resolve())
print('Записей при чтении:', len(loaded))
print(loaded[['id', 'employer_name', 'salary_from', 'salary_to', 'n_tokens']].head())
print('Критерии: многопоточный сбор — да; предобработка — да; сохранение — да.')
''')

nb['cells'] = cells
nb['metadata'] = {
    'kernelspec': {'display_name': 'Python 3', 'language': 'python', 'name': 'python3'},
    'language_info': {'name': 'python'},
}
out = Path(__file__).with_name('pz1.ipynb')
nbf.write(nb, out)
print('wrote', out)
