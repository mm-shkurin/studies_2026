# ЛР 9. Курсоры

Предметная область — чемпионат «Формула-1», база `formula1` из лабораторной 2. Работа соответствует практической работе пособия (стр. 147): несколько задач с курсором внутри хранимой процедуры и отчёт. В образце две задачи, листинги сверены по PDF, стр. 147 и 150. Возврат открытого курсора из функции разобран в теории (стр. 141, 146) и в эти две задачи не входит.

## Что сделано

1. Процедура `result_select(p_race_id, p_driver_id, p_car_id)` — перенос `order_select`. Курсор связан с запросом в секции `DECLARE`. Цикл `OPEN` / `FETCH` / `EXIT WHEN NOT FOUND` / `CLOSE`. Каждая строка печатается через `RAISE NOTICE`. `NULL` в параметре означает «не фильтровать». Параметры названы с приставкой `p_`: в образце имя параметра `order_id` не совпадает со столбцом `ord_id`, а имя `race_id` после приведения регистра совпало бы со столбцом `race_ID`. В сообщении те же по смыслу поля, что в образце: код и название гонки, код и имя пилота, код и модель болида, место и очки.
2. Таблица `may_results` и процедура `fill_may` — перенос `ord_febr`. Курсор читает результаты гонок с датой от 1 до 31 мая 2026 и вставляет их в пустую таблицу. В образце отбор — февраль 2023 и литералы `'01-02-2023'`. Здесь стоят литералы `DATE '...'`: строка из образца зависит от `DateStyle` сервера. Процедура сама строки не удаляет. Перед вызовом проверочный скрипт выполняет `TRUNCATE may_results`, чтобы повторный запуск не удвоил строки.

## Контрольные данные

Две команды, два пилота, три болида, две гонки, четыре результата. Места внутри одной гонки разные, иначе сработает `results_position_UQ`.

| Гонка | Дата | Пилот | Болид | Место |
|---|---|---|---|---|
| 1, Monaco Grand Prix | 2026-05-24 | 1, Charles Leclerc | 1, SF-24 | 1 |
| 1 | 2026-05-24 | 2, Lewis Hamilton | 2, W15 | 2 |
| 2, British Grand Prix | 2026-07-05 | 2, Lewis Hamilton | 2, W15 | 1 |
| 2 | 2026-07-05 | 1, Charles Leclerc | 3, SF-24B | 2 |

Ожидание: все параметры `NULL` — 4 сообщения; только гонка 1 — 2; только пилот 1 — 2; только болид 1 — 1 (во второй гонке Леклер едет на другом болиде); гонка 1 и пилот 1 — 1. В `may_results` после `fill_may` две строки майской гонки.

## Файлы

| Файл | Что делает |
|---|---|
| `cursors.sql` | Обе процедуры и таблица `may_results` |
| `check_cursors.sql` | Контрольные строки и пять вызовов |
| `check_output.txt` | Вывод проверки на PostgreSQL 15 |
| `build_report.py` | Сборка `report.docx` |

## Проверка запуском

База создаётся заново, как в лабораторной 8: `DROP DATABASE`, `CREATE DATABASE` с локалью `en_US.utf8` вместо `Russian_Russia.1251`, затем `02_create_tables.sql`. Скрипт `03_check.sql` не запускать: он откатывает данные.

```text
docker exec -i dbms-pg psql -U postgres -d formula1 -v ON_ERROR_STOP=1 < solution/lab9/cursors.sql
docker exec -i dbms-pg psql -U postgres -d formula1 -v ON_ERROR_STOP=1 < solution/lab9/check_cursors.sql
```

## Скриншоты

Снимает студент в своём pgAdmin, вкладка Messages, и кладёт в `img/`:

| Файл | Вызов |
|---|---|
| `01_select_all.png` | `CALL result_select(NULL, NULL, NULL);` |
| `02_select_race.png` | `CALL result_select(1, NULL, NULL);` |
| `03_select_driver.png` | `CALL result_select(NULL, 1, NULL);` |
| `04_select_car.png` | `CALL result_select(NULL, NULL, 1);` |
| `05_select_pair.png` | `CALL result_select(1, 1, NULL);` |
| `06_may_results.png` | содержимое `may_results` после `CALL fill_may();` |

После этого выполнить `python build_report.py`.
