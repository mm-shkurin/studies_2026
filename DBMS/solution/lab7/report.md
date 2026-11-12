{{json
{
  "discipline": "Системы управления базами данных",
  "title": "Функции и процедуры",
  "student": {"name": "[ФИО студента]", "course": "3", "group": "ФИТ-242", "program": "09.03.01 Информатика и вычислительная техника"},
  "teacher": {"title": "", "name": "Моисеева Н.А."},
  "institution": {"short": "ОмГТУ", "department": "ПМиФИ", "year": "2026"},
  "work": {"type": "Лабораторная работа №7"}
}
}}

# Лабораторная работа №7

## Функции и процедуры

---

## Цель работы

Изучить создание хранимых процедур и функций в PostgreSQL, научиться использовать процедуры для операций INSERT, UPDATE, DELETE и функции с OUT-параметрами и RETURNS TABLE для получения статистических данных.

## Задание

Для предметной области «Формула-1» (база данных `formula1`) создать хранимые процедуры и функции для 1–2 таблиц по выбору:

1. Процедуры для операций вставки, обновления и удаления данных.
2. Функции с OUT-параметрами или RETURNS TABLE для получения статистики.
3. Использовать язык PL/pgSQL.

## Выполнение работы

### Выбранные таблицы

Для выполнения работы выбраны таблицы:
- `teams` (Команды)
- `drivers` (Пилоты)

### Созданные процедуры и функции

#### Таблица teams (Команды)

**1. Процедура team_insert** — вставка новой команды

```sql
CREATE OR REPLACE PROCEDURE team_insert(p_team_id INTEGER, p_name VARCHAR(100), p_base VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO teams (team_ID, name, base)
    VALUES (p_team_id, p_name, p_base);
END;
$$;
```

Параметры:
- `p_team_id` — идентификатор команды (первичный ключ)
- `p_name` — название команды
- `p_base` — база команды

Вызов:
```sql
CALL team_insert(3, 'Red Bull Racing', 'Milton Keynes');
```

**2. Процедура team_update** — обновление данных команды

```sql
CREATE OR REPLACE PROCEDURE team_update(p_team_id INTEGER, p_name VARCHAR(100), p_base VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE teams
    SET name = p_name,
        base = p_base
    WHERE team_ID = p_team_id;
END;
$$;
```

Параметры:
- `p_team_id` — идентификатор команды для обновления
- `p_name` — новое название команды
- `p_base` — новая база команды

Вызов:
```sql
CALL team_update(3, 'Red Bull Racing', 'Milton Keynes, UK');
```

**3. Процедура team_delete** — удаление команды

```sql
CREATE OR REPLACE PROCEDURE team_delete(p_team_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM teams
    WHERE team_ID = p_team_id;
END;
$$;
```

Параметры:
- `p_team_id` — идентификатор команды для удаления

Вызов:
```sql
CALL team_delete(3);
```

#### Таблица drivers (Пилоты)

**4. Функция driver_insert** — вставка нового пилота (возвращает driver_ID)

```sql
CREATE OR REPLACE FUNCTION driver_insert(p_driver_id INTEGER, p_name VARCHAR(100), p_country VARCHAR(50), p_team_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO drivers (driver_ID, name, country, team_ID)
    VALUES (p_driver_id, p_name, p_country, p_team_id);

    RETURN p_driver_id;
END;
$$;
```

Параметры:
- `p_driver_id` — идентификатор пилота (первичный ключ)
- `p_name` — имя пилота
- `p_country` — страна пилота
- `p_team_id` — идентификатор команды

Возвращает: INTEGER (ID созданного пилота)

Вызов:
```sql
SELECT driver_insert(5, 'Max Verstappen', 'Netherlands', 2);
```

**5. Процедура driver_update** — обновление данных пилота

```sql
CREATE OR REPLACE PROCEDURE driver_update(p_driver_id INTEGER, p_name VARCHAR(100), p_country VARCHAR(50), p_team_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE drivers
    SET name = p_name,
        country = p_country,
        team_ID = p_team_id
    WHERE driver_ID = p_driver_id;
END;
$$;
```

Параметры:
- `p_driver_id` — идентификатор пилота для обновления
- `p_name` — новое имя пилота
- `p_country` — новая страна пилота
- `p_team_id` — новый идентификатор команды

Вызов:
```sql
CALL driver_update(5, 'Max Verstappen', 'Netherlands', 2);
```

**6. Процедура driver_delete** — удаление пилота

```sql
CREATE OR REPLACE PROCEDURE driver_delete(p_driver_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM drivers
    WHERE driver_ID = p_driver_id;
END;
$$;
```

Параметры:
- `p_driver_id` — идентификатор пилота для удаления

Вызов:
```sql
CALL driver_delete(5);
```

#### Функции статистики

**7. Функция get_team_stats** — статистика команды (RETURNS TABLE)

```sql
CREATE OR REPLACE FUNCTION get_team_stats(p_team_id INTEGER)
RETURNS TABLE(driver_count BIGINT, total_points NUMERIC(8,1))
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(d.driver_ID),
           COALESCE(SUM(r.points), 0)
    FROM drivers d
    LEFT JOIN results r ON d.driver_ID = r.driver_ID
    WHERE d.team_ID = p_team_id
    GROUP BY d.team_ID;
END;
$$;
```

Параметры:
- `p_team_id` — идентификатор команды

Возвращает: TABLE (driver_count — количество пилотов, total_points — сумма очков)

Вызов:
```sql
SELECT * FROM get_team_stats(1);
```

Результат для Ferrari (team_ID = 1):
```
 driver_count | total_points 
--------------+--------------
            2 |         40.0
```

**8. Функция get_driver_stats** — статистика пилота (OUT-параметры)

```sql
CREATE OR REPLACE FUNCTION get_driver_stats(p_driver_id INTEGER, OUT race_count BIGINT, OUT total_points NUMERIC, OUT avg_points NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(r.race_ID),
           COALESCE(SUM(r.points), 0),
           COALESCE(AVG(r.points), 0)
    INTO race_count, total_points, avg_points
    FROM results r
    WHERE r.driver_ID = p_driver_id;
END;
$$;
```

Параметры:
- `p_driver_id` — идентификатор пилота

Возвращает OUT:
- `race_count` — количество гонок
- `total_points` — сумма очков
- `avg_points` — среднее количество очков

Вызов:
```sql
SELECT * FROM get_driver_stats(1);
```

Результат для Charles Leclerc (driver_ID = 1):
```
 race_count | total_points |     avg_points      
------------+--------------+---------------------
          1 |         25.0 | 25.0000000000000000
```

## Проверка выполнения

Все процедуры и функции были проверены на PostgreSQL 15:

1. Скрипт `procedures_functions.sql` выполнен без ошибок.
2. Все 8 подпрограмм успешно созданы в базе данных.
3. Тестовые вызовы из `test_calls.sql` выполнены успешно:
   - Процедуры INSERT, UPDATE, DELETE корректно модифицируют данные.
   - Функция `driver_insert` возвращает ID созданного пилота.
   - Функция `get_team_stats` возвращает корректную статистику команды.
   - Функция `get_driver_stats` возвращает корректную статистику пилота.

## Вывод

В ходе лабораторной работы были изучены основы создания хранимых процедур и функций в PostgreSQL:

1. Процедуры (CREATE PROCEDURE) используются для операций, модифицирующих данные (INSERT, UPDATE, DELETE). Вызываются через оператор CALL.
2. Функции (CREATE FUNCTION) могут возвращать значения и использоваться в выражениях SQL. Вызываются через SELECT.
3. Функции могут возвращать данные разными способами:
   - RETURNS TABLE — возвращает набор строк как таблицу.
   - OUT-параметры — возвращает несколько значений через именованные параметры.
4. Язык PL/pgSQL предоставляет расширения SQL: переменные, блоки BEGIN-END, управление потоком, обработку исключений.
5. Хранимые процедуры и функции позволяют вынести бизнес-логику на сторону сервера БД, что упрощает код приложения и повышает безопасность.

Использование процедур и функций соответствует рекомендациям учебного пособия (ЛР 8, стр. 124–130) и теории (гл. 4.6, стр. 34–42).
