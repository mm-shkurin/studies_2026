# ЛР 7. Функции и процедуры

## Содержание

Скрипт `procedures_functions.sql` содержит хранимые процедуры и функции для таблиц `teams` (Команды) и `drivers` (Пилоты) предметной области «Формула-1».

## Процедуры и функции

### Таблица teams (Команды)

1. **team_insert** — вставка новой команды
   - Параметры: `p_team_id` (INTEGER), `p_name` (VARCHAR), `p_base` (VARCHAR)
   - Вызов: `CALL team_insert(3, 'Red Bull Racing', 'Milton Keynes');`

2. **team_update** — обновление данных команды
   - Параметры: `p_team_id` (INTEGER), `p_name` (VARCHAR), `p_base` (VARCHAR)
   - Вызов: `CALL team_update(1, 'Mercedes-AMG Petronas', 'Brackley');`

3. **team_delete** — удаление команды
   - Параметры: `p_team_id` (INTEGER)
   - Вызов: `CALL team_delete(1);`

### Таблица drivers (Пилоты)

4. **driver_insert** — вставка нового пилота (функция, возвращает driver_ID)
   - Параметры: `p_driver_id` (INTEGER), `p_name` (VARCHAR), `p_country` (VARCHAR), `p_team_id` (INTEGER)
   - Возвращает: INTEGER (ID созданного пилота)
   - Вызов: `SELECT driver_insert(5, 'Max Verstappen', 'Netherlands', 2);`

5. **driver_update** — обновление данных пилота
   - Параметры: `p_driver_id` (INTEGER), `p_name` (VARCHAR), `p_country` (VARCHAR), `p_team_id` (INTEGER)
   - Вызов: `CALL driver_update(1, 'Lewis Hamilton', 'United Kingdom', 1);`

6. **driver_delete** — удаление пилота
   - Параметры: `p_driver_id` (INTEGER)
   - Вызов: `CALL driver_delete(1);`

### Функции с OUT-параметрами и RETURNS TABLE

7. **get_team_stats** — статистика команды (RETURNS TABLE)
   - Параметры: `p_team_id` (INTEGER)
   - Возвращает: TABLE (driver_count BIGINT, total_points NUMERIC)
   - Вызов: `SELECT * FROM get_team_stats(1);`

8. **get_driver_stats** — статистика пилота (OUT-параметры)
   - Параметры: `p_driver_id` (INTEGER)
   - Возвращает OUT: `race_count` (BIGINT), `total_points` (NUMERIC), `avg_points` (NUMERIC)
   - Вызов: `SELECT * FROM get_driver_stats(1);`

## Запуск

### В pgAdmin

1. Откройте базу данных `formula1`.
2. Откройте инструмент Query Tool.
3. Откройте файл `procedures_functions.sql`.
4. Выполните скрипт целиком (F5 или кнопка Execute).
5. Проверьте создание процедур и функций:
   ```sql
   SELECT routine_name, routine_type
   FROM information_schema.routines
   WHERE routine_schema = 'public'
   ORDER BY routine_name;
   ```

### В Docker (PostgreSQL 15)

```bash
docker start dbms-pg
docker exec -i dbms-pg psql -U postgres -v ON_ERROR_STOP=1 < solution/lab7/procedures_functions.sql
```

## Проверка вызова

После создания процедур и функций выполните примеры вызова из раздела «Процедуры и функции».

## Источники

- Пособие, ЛР 8, стр. 124–130 (пример процедур для таблицы orders)
- Теория гл. 4.6, стр. 34–42 (CREATE FUNCTION, CREATE PROCEDURE, OUT-параметры, RETURNS TABLE)
