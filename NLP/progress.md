# Прогресс — Обработка естественного языка

Обновлено: 2026-11-19 22:05

## Работы

| № | Работа | Статус | Срок | Баллы | Файлы решения |
|---|---|---|---|---|---|
| ЛР 1 | PyTorch, полносвязные сети, Word2Vec | сдана | не указан | 12 | `solution/lab1/lab1.ipynb`, `solution/lab1/preprocessing.ipynb`, `solution/lab1/processed/` |
| ЛР 2 | RNN, LSTM, GRU для классификации текстов | готова | не указан | 12 | `solution/lab2/lab2.ipynb`; альт. `solution/lab2/lab2_zhaloby.ipynb` |
| ЛР 3 | Transformer / GPT | готова | не указан | 12 | `solution/lab3/lab3.ipynb` |
| ЛР 4 | Суммаризация и вопросно-ответные системы | — | не указан | 12 | условие на вики не размещено |
| ЛР 5 | Тонкая настройка LLM с LoRA | — | не указан | 12 | условие на вики не размещено |
| ПЗ 1 | Парсинг hh.ru (многопоточность) | готова | не указан | 5 | `solution/pz1/pz1.ipynb`, `vacancies_dataset.pkl/csv` |
| ПЗ 2 | Внимание в RNN поверх ЛР 2 | готова | не указан | 5 | `solution/pz2/pz2.ipynb` |
| ПЗ 3 | Тематическое моделирование sklearn/gensim | готова | не указан | 5 | `solution/pz3/pz3.ipynb` |
| ПЗ — | Дистилляция и квантование LLM | заблокирована | не указан | 5 | текста условия на вики нет |

## Карта ПЗ 1 (hh.ru)

Источники: `materials/notes/disciplines__nlp__laboratory-works__hh.md`; лекция `notes/disciplines__nlp__lectures__preprocessing.md`; материалы concurrent.futures в hh.md.

Требования:
- [x] Изучить API hh.ru — hh.md п.1
- [x] Многопоточный сбор вакансий (описание, зарплатная вилка, работодатель); асинхронность по возможности — hh.md п.2
- [x] Предварительная обработка описаний — hh.md п.3; preprocessing
- [x] Сохранить датасет — hh.md п.4

Критерии приёмки:
- [x] Сбор в нескольких потоках — hh.md
- [x] Выполнена предобработка — hh.md
- [x] Датасет сохранён и читается без API — hh.md

Делает студент руками: нет

Отчёт: нет

Проверка запуском: `"$USERPROFILE/.venvs/studies2026-nlp/Scripts/python" -m jupyter nbconvert --to notebook --execute solution/pz1/pz1.ipynb --output-dir "$TMP/nbcheck"` (нужен интернет при первом сборе; далее кэш `vacancies_raw.pkl`)

Вне курса: заголовок User-Agent API hh; кэш pickle/CSV — в материалах только ссылка на API и concurrent.futures.

## Карта ПЗ 2 (attention)

Источники: `materials/notes/disciplines__nlp__laboratory-works__attention.md`; база — ЛР 2 / `materials/Лаб2.md`; идея dot-product — лекция `notes/disciplines__nlp__lectures__nmt-2.md`.

Требования:
- [x] Основа — классификация из ЛР 2 — attention.md п.1
- [x] Attention-слой: $e_i=\langle h_i,h_n\rangle$, softmax, $c=[h_n|\sum\alpha_i h_i]$ — п.2
- [x] Встроить в RNN, LSTM, GRU; FC на векторе $c$ — п.3
- [x] Метрики и сравнение с без внимания — п.4

Критерии приёмки:
- [x] Слой внимания сформирован
- [x] Встроен в RNN/LSTM/GRU из ЛР 2
- [x] Сравнение метрик выполнено

Делает студент руками: нет

Отчёт: нет

Проверка запуском: `"$USERPROFILE/.venvs/studies2026-nlp/Scripts/python" -m jupyter nbconvert --to notebook --execute solution/pz2/pz2.ipynb --inplace`

Вне курса: маска padding до softmax; в методичке в знаменателе softmax написано $\sum e_j$ — используем $\sum\exp(e_j)$ по определению softmax / лекции.

## Карта ПЗ 3 (topic modeling)

Источники: `materials/notes/disciplines__nlp__laboratory-works__gensim-sklearn-topic-modeling.md`; данные — ссылки из архивной ЛР 5 `notes/disciplines__nlp__laboratory-works__topic-modeling.md` (mlsum/ru parquet), т.к. текста ЛР 5 2026 нет.

Требования:
- [x] Данные train/test из ЛР 5 — gensim-sklearn п.1
- [x] LDA (sklearn и gensim), NMF (sklearn и gensim), SVD/LSA (sklearn) — п.2
- [x] Интерпретация тем — п.3

Критерии приёмки:
- [x] Изучены возможности библиотек
- [x] Тематическое моделирование выполнено указанными объектами
- [x] Темы проинтерпретированы

Делает студент руками: нет

Отчёт: нет

Проверка запуском: `"$USERPROFILE/.venvs/studies2026-nlp/Scripts/python" -m jupyter nbconvert --to notebook --execute solution/pz3/pz3.ipynb --output-dir "$TMP/nbcheck"` (первый прогон качает parquet в `%USERPROFILE%\.cache\studies2026-nlp\mlsum-ru`)

Вне курса: API gensim `LdaModel`/`Nmf`, sklearn `LatentDirichletAllocation`/`NMF`/`TruncatedSVD`; размер подвыборки статей методичка не фиксирует.

**Замечание по нумерации:** на вики 2026 третья практика в списке — «дистилляция и квантование» без ссылки. ПЗ 3 здесь = тематическое моделирование (четвёртая в списке вики, первая после двух готовых с текстом).

## Карта ЛР 3

Источники: `materials/Лаб3.md` (= `notes/disciplines__nlp__laboratory-works__gpt.md`); `task.md` §ЛР 3 (выше методички по порядку доверия); лекции `notes/disciplines__nlp__lectures__transformer-2.md` (PE, masked self-attention, FFN, Residual+LN); `notes/disciplines__nlp__lectures__bert-gpt-2.md` — для decoder-only/CLM при ЛР 3 (в INDEX помечена как ЛР 4–5, но по теме GPT нужна здесь); `NLP/rules.md` (структура ноутбука = «Ход работы»).

Требования:
- [x] Корпус: Tiny Stories train+valid с HF, **урезанный subset** (полный train не кладём в OneDrive) — Лаб3.md п.1; решение студента 2026-11-13
- [x] Загрузка; токенизация и нумерация токенов; разделение историй на начало и конец (для инференса/отчёта по п.2; обучение — по схеме B ниже); предобработка любыми инструментами — Лаб3.md п.2
- [x] Схема обучения: **(B) causal LM (CLM)** на последовательности; «начало» — промпт на инференсе, генерация продолжения — Лаб3.md п.2/п.5 + bert-gpt-2 CLM; решение студента 2026-11-13
- [x] Padding до одной длины; батчи по желанию — Лаб3.md п.3
- [x] Decoder-only на слоях PyTorch: стек декодер-блоков **без Encoder и без cross-attention**; в блоке — masked self-attention (+ PE), FFN, Residual, LayerNorm (transformer-2); LM-head (linear → словарь) + CE; допускается 1 голова; несколько блоков в одной модели — Лаб3.md п.4, критерии, bert-gpt-2
- [x] Запрет: не `torch.nn.Transformer`, `TransformerEncoder`, `TransformerDecoder`, `TransformerEncoderLayer`, `TransformerDecoderLayer` и аналоги torchtext — task.md; Лаб3.md п.4; решение студента 2026-11-13
- [x] Обучение без ошибок; инференс на нескольких примерах valid; генерация своих историй — Лаб3.md п.5; качество не смотрят
- [x] Ноутбук `solution/lab3/lab3.ipynb`: секции 1–5 = пункты «Хода работы» Лаб3.md — `NLP/rules.md`

Критерии приёмки:
- [x] Набор данных загружен и обработан — Лаб3.md
- [x] Реализована decoder-only модель (без Encoder / cross-attn) — Лаб3.md; bert-gpt-2
- [x] Модель обучена и протестирована: обучение без ошибок; **качество не оценивается** — Лаб3.md
- [x] Структура ноутбука по ходу работы 1–5 — rules.md

Делает студент руками: нет

Отчёт: нет

Проверка запуском: `"$USERPROFILE/.venvs/studies2026-nlp/Scripts/python" -m jupyter nbconvert --to notebook --execute solution/lab3/lab3.ipynb --output-dir "$TMP/nbcheck"` (venv уже есть)

Ловушки / защита (Лаб3.md epigraph: качество не смотрят, но спрашивают код и подходы):
- Примеры из раздела «Материалы» Лаб3 (Kaggle/vc.ru) часто полный Encoder–Decoder — **не копировать как архитектуру задания**
- Лекция transformer-2 описывает Decoder с K/V от Encoder — для GPT этого слоя нет
- Готовить пояснения: causal mask, PE, CLM vs схема A, состав блока

Вне курса (общие знания с пометкой):
- Скачивание TinyStories (urllib/HF); хранение вне OneDrive или gitignore при большом объёме — в материалах только ссылки
- Токенизатор (пробельный / символьный / BPE): «любые инструменты» — Лаб3.md п.2
- API causal mask / `nn.MultiheadAttention` — идея в transformer-2; синтаксис — доки PyTorch
- Гиперпараметры (N блоков, dim, seq_len, размер subset): методичка не фиксирует
- Готовый GPT с HF как «свою» модель не использовать

### Проверка ЛР 3 (plan, 2026-11-13)
Вердикт: **доработать карту** (первичный). После ответов студента и доработки — повтор.

### Проверка ЛР 3 (plan, 2026-11-13 повтор)
Вердикт: **начинать**. Предыдущие HIGH/MED закрыты. LOW: уточнён запрет `Transformer*Layer`.

### Проверка ЛР 3 (solution, 2026-11-13)
Вердикт: **сдавать**. nbconvert EXIT 0 (~70–76 с). Acceptance: все met.
- MED: гиперпараметры в log «Решения» — закрыто записью ниже
- MED: pre-LN vs post-LN — пояснение добавлено в markdown §4
- LOW: формулировка split в §2 — уточнена

## Карта ЛР 2

Источники: `materials/Лаб2.md`; лекции `materials/notes/disciplines__nlp__lectures__rnn-2.md`, `materials/notes/disciplines__nlp__lectures__preprocessing.md`; датасет `materials/dataset/Petitions.csv`

Требования:
- [x] Загрузка датасета «просьбы жильцов», часть корпуса, предобработка текстов (п.1–2, Лаб2.md; preprocessing)
- [x] Токенизация и векторизация токенов (п.3; Embedding — rnn-2)
- [x] Кодирование целевого признака `reason_category`, train/test (п.4)
- [x] Обучение трёх сетей: RNN, LSTM, GRU, Many-to-One (п.5; rnn-2)
- [x] Метрики классификации на тесте и вывод, какая модель лучше (п.6)
- [x] Собственный GRU-блок по формулам лекции и сеть с ним, метрики (п.7)

Критерии приёмки:
- [x] Корпус обработан, токенизирован, токены векторизованы
- [x] Целевой признак кодирован; данные разделены на train/test
- [x] Обучены 3 модели: RNN, LSTM, GRU
- [x] Качество оценено на тестовой выборке
- [x] Реализован класс GRU для последовательностей
- [x] Сеть с собственным GRU обучена, метрики посчитаны

Делает студент руками: нет

Отчёт: нет

Проверка запуском: `"$USERPROFILE/.venvs/studies2026-nlp/Scripts/python" -m jupyter nbconvert --to notebook --execute solution/lab2/lab2.ipynb --output-dir "$TMP/nbcheck"`

Вне курса (общие знания):
- scikit-learn: `LabelEncoder`, `train_test_split`, метрики classification — в лекциях NLP поимённо не разобраны, стандартный стек курса
- Размер выборки, словарь, эпохи — методичка оставляет на усмотрение
- `pack_padded_sequence`, `class_weight` в CrossEntropyLoss — общие знания / доки PyTorch; в Карте отмечено как Many-to-One по `h_T` (лекция rnn-2)

## Проверка ЛР 2 (solution)

Предыдущий прогон (2026-11-07 09:59): выборка 6000, 4 эпохи, словарь на всём корпусе, Many-to-One через последний шаг с PAD → скептик: **доработать** (MED).

Исправления 2026-11-07 10:19 (v2), закрытие MED:
- [x] Many-to-One: `pack_padded_sequence` + `h_n[-1]` / цикл CustomGRU по реальной длине
- [x] Словарь только на train; OOV → UNK
- [x] Дообучение: SAMPLE=8000, EPOCHS=8, class weights; сравнение с majority accuracy
- [x] Секции ноутбука 1–7 = пункты «Хода работы»
- [x] (LOW) комментарий про разрыв accuracy vs macro-F1; ссылки на источники

Прогон CPU без ошибок. majority≈0.5806. Тест: RNN 0.5406/0.2971, LSTM 0.5944/0.3591, GRU 0.6519/0.4213, CustomGRU 0.6506/0.4523 (accuracy/macro-F1). Лучший macro-F1 — CustomGRU; из трёх блоков методички — `nn.GRU`.

### Проверка ЛР 2 (solution, 2026-11-07 10:26)
Вердикт: **сдавать**. Прежние MED 1–5 закрыты. Acceptance: все met. Новый MED (RNN accuracy < majority) закрыт пояснением в §6 про class_weight. LOW: encode/split в ячейке §3 (помечено как начало п.4) — не блок.

### Проверка ЛР 2 (solution, 2026-11-13)
Вердикт: **блок**. Свежий `nbconvert` падает до §7.
- [x] HIGH: cell 15 SyntaxError — закрыт 2026-11-13 (литералы убраны, полный прогон)
- [x] MED: CustomGRU на свежем execute — закрыт (метрики совпали)
- LOW: encode/split физически в ячейке §3

### Проверка ЛР 2 (solution, 2026-11-13 после фикса)
Вердикт: **сдавать**. Acceptance: все met. nbconvert EXIT 0 (~4 мин). Метрики: RNN 0.5406/0.2971, LSTM 0.5944/0.3591, GRU 0.6519/0.4213, CustomGRU 0.6506/0.4523. LOW: encode/split в §3.

## Карта ЛР 1

Источники: `materials/Лаб1.md`, `materials/Извлечение признаков из тектовых данных.md`

Требования:
- [ ] Загрузка и предобработка датасетов для регрессии и классификации (п.1)
- [ ] Dataset и DataLoader для каждого датасета (п.2)
- [ ] Полносвязные нейросети через torch.nn, классификация через softmax (п.3)
- [ ] Обучение: функции активации, оптимизаторы, обнуление градиентов, графики ошибки (п.4)
- [ ] Оценка качества метриками (п.5)
- [ ] Загрузка и предобработка текстового датасета (Petitions.csv) (п.6-7)
- [ ] Собственная реализация CBoW и SkipGram в PyTorch (п.8)
- [ ] Контекстные эмбеддинги, PCA для уменьшения размерности (п.9)
- [ ] Сохранение в TSV, визуализация в Projector/TensorBoard (п.10)

Критерии приёмки:
- [ ] Данные загружены и предобработаны, train/test split выполнен
- [ ] Для каждой задачи обучена полносвязная нейросеть
- [ ] Качество оценено на тестовой выборке
- [ ] Текстовый датасет загружен и обработан
- [ ] Собственная реализация CBoW и SkipGram
- [ ] Векторные представления сохранены и визуализированы

## План выполнения ЛР 1 (по Ходу работы)

**Структура ноутбука `solution/lab1/lab1.ipynb`:**

### 1. Импорты и настройка окружения
- torch, torch.nn, torch.optim
- scikit-learn (train_test_split, метрики)
- matplotlib (графики)
- pandas, numpy

### 2. Предобработка датасетов для регрессии и классификации
- Загрузка neo_task.csv (классификация) и winequality_processed.csv (регрессия)
- Train/test split (stratify для классификации)
- Нормализация признаков (по материалам — если требуется)

### 3. Dataset и DataLoader
- Создание класса TabularDataset (наследник torch.utils.data.Dataset)
- DataLoader для neo_task (batch_size, shuffle)
- DataLoader для winequality (batch_size, shuffle)

### 4. Полносвязные нейросети
- Класс ClassificationNN: вход → скрытые слои → softmax на выходе
- Класс RegressionNN: вход → скрытые слои → 1 нейрон на выходе
- Dropout слои (опционально, по материалам)

### 5. Обучение нейросетей
- Функции потерь: CrossEntropyLoss (классификация), MSELoss (регрессия)
- Оптимизаторы: Adam или SGD (по материалам)
- Цикл обучения: forward → loss → backward → optimizer.step → optimizer.zero_grad
- Графики loss по эпохам

### 6. Оценка качества
- Классификация: accuracy, precision, recall, F1
- Регрессия: MSE, MAE, R2

### 7. Предобработка текстового датасета (Petitions.csv)
- Загрузка, выбор столбца с текстом
- Нижний регистр, удаление спецсимволов
- Токенизация
- Удаление стоп-слов (опционально)
- Лемматизация (по материалам — если для русского текста)

### 8. CBoW в PyTorch
- Создание словаря
- Подготовка данных: контекст → целевое слово
- Класс CBoWModel: Embedding → скрытый слой → CrossEntropyLoss
- Обучение

### 9. SkipGram в PyTorch
- Подготовка данных: целевое слово → контекст
- Класс SkipGramModel: Embedding → скрытый слой → CrossEntropyLoss
- Обучение

### 10. Контекстные эмбеддинги и PCA
- Извлечение матрицы эмбеддингов из обученных моделей
- PCA для уменьшения размерности (2-3 компонента)
- Сохранение в TSV: эмбеддинги, метки слов

### 11. Визуализация
- Использование TensorBoard или Projector
- Загрузка TSV файлов

## Датасеты
- neo_task.csv — классификация опасности астероидов (hazardous)
- winequality_processed.csv — регрессия качества вина (quality)
- Petitions.csv — текстовый датасет для Word2Vec

## Вне курса (общие знания)
- PyTorch: Dataset, DataLoader, nn.Module, CrossEntropyLoss, Embedding
- scikit-learn: train_test_split, метрики
- PCA из sklearn.decomposition

## Следующий шаг

Сдать ПЗ 1–3 и ЛР 2–3 преподавателю. Дистилляция — ждать текст условия на вики.

## Датасеты для ЛР 1
- neo_task.csv — классификация опасности астероидов (hazardous)
- winequality_processed.csv — регрессия качества вина (quality)
- Petitions.csv — текстовый датасет для Word2Vec (петиции жильцов)

## Текущий фокус
ПЗ 1–3: статус `готова` (прогоны nbconvert OK). Сдать вместе с ЛР 2–3. Дистилляция заблокирована.

## Открытые вопросы
- Сроки сдачи на вики не указаны. Баллы на странице 2026: ЛР по 12, практики по 5, ДЗ 20. Правила осени 2024 считают иначе (ЛР по 10, практики по 6, РГР 20). Какая шкала действует, не выбрано.
- Тексты ЛР 4, ЛР 5 и практической задачи про дистилляцию и квантование на вики не размещены.
- ПЗ «тематическое моделирование» ссылается на данные ЛР 5; условия ЛР 5 2026 нет — взяты ссылки mlsum из архивной ЛР BigARTM. Подтвердить у преподавателя, если нужен другой корпус.
- Номер варианта ЛР 1 явно не записан. Уже используемые датасеты совпадают с К2 и Р5 из `materials/lab1-variants.csv`.
- Тег сдачи `nlp-lab1-submitted` в Git — ещё не ставили; при необходимости сделать после подтверждения.
- ~~ЛР 3, запрет Transformer / датасет / схема A|B~~ — закрыто 2026-11-13: запрет любого готового `nn.Transformer*`; TinyStories subset; схема B (CLM).

## Открытые вопросы ЛР 1
- Размерность PCA — задать самостоятельно (использовать 2-3 компоненты)
- Количество эпох — определить экспериментально (10-50)
- Размер батча — 32-64
- Скрытые слои — определить архитектуру (по материалам)

## Правила оформления
См. `rules.md` — оформление ноутбуков, требования к коду, проверка
