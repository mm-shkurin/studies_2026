# ЛР 4: Работа с массивами и типами JSON

## Структура решения

- `01_create_array_table.sql` — создание таблицы `driver_season_races` с массивом `race_ids`
- `02_create_json_table.sql` — создание таблицы `driver_stats` с JSONB-полем `stats`
- `03_insert_data.sql` — заполнение таблиц тестовыми данными
- `04_array_operations.sql` — операции с массивами (добавление, удаление, выборки)
- `05_json_operations.sql` — операции с JSON (выборки, обновления)

## Проверка запуском

Требуется запущенный контейнер PostgreSQL 15 в Docker:

```bash
# Запуск контейнера (если не запущен)
docker start dbms-pg

# Выполнение скриптов в базе formula1
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/01_create_array_table.sql
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/02_create_json_table.sql
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/03_insert_data.sql
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/04_array_operations.sql
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/05_json_operations.sql
```

Или выполнить все скрипты подряд:

```bash
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/01_create_array_table.sql && \
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/02_create_json_table.sql && \
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/03_insert_data.sql && \
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/04_array_operations.sql && \
docker exec -i dbms-pg psql -U postgres -d formula1 < solution/lab4/05_json_operations.sql
```

## Запуск в pgAdmin

1. Открыть pgAdmin 4
2. Подключиться к базе `formula1`
3. Открыть Query Tool
4. Выполнить скрипты по порядку: 01 → 02 → 03 → 04 → 05
5. Сделать скриншоты результатов выполнения

## Описание таблиц

### driver_season_races (массив)

Таблица для хранения графика гонок пилота в конкретном сезоне. Связь с `drivers` — 1:N.

- `season_id` (serial, PK) — ID записи
- `driver_ID` (integer, FK) — ID пилота
- `year` (integer) — год сезона
- `race_ids` (integer[]) — массив ID гонок сезона

### driver_stats (JSONB)

Таблица для хранения статистики пилота в формате JSON. Связь с `drivers` — 1:1.

- `stats_id` (serial, PK) — ID записи
- `driver_ID` (integer, UNIQUE, FK) — ID пилота
- `stats` (jsonb) — JSON-объект с полями:
  - `wins` — количество побед
  - `podiums` — количество подиумов
  - `pole_positions` — количество поул-позиций
  - `fastest_laps` — количество быстрых кругов
  - `championships` — количество чемпионских титулов
  - `points` — набранные очки

## Операции с массивами

- Конкатенация (`||`) — добавление элемента
- `array_append()` — добавление в конец
- `array_prepend()` — добавление в начало
- `array_remove()` — удаление элемента
- Обращение по индексу — изменение элемента
- Срез (`[1:5]`) — замена диапазона элементов
- `array_position()` — поиск индекса элемента
- Оператор `@>` — проверка вхождения всех элементов
- Оператор `&&` — проверка наличия общих элементов
- `unnest()` — разворачивание массива в столбец

## Операции с JSON

- Оператор `->>` — получение значения по ключу как текст
- Оператор `->` — получение значения по ключу как JSON
- Оператор `?` — проверка наличия ключа
- `jsonb_set()` — обновление значения по пути
- Оператор `||` — объединение JSON-объектов
- Оператор `-` — удаление ключа

## Источники

- Учебное пособие, ЛР 5, стр. 90–100
- Приложение (типы данных), стр. 164
