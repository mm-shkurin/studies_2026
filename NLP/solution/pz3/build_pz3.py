# -*- coding: utf-8 -*-
"""Build NLP practical 3 notebook: sklearn/gensim topic modeling."""
from pathlib import Path
import nbformat as nbf

nb = nbf.v4.new_notebook()
cells = []

def md(s):
    cells.append(nbf.v4.new_markdown_cell(s))

def code(s):
    cells.append(nbf.v4.new_code_cell(s))

md("# Практическая задача 3. Тематическое моделирование (sklearn и gensim)\n\n"
   "Источник: `materials/notes/disciplines__nlp__laboratory-works__gensim-sklearn-topic-modeling.md`.\n\n"
   "На вики 2026 третья по списку практика — «дистилляция и квантование» — **без текста условия**. "
   "Эта работа — следующая со ссылкой (тематическое моделирование). "
   "Данные — из условия ЛР 5 (архив BigARTM): mlsum/ru parquet, как в "
   "`materials/notes/disciplines__nlp__laboratory-works__topic-modeling.md`.")

md("## 1. Загрузка обучающей и тестовой выборок (данные ЛР 5)\n\n"
   "Файлы parquet с Hugging Face; кэш вне OneDrive. Берём подвыборку статей, "
   "чтобы прогон на CPU укладывался в разумное время.")

code(r'''from __future__ import annotations

import re
import urllib.request
from pathlib import Path

import numpy as np
import pandas as pd
from gensim import corpora, models
from sklearn.decomposition import LatentDirichletAllocation, NMF, TruncatedSVD
from sklearn.feature_extraction.text import CountVectorizer, TfidfVectorizer

CACHE = Path.home() / '.cache' / 'studies2026-nlp' / 'mlsum-ru'
CACHE.mkdir(parents=True, exist_ok=True)

TRAIN_URL = (
    'https://huggingface.co/datasets/mlsum/resolve/refs%2Fconvert%2Fparquet/'
    'ru/train/0000.parquet?download=true'
)
TEST_URL = (
    'https://huggingface.co/datasets/mlsum/resolve/refs%2Fconvert%2Fparquet/'
    'ru/test/0000.parquet?download=true'
)
TRAIN_PATH = CACHE / 'train_0000.parquet'
TEST_PATH = CACHE / 'test_0000.parquet'

N_TRAIN = 2500
N_TEST = 500
N_TOPICS = 8
N_TOP_WORDS = 12
RANDOM_STATE = 42


def ensure_file(url: str, path: Path) -> None:
    if path.exists() and path.stat().st_size > 0:
        return
    print('Скачиваю', path.name, '...')
    urllib.request.urlretrieve(url, path)
    print('Готово:', path, 'байт:', path.stat().st_size)


ensure_file(TRAIN_URL, TRAIN_PATH)
ensure_file(TEST_URL, TEST_PATH)

train_full = pd.read_parquet(TRAIN_PATH)
test_full = pd.read_parquet(TEST_PATH)
print('Столбцы train:', train_full.columns.tolist())
print('Размеры полные:', len(train_full), len(test_full))

# текст новости: в mlsum/ru обычно text / summary / title
text_col = 'text' if 'text' in train_full.columns else train_full.columns[0]
train_df = train_full[[text_col]].dropna().head(N_TRAIN).copy()
test_df = test_full[[text_col]].dropna().head(N_TEST).copy()
train_df.columns = ['text']
test_df.columns = ['text']
print('Подвыборка train/test:', len(train_df), len(test_df))
print(train_df['text'].iloc[0][:240])
''')

md("## 2. Предобработка и векторизация\n\n"
   "Очистка, токены; CountVectorizer / TfidfVectorizer для sklearn; "
   "словарь gensim — по тем же токенам.")

code(r'''# стоп-слова: общие знания + лекция preprocessing (без обязательного NLTK download в Colab)
RU_STOP = {
    'и', 'в', 'во', 'не', 'что', 'он', 'на', 'я', 'с', 'со', 'как', 'а', 'то', 'все', 'она',
    'так', 'его', 'но', 'да', 'ты', 'к', 'у', 'же', 'вы', 'за', 'бы', 'по', 'только', 'ее',
    'мне', 'было', 'вот', 'от', 'меня', 'еще', 'нет', 'о', 'из', 'ему', 'теперь', 'когда',
    'даже', 'ну', 'вдруг', 'ли', 'если', 'уже', 'или', 'ни', 'быть', 'был', 'него', 'до',
    'вас', 'нибудь', 'опять', 'уж', 'вам', 'ведь', 'там', 'потом', 'себя', 'ничего', 'ей',
    'может', 'они', 'тут', 'где', 'есть', 'надо', 'ней', 'для', 'мы', 'тебя', 'их', 'чем',
    'была', 'сам', 'чтоб', 'без', 'будто', 'человек', 'чего', 'раз', 'тоже', 'себе', 'под',
    'жизнь', 'будет', 'ж', 'тогда', 'кто', 'этот', 'того', 'потому', 'этого', 'какой',
    'совсем', 'ним', 'здесь', 'этом', 'один', 'почти', 'мой', 'тем', 'чтобы', 'нее',
    'сейчас', 'были', 'куда', 'зачем', 'сказать', 'всех', 'никогда', 'сегодня', 'можно',
    'при', 'наконец', 'два', 'об', 'другой', 'хоть', 'после', 'над', 'больше', 'тот',
    'через', 'эти', 'нас', 'про', 'всего', 'них', 'какая', 'много', 'разве', 'три', 'эту',
    'моя', 'впрочем', 'хорошо', 'свою', 'этой', 'перед', 'иногда', 'лучше', 'чуть', 'том',
    'нельзя', 'такой', 'им', 'более', 'всегда', 'конечно', 'всю', 'между', 'это', 'также',
    'изза', 'из-за', 'года', 'году', 'лет', 'также', 'которые', 'который', 'которая',
}


def preprocess(text: str) -> str:
    text = str(text).lower()
    text = re.sub(r'https?://\S+|www\.\S+', ' ', text)
    text = re.sub(r'[^а-яёa-z\s]', ' ', text)
    text = re.sub(r'\s+', ' ', text).strip()
    tokens = [t for t in text.split() if t not in RU_STOP and len(t) > 2]
    return ' '.join(tokens)


train_df['clean'] = train_df['text'].map(preprocess)
test_df['clean'] = test_df['text'].map(preprocess)
train_tokens = [doc.split() for doc in train_df['clean']]
test_tokens = [doc.split() for doc in test_df['clean']]

count_vec = CountVectorizer(max_df=0.7, min_df=5, max_features=5000, stop_words=list(RU_STOP))
X_train_counts = count_vec.fit_transform(train_df['clean'])
X_test_counts = count_vec.transform(test_df['clean'])
feature_names = np.array(count_vec.get_feature_names_out())

tfidf_vec = TfidfVectorizer(max_df=0.7, min_df=5, max_features=5000)
X_train_tfidf = tfidf_vec.fit_transform(train_df['clean'])
X_test_tfidf = tfidf_vec.transform(test_df['clean'])
tfidf_names = np.array(tfidf_vec.get_feature_names_out())

dictionary = corpora.Dictionary(train_tokens)
dictionary.filter_extremes(no_below=5, no_above=0.7, keep_n=5000)
corpus_train = [dictionary.doc2bow(t) for t in train_tokens]
corpus_test = [dictionary.doc2bow(t) for t in test_tokens]
print('BoW shape:', X_train_counts.shape, 'словарь gensim:', len(dictionary))
''')

md("## 3. LDA, NMF, SVD/LSA (sklearn и gensim)\n\n"
   "По ходу работы: LDA (sklearn + gensim), NMF (sklearn + gensim), SVD/LSA (sklearn).")

code(r'''def show_topics(name: str, components: np.ndarray, words: np.ndarray, n_words=N_TOP_WORDS):
    print(f'\n=== {name} ===')
    for i, row in enumerate(components):
        top = words[row.argsort()[::-1][:n_words]]
        print(f'Topic {i}:', ', '.join(top))


# --- LDA sklearn ---
lda_sk = LatentDirichletAllocation(
    n_components=N_TOPICS, random_state=RANDOM_STATE, learning_method='batch', max_iter=15
)
lda_sk.fit(X_train_counts)
show_topics('LDA sklearn', lda_sk.components_, feature_names)

# --- NMF sklearn ---
nmf_sk = NMF(n_components=N_TOPICS, random_state=RANDOM_STATE, init='nndsvda', max_iter=400)
nmf_sk.fit(X_train_tfidf)
show_topics('NMF sklearn', nmf_sk.components_, tfidf_names)

# --- SVD / LSA sklearn ---
svd = TruncatedSVD(n_components=N_TOPICS, random_state=RANDOM_STATE)
svd.fit(X_train_tfidf)
show_topics('SVD/LSA sklearn', np.abs(svd.components_), tfidf_names)

# --- LDA gensim ---
lda_gs = models.LdaModel(
    corpus=corpus_train,
    id2word=dictionary,
    num_topics=N_TOPICS,
    random_state=RANDOM_STATE,
    passes=8,
    alpha='auto',
)
print('\n=== LDA gensim ===')
for i in range(N_TOPICS):
    terms = lda_gs.show_topic(i, topn=N_TOP_WORDS)
    print(f'Topic {i}:', ', '.join(w for w, _ in terms))

# --- NMF gensim (через TF-IDF корпус) ---
tfidf_gs = models.TfidfModel(corpus_train)
corpus_tfidf = tfidf_gs[corpus_train]
nmf_gs = models.Nmf(
    corpus=corpus_tfidf,
    num_topics=N_TOPICS,
    id2word=dictionary,
    random_state=RANDOM_STATE,
    passes=8,
)
print('\n=== NMF gensim ===')
for i in range(N_TOPICS):
    terms = nmf_gs.show_topic(i, topn=N_TOP_WORDS)
    print(f'Topic {i}:', ', '.join(w for w, _ in terms))

print('\nМодели обучены: LDA/NMF/SVD sklearn + LDA/NMF gensim.')
''')

md("## 4. Интерпретация тем\n\n"
   "Кратко сопоставляем темы с сюжетами новостей; на тесте смотрим распределение LDA sklearn.")

code(r'''topic_mass = lda_sk.transform(X_test_counts).mean(axis=0)
order = topic_mass.argsort()[::-1]
print('Средняя доля тем на тесте (LDA sklearn), по убыванию:')
for i in order:
    top_words = feature_names[lda_sk.components_[i].argsort()[::-1][:8]]
    print(f'  topic {i}: mass={topic_mass[i]:.3f}; words={", ".join(top_words)}')

print(
    '\nИнтерпретация (эвристика по топ-словам): темы обычно группируются вокруг '
    'политики/власти, экономики, происшествий, спорта, культуры — конкретные '
    'лейблы зависят от подвыборки mlsum/ru. Сравнивая sklearn и gensim LDA, '
    'ожидаем похожие кластеры лексики при разной нумерации тем.'
)

# sanity: предсказание доминирующей темы для пары тестовых документов
dom = lda_sk.transform(X_test_counts[:3]).argmax(axis=1)
for i, t in enumerate(dom):
    print(f'test doc {i}: dominant topic {t}; snippet: {test_df["clean"].iloc[i][:120]}...')
''')

nb['cells'] = cells
nb['metadata'] = {
    'kernelspec': {'display_name': 'Python 3', 'language': 'python', 'name': 'python3'},
    'language_info': {'name': 'python'},
}
out = Path(__file__).with_name('pz3.ipynb')
nbf.write(nb, out)
print('wrote', out)
