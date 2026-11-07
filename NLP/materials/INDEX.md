# Материалы — Обработка естественного языка

Снимок страницы [wiki.pmifi.ru/disciplines/nlp](https://wiki.pmifi.ru/disciplines/nlp) от 2026-11-07. На вики страница обновлена 2026-11-06 (Михаил Гуненков). Текст страниц лежит в `notes/`, картинки лекций — в `img/`, ноутбуки — в `notebooks/`.

## Баллы и сроки

| Блок | Баллы | Где текст |
|---|---|---|
| ЛР 1–5 | по 12, всего 60 | ЛР 1–3 скачаны; у ЛР 4 и 5 на странице 2026 есть название и баллы, ссылки на условие нет |
| Практические задачи | 20, по 5 за задачу | три задачи со ссылкой, одна только названием |
| Домашнее задание | 20, обязательно для зачёта на любую оценку | `notes/disciplines__nlp__hometasks__agent-harness.md` |

Срока сдачи на вики нет.

Правила оценивания осени 2024 (`notes/disciplines__nlp__assessment.md`) считают иначе: ЛР по 10 баллов, практические по 6, плюс РГР 20. Это другой документ. Какая шкала действует в 2026, по материалам не выбрать.

## Файлы текущего курса (осень 2026)

| Файл | Текст | Что внутри | Когда нужен |
|---|---|---|---|
| `notes/disciplines__nlp.md` | — | Оглавление дисциплины: лекции, ЛР, практики, ДЗ, ссылка на рейтинг | старт |
| `notes/disciplines__nlp__lectures__preprocessing.md` | — | Предобработка текста (лекция 2025, стоит в оглавлении 2026) | ЛР 1, практики |
| `notes/disciplines__nlp__lectures__vectorization.md` | — | Векторные представления | ЛР 1 |
| `notes/disciplines__nlp__lectures__rnn-2.md` | — | RNN, LSTM, GRU | ЛР 2 |
| `notes/disciplines__nlp__lectures__nmt-2.md` | — | Encoder-Decoder, машинный перевод | практика «внимание» |
| `notes/disciplines__nlp__lectures__transformer-2.md` | — | Transformer, Attention is all you need | ЛР 3 |
| `notes/disciplines__nlp__lectures__bert-gpt-2.md` | — | Transfer learning: BERT, GPT | ЛР 4–5, когда появятся условия |
| `notes/disciplines__nlp__lectures__problem-solving.md` | — | Прикладные задачи NLP | ЛР 4, когда появится условие |
| `notes/disciplines__nlp__lectures__ssm.md` | — | SSM, Mamba | лекция |
| `notes/disciplines__nlp__lectures__xlstm.md` | — | xLSTM | лекция |
| `notes/disciplines__nlp__lectures__llms.md` | — | LLM и RAG | ДЗ |
| `notes/disciplines__nlp__lectures__training-reasoning.md` | — | Обучение и рассуждения в LLM | ДЗ, ЛР 5 |
| `Лаб1.md` | [notes](notes/disciplines__nlp__laboratory-works__torch-w2v.md) | ЛР 1: полносвязная сеть и Word2Vec, 12 баллов | ЛР 1 |
| `Лаб2.md` | [notes](notes/disciplines__nlp__laboratory-works__rnn.md) | ЛР 2: классификация текстов RNN/LSTM/GRU и свой GRU, 12 баллов | ЛР 2 |
| `Лаб3.md` | [notes](notes/disciplines__nlp__laboratory-works__gpt.md) | ЛР 3: decoder-only GPT, 12 баллов | ЛР 3 |
| `notes/disciplines__nlp__laboratory-works__hh.md` | — | Практика: парсинг вакансий hh.ru, 5 баллов | практика |
| `notes/disciplines__nlp__laboratory-works__attention.md` | — | Практика: внимание в RNN поверх ЛР 2, 5 баллов | практика |
| `notes/disciplines__nlp__laboratory-works__gensim-sklearn-topic-modeling.md` | — | Практика: LDA, NMF, SVD/LSA в sklearn и gensim, 5 баллов. Данные берёт из ЛР 5, текста ЛР 5 на вики нет | практика |
| `notes/disciplines__nlp__hometasks__agent-harness.md` | — | ДЗ: агентский харнесс и MiniWiki, 20 баллов | ДЗ |
| `lab1-variants.csv` | — | Таблица вариантов ЛР 1: К1–К8 (классификация) и Р1–Р8 (регрессия), ссылка на данные и имя целевого признака. ФИО в таблице нет | ЛР 1 |
| `dataset/Petitions.csv` | — | «Просьбы жильцов», 13 257 901 байт. Столбцы: `id`, `public_petition_text`, `reason_category` | ЛР 1 (Word2Vec), ЛР 2 (категория — `reason_category`) |
| `files/2026_титульник_дз_нлп_бугаенко.docx` | [notes](notes/titul-dz-bugaenko-2026.md) | Титульный лист ДЗ, преподаватель Бугаенко | ДЗ |
| `files/Правила оформления отчетов и ПЗ.docx` | [notes](notes/pravila-oformleniya-otchetov.md) | Требования к отчёту, на которые ссылается ДЗ | ДЗ |
| `files/Для студентов ГОСТ 7.0.100-2018.docx` | [notes](notes/gost-7-0-100-2018.md) | Оформление списка источников | ДЗ |
| `files/Список использованных источников.pptx` | — | Слайды к оформлению списка источников | ДЗ |
| `pytorch.txt` | — | Две ссылки на документацию PyTorch, уже были в папке | ЛР 1 |
| `Введение_в_PyTorch.ipynb` | — | Ноутбук, который уже лежал в папке до этого снимка | ЛР 1 |

Картинки лекций, на которые ссылаются конспекты, лежат в `img/`.

## Ноутбуки с вики

| Файл | Откуда |
|---|---|
| `notebooks/Введение в PyTorch.ipynb` | ЛР 1, ноутбук по тензорам |
| `notebooks/Предварительная обработка текстовых данных.ipynb` | лекция по предобработке, пометка «старый ноутбук» |
| `notebooks/Предварительно обученные модели для векторизации текстовых данных.ipynb` | лекция по векторизации |
| `notebooks/Предварительно обученные модели для векторизации текстовых данных 2024.ipynb` | та же тема, вариант 2024 |
| `notebooks/Работа с текстовыми данными в torchtext и torchdata. PyTorch Advanced.ipynb` | оглавление 2024 |
| `notebooks/Использование моделей с Hugging Face.ipynb` | лекция по прикладным задачам |
| `notebooks/Sentence Transformers.ipynb` | лекция NLU |
| `notebooks/Spacy.ipynb` | лекции NLU и прикладных задач |
| `notebooks/Тематическое моделирование с использованием аддитивной регуляризации.ipynb` | тематическое моделирование |
| `notebooks/Тематическое моделирование с использованием трансформеров.ipynb` | тематическое моделирование |
| `notebooks/Тематическое моделирование с использованием трансформеров V2.ipynb` | тематическое моделирование |
| `notebooks/Распознавание и синтез речи (Crash Course).ipynb` | лекция по речи; пример `files/respect.wav` |

## Архив (страницы прошлых лет, на которые ведёт вики)

Оглавления: `notes/disciplines__nlp__2024.md`, `notes/disciplines__nlp__2025.md`. Это не задание осени 2026, пока страница 2026 на них не ссылается как на текущую работу.

| Файл | Что внутри |
|---|---|
| `notes/disciplines__nlp__assessment.md` | Правила оценивания, осень 2024 |
| `notes/disciplines__nlp__questions.md` | Контрольные вопросы к зачёту (обновлены на вики 2024-12-05) |
| `notes/disciplines__nlp__practical-tasks.md` | Пять практических заданий прежнего списка |
| `notes/disciplines__nlp__hometasks__rag.md` | ДЗ 2025: интеллектуальный поиск (RAG) |
| `notes/disciplines__nlp__laboratory-works__homework-2025.md` | ДЗ бакалавров ФИТ-МО-23 |
| `notes/disciplines__nlp__laboratory-works__torch.md` | Прежняя ЛР: только полносвязная сеть, без Word2Vec |
| `notes/disciplines__nlp__laboratory-works__word2vec.md` | Прежняя ЛР: отдельный Word2Vec |
| `notes/disciplines__nlp__laboratory-works__seq2seq.md` | Прежняя ЛР: нейронный машинный перевод |
| `notes/disciplines__nlp__laboratory-works__topic-modeling.md` | Прежняя ЛР: тематическое моделирование новостей |
| `notes/disciplines__nlp__laboratory-works__applied-nlp-problems.md` | Прежняя ЛР: кластеризация отзывов. Название близко к ЛР 4 2026, но страница 2026 на неё не ссылается |
| `notes/disciplines__nlp__lectures__rnn.md`, `nmt.md`, `transformer.md`, `bert-gpt.md`, `word2vec.md`, `topic-modeling.md`, `nlu.md`, `agents.md`, `speech.md`, `topic-modeling-2.md`, `topic-modeling-in-practice.md` | Лекции прошлых редакций |
| `files/титульник_дз_нлп_бугаенко.docx`, `files/титульник_дз_нлп_гуненков.docx`, `files/NLP ДЗ Титульник.docx` | Титульные листы прежних домашних заданий |
| `files/constitutionrf.docx` | База знаний ДЗ 2025 (текст Конституции РФ) |
| `Извлечение признаков из тектовых данных.md` | Конспект, который уже лежал в папке. Совпадает по теме с лекцией `notes/disciplines__nlp__lectures__word2vec.md` |

## Что не положено в репозиторий

- Рейтинг группы — в таблице есть ФИО. В `notes/disciplines__nlp.md` оставлена только ссылка.
- Расписания консультаций. В файле на вики прямо сказано, что график меняется и локальную копию лучше не хранить. Ссылка — в `notes/disciplines__nlp.md`.
- TinyStories (обучающая и тестовая выборки ЛР 3) — большие файлы на Hugging Face, ссылки в `Лаб3.md`.
- Набор предложений Яндекс Переводчика для архивной ЛР seq2seq — Google Drive не отдал файл без входа.
- Картинки старых лекций с `storage.yandexcloud.net` отвечают 404. В конспектах архивных лекций ссылки оставлены как на вики.
- PDF статей, на которые ссылаются лекции, не скачивались: в конспекте есть адрес статьи.

## Замечания

- ЛР 4 и ЛР 5 на странице 2026 названы, страниц с условием нет (проверены прямые адреса, ответ 404).
- Практическая задача «Оптимизация весов больших языковых моделей (дистилляция и квантование)» на странице 2026 без ссылки.
- Консультации Бугаенко на странице 2026: «скоро».
- Варианты ЛР 1 в `lab1-variants.csv`. Файл `dataset/Lab1K2_R5ipynb (1).ipynb` и уже используемые `neo_task.csv` (признак `hazardous`) и wine quality (признак `quality`) совпадают с вариантами К2 и Р5 этой таблицы.
- В `Petitions.csv` целевой признак для ЛР 2 — столбец `reason_category`.
