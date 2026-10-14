-- ЛР 6: Работа с представлениями
-- Источник: пособие, ЛР 7, стр. 118–124
-- Предметная область: Формула-1

-- ============================================================
-- ПРОСТЫЕ ПРЕДСТАВЛЕНИЯ (CREATE VIEW)
-- Источник: пособие, стр. 118–119
-- ============================================================

-- Представление 1: Пилоты, их команды и результаты гонок
-- Объединяет таблицы drivers, teams, cars, races, tracks, results
CREATE OR REPLACE VIEW v_driver_team_results AS
SELECT
    d.driver_ID,
    d.name AS driver_name,
    d.country AS driver_country,
    t.team_ID,
    t.name AS team_name,
    t.base AS team_base,
    c.car_ID,
    c.model AS car_model,
    c.year AS car_year,
    r.race_ID,
    r.name AS race_name,
    r.date AS race_date,
    tr.name AS track_name,
    tr.country AS track_country,
    tr.length_km AS track_length,
    res.position,
    res.points
FROM drivers d
LEFT JOIN teams t ON d.team_ID = t.team_ID
LEFT JOIN cars c ON d.team_ID = c.team_ID
LEFT JOIN results res ON d.driver_ID = res.driver_ID AND c.car_ID = res.car_ID
LEFT JOIN races r ON res.race_ID = r.race_ID
LEFT JOIN tracks tr ON r.track_ID = tr.track_ID;

COMMENT ON VIEW v_driver_team_results IS 'Пилоты, команды, болиды и результаты гонок';

-- Представление 2: Детали гонок с трассами и спонсорами
-- Объединяет таблицы races, tracks, sponsors
CREATE OR REPLACE VIEW v_race_details AS
SELECT
    r.race_ID,
    r.name AS race_name,
    r.date AS race_date,
    t.track_ID,
    t.name AS track_name,
    t.country AS track_country,
    t.length_km AS track_length,
    s.sponsor_ID,
    s.name AS sponsor_name,
    s.budget AS sponsor_budget
FROM races r
JOIN tracks t ON r.track_ID = t.track_ID
LEFT JOIN sponsors s ON r.sponsor_ID = s.sponsor_ID;

COMMENT ON VIEW v_race_details IS 'Детали гонок с трассами и спонсорами';

-- Представление 3: Запчасти в болидах
-- Объединяет таблицы cars, parts, car_parts
CREATE OR REPLACE VIEW v_car_parts AS
SELECT
    c.car_ID,
    c.model AS car_model,
    c.year AS car_year,
    t.name AS team_name,
    p.part_ID,
    p.name AS part_name,
    p.type AS part_type
FROM cars c
JOIN teams t ON c.team_ID = t.team_ID
JOIN car_parts cp ON c.car_ID = cp.car_ID
JOIN parts p ON cp.part_ID = p.part_ID
ORDER BY c.car_ID, p.part_ID;

COMMENT ON VIEW v_car_parts IS 'Запчасти, установленные в болидах';

-- ============================================================
-- МАТЕРИААЛИЗОВАННЫЕ ПРЕДСТАВЛЕНИЯ (CREATE MATERIALIZED VIEW)
-- Источник: пособие, стр. 119–120
-- ============================================================

-- Материализованное представление 1: Таблица пилотов с очками
-- Агрегирует очки каждого пилота по всем гонкам
CREATE MATERIALIZED VIEW mv_driver_standings AS
SELECT
    d.driver_ID,
    d.name AS driver_name,
    d.country AS driver_country,
    t.name AS team_name,
    COUNT(res.race_ID) AS races_completed,
    SUM(res.points) AS total_points,
    AVG(res.points) AS avg_points,
    MAX(res.points) AS max_points,
    MIN(res.position) AS best_position
FROM drivers d
LEFT JOIN teams t ON d.team_ID = t.team_ID
LEFT JOIN results res ON d.driver_ID = res.driver_ID
GROUP BY d.driver_ID, d.name, d.country, t.name
ORDER BY total_points DESC;

COMMENT ON MATERIALIZED VIEW mv_driver_standings IS 'Таблица пилотов с очками (материализованная)';

-- Материализованное представление 2: Таблица команд с очками
-- Агрегирует очки всех пилотов каждой команды
CREATE MATERIALIZED VIEW mv_team_standings AS
SELECT
    t.team_ID,
    t.name AS team_name,
    t.base AS team_base,
    COUNT(DISTINCT d.driver_ID) AS driver_count,
    COUNT(DISTINCT res.race_ID) AS total_races,
    SUM(res.points) AS total_points,
    AVG(res.points) AS avg_points_per_driver
FROM teams t
LEFT JOIN drivers d ON t.team_ID = d.team_ID
LEFT JOIN results res ON d.driver_ID = res.driver_ID
GROUP BY t.team_ID, t.name, t.base
ORDER BY total_points DESC;

COMMENT ON MATERIALIZED VIEW mv_team_standings IS 'Таблица команд с очками (материализованная)';

-- ============================================================
-- ЗАПРОСЫ К ПРЕДСТАВЛЕНИЯМ
-- ============================================================

-- a) Запрос на выборку, содержащий вложенный запрос
-- Найти пилотов, чей средний балл выше среднего по всем пилотам
-- Источник: пособие, стр. 112–116 (вложенные запросы)
SELECT
    driver_name,
    team_name,
    races_completed,
    total_points,
    avg_points
FROM mv_driver_standings
WHERE avg_points > (
    SELECT AVG(avg_points)
    FROM mv_driver_standings
    WHERE avg_points IS NOT NULL
)
ORDER BY avg_points DESC;

-- b) Запрос на выборку с группировкой данных и простой сортировкой
-- Количество гонок на каждой трассе, сортировка по убыванию количества
-- Источник: пособие, стр. 104 (GROUP BY, ORDER BY)
SELECT
    track_name,
    track_country,
    COUNT(race_ID) AS race_count
FROM v_race_details
GROUP BY track_name, track_country
ORDER BY race_count DESC;

-- c) Запрос на выборку с группировкой данных с условием и многоуровневой сортировкой
-- Пилоты с суммой очков > 15, сортировка: очки DESC, название команды ASC, имя пилота ASC
-- Источник: пособие, стр. 104 (GROUP BY, HAVING, ORDER BY)
SELECT
    driver_name,
    team_name,
    races_completed,
    total_points
FROM mv_driver_standings
WHERE total_points > 15
GROUP BY driver_ID, driver_name, team_name, races_completed, total_points
ORDER BY total_points DESC, team_name ASC, driver_name ASC;

-- ============================================================
-- ОБНОВЛЕНИЕ МАТЕРИААЛИЗОВАННЫХ ПРЕДСТАВЛЕНИЙ
-- Источник: пособие, стр. 120 (REFRESH MATERIALIZED VIEW)
-- ============================================================

-- Обновление данных в материализованных представлениях
-- REFRESH MATERIALIZED VIEW mv_driver_standings;
-- REFRESH MATERIALIZED VIEW mv_team_standings;

-- ============================================================
-- УДАЛЕНИЕ ПРЕДСТАВЛЕНИЙ (при необходимости)
-- Источник: пособие, стр. 119–120 (DROP VIEW, DROP MATERIALIZED VIEW)
-- ============================================================

-- DROP VIEW IF EXISTS v_driver_team_results;
-- DROP VIEW IF EXISTS v_race_details;
-- DROP VIEW IF EXISTS v_car_parts;
-- DROP MATERIALIZED VIEW IF EXISTS mv_driver_standings;
-- DROP MATERIALIZED VIEW IF EXISTS mv_team_standings;
