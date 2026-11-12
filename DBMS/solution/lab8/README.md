# ЛР 8. Транзакции и триггеры

Предметная область — чемпионат «Формула-1», база `formula1` из лабораторной 2. Текст задания — из EduCab: изучить пособие стр. 130–140 и 151–159; для созданной БД сделать явную транзакцию с точкой сохранения, три триггера модификации данных и два триггера событий, оформить отчёт.

## Что сделано

1. Явная транзакция с `SAVEPOINT` по образцу практической работы пособия (стр. 139–140). В таблицу `teams` вставляются Ferrari и Mercedes, ставится точка `sp_teams`, затем Red Bull и McLaren; `ROLLBACK TO SAVEPOINT` отменяет две последние вставки, `COMMIT` фиксирует первые две.
2. Три триггера модификации данных:
   - `driver_audit` на `drivers` — аудит I/U/D в таблицу `driver_audit` (образец `emp_audit`, стр. 157–158);
   - `brud` на `sponsors` — запрет вставки имени `'Брудастый%'` (образец стр. 159);
   - `team_change_notice` на `teams` — `AFTER … FOR EACH STATEMENT`, выводит `NOTICE` с `TG_NAME`, `TG_OP`, `TG_TABLE_NAME` (теория стр. 152–155).
3. Два триггера событий (теория стр. 156):
   - `notice_ddl_end` на `ddl_command_end` — `NOTICE` с `TG_EVENT` и `TG_TAG`;
   - `notice_sql_drop` на `sql_drop` — `NOTICE` по объектам из `pg_event_trigger_dropped_objects()`.

Отдельные хранимые процедуры в эту работу не входят: они сделаны в `solution/lab7/`.

## Файлы

| Файл | Что делает |
|---|---|
| `transaction.sql` | Явная транзакция с точкой сохранения и проверкой `SELECT` |
| `triggers.sql` | Журнал, три DML-триггера, два событийных триггера |
| `check_lab8.sql` | Прогон транзакции, DML-триггеров и событийных триггеров |
| `check_output.txt` | Вывод проверки на PostgreSQL 15 |

## Проверка запуском

Файл `solution/lab2/01_create_database.sql` не изменяется. Локаль `Russian_Russia.1251` подменяется только в потоке команд.

```text
docker start dbms-pg
docker exec dbms-pg psql -U postgres -c "DROP DATABASE IF EXISTS formula1"
# локаль в CREATE DATABASE: Russian_Russia.1251 → en_US.utf8
docker exec -i dbms-pg psql -U postgres -v ON_ERROR_STOP=1 < 01_create_database.sql
docker exec -i dbms-pg psql -U postgres -d formula1 -v ON_ERROR_STOP=1 < solution/lab2/02_create_tables.sql
docker exec -i dbms-pg psql -U postgres -d formula1 -v ON_ERROR_STOP=1 < solution/lab8/triggers.sql
docker exec -i dbms-pg psql -U postgres -d formula1 -v ON_ERROR_STOP=1 < solution/lab8/check_lab8.sql
```

Ожидается: после транзакции две команды; в `driver_audit` строки I, U, D; запрет «Брудастый»; `NOTICE` от `team_change_notice` и от событийных триггеров при `CREATE`/`DROP TABLE`; в `pg_trigger` остаются три DML-триггера, в `pg_event_trigger` — два событийных.

## Скриншоты

Снимает студент в своём pgAdmin и кладёт в `img/`:

| Файл | Что на нём |
|---|---|
| `01_transaction.png` | результат `SELECT` после транзакции с `SAVEPOINT` (две команды) |
| `02_audit.png` | три строки `driver_audit` после INSERT/UPDATE/DELETE |
| `03_forbid.png` | ошибка «спонсор не обслуживается» |
| `04_team_notice.png` | вкладка Messages с `NOTICE` триггера `team_change_notice` |
| `05_event_triggers.png` | Messages при `CREATE`/`DROP` таблицы (событийные триггеры) |

Отчёт собирается отдельно (в эту сессию не генерировался).
