-- ЛР 5: Построение запросов с использованием инструкций SQL
-- Источник: пособие, ЛР 6, стр. 100–117
-- Предметная область: Формула-1

-- ============================================================
-- 2.1. Запрос с использованием всех типов соединений
-- Источник: пособие, стр. 106–110 (INNER, LEFT, RIGHT, FULL JOIN)
-- ============================================================

-- INNER JOIN: пилоты и их команды (только те, у кого есть команда)
SELECT d.name AS driver, d.country, t.name AS team, t.base
FROM drivers d
INNER JOIN teams t ON d.team_ID = t.team_ID
ORDER BY d.name;

-- LEFT JOIN: все пилоты и их команды (включая тех, у кого нет команды)
SELECT d.name AS driver, d.country, t.name AS team, t.base
FROM drivers d
LEFT JOIN teams t ON d.team_ID = t.team_ID
ORDER BY d.name;

-- RIGHT JOIN: команды и их пилоты (включая команды без пилотов)
SELECT t.name AS team, t.base, d.name AS driver, d.country
FROM drivers d
RIGHT JOIN teams t ON d.team_ID = t.team_ID
ORDER BY t.name, d.name;

-- FULL JOIN: все пилоты и все команды (несопавшие значения = NULL)
SELECT d.name AS driver, d.country, t.name AS team, t.base
FROM drivers d
FULL JOIN teams t ON d.team_ID = t.team_ID
ORDER BY COALESCE(d.name, ''), t.name;

-- ============================================================
-- 2.2. Запрос с использованием оператора DISTINCT
-- Источник: пособие, стр. 104–105
-- ============================================================

-- Уникальные страны пилотов
SELECT DISTINCT country
FROM drivers
ORDER BY country;

-- Уникальные страны трасс
SELECT DISTINCT country
FROM tracks
ORDER BY country;

-- ============================================================
-- 2.3. Запрос с использованием оператора BETWEEN
-- Источник: пособие, стр. 103 (предикаты сравнения)
-- ============================================================

-- Гонки в диапазоне дат (предполагаем, что есть данные за 2024 год)
SELECT r.name AS race, r.date, t.name AS track, t.country
FROM races r
JOIN tracks t ON r.track_ID = t.track_ID
WHERE r.date BETWEEN '2024-01-01' AND '2024-12-31'
ORDER BY r.date;

-- Болиды с годом выпуска между 2020 и 2024
SELECT c.model, c.year, t.name AS team
FROM cars c
JOIN teams t ON c.team_ID = t.team_ID
WHERE c.year BETWEEN 2020 AND 2024
ORDER BY c.year DESC, c.model;

-- ============================================================
-- 2.4. Запрос с использованием оператора LIMIT
-- Источник: пособие, стр. 105
-- ============================================================

-- Топ-3 пилота по очкам (предполагаем, что есть данные в results)
SELECT d.name AS driver, SUM(r.points) AS total_points
FROM results r
JOIN drivers d ON r.driver_ID = d.driver_ID
GROUP BY d.driver_ID, d.name
ORDER BY total_points DESC
LIMIT 3;

-- Первые 5 гонок по дате
SELECT r.name AS race, r.date, t.name AS track
FROM races r
JOIN tracks t ON r.track_ID = t.track_ID
ORDER BY r.date
LIMIT 5;

-- ============================================================
-- 2.5. Запрос с использованием оператора OFFSET
-- Источник: пособие, стр. 105–106
-- ============================================================

-- Гонки с 4-й по 6-ю (пропустить первые 3)
SELECT r.name AS race, r.date, t.name AS track
FROM races r
JOIN tracks t ON r.track_ID = t.track_ID
ORDER BY r.date
LIMIT 3 OFFSET 3;

-- Пилоты с 3-го по 5-е по количеству очков
SELECT d.name AS driver, SUM(r.points) AS total_points
FROM results r
JOIN drivers d ON r.driver_ID = d.driver_ID
GROUP BY d.driver_ID, d.name
ORDER BY total_points DESC
LIMIT 3 OFFSET 2;

-- ============================================================
-- 2.6. Запрос на выборку с шаблонами поиска LIKE, NOT LIKE
-- Источник: пособие, стр. 101–102
-- ============================================================

-- Пилоты, имя которых начинается на 'Ш'
SELECT name, country
FROM drivers
WHERE name LIKE 'Ш%'
ORDER BY name;

-- Пилоты, в имени которых есть 'о'
SELECT name, country
FROM drivers
WHERE name LIKE '%о%'
ORDER BY name;

-- Трассы, название которых не содержит 'Гран-при'
SELECT name, country, length_km
FROM tracks
WHERE name NOT LIKE '%Гран-при%'
ORDER BY name;

-- Команды с названием из 4 символов (использование _)
SELECT name, base
FROM teams
WHERE name LIKE '____'
ORDER BY name;

-- ============================================================
-- 2.7. Запрос на выборку с регулярным выражением POSIX
-- Источник: пособие, стр. 102–103
-- ============================================================

-- Пилоты из России или Италии
SELECT name, country
FROM drivers
WHERE country ~ '^(Россия|Италия)$'
ORDER BY country, name;

-- Болиды, модель которых заканчивается на '-24'
SELECT model, year, t.name AS team
FROM cars c
JOIN teams t ON c.team_ID = t.team_ID
WHERE model ~ '-24$'
ORDER BY model;

-- Трассы, название которых содержит цифру
SELECT name, country, length_km
FROM tracks
WHERE name ~ '[0-9]'
ORDER BY name;

-- Пилоты, имя которых НЕ начинается на 'М' или 'С'
SELECT name, country
FROM drivers
WHERE name !~ '^(М|С)'
ORDER BY name;

-- ============================================================
-- 2.8. Запрос на получение агрегированных данных
-- (любые три статистические функции)
-- Источник: пособие, стр. 104 (упомянут COUNT, SUM, AVG, MIN, MAX)
-- ============================================================

-- Статистика по очкам пилотов: SUM, AVG, MAX
SELECT d.name AS driver,
       SUM(r.points) AS total_points,
       AVG(r.points) AS avg_points,
       MAX(r.points) AS max_points
FROM results r
JOIN drivers d ON r.driver_ID = d.driver_ID
GROUP BY d.driver_ID, d.name
ORDER BY total_points DESC;

-- Статистика по гонкам: COUNT, MIN, MAX длины трасс
SELECT COUNT(r.race_ID) AS total_races,
       MIN(t.length_km) AS min_track_length,
       MAX(t.length_km) AS max_track_length
FROM races r
JOIN tracks t ON r.track_ID = t.track_ID;

-- Статистика по бюджету спонсоров: SUM, AVG, COUNT
SELECT COUNT(sponsor_ID) AS total_sponsors,
       SUM(budget) AS total_budget,
       AVG(budget) AS avg_budget
FROM sponsors;

-- ============================================================
-- 2.9. Запрос на выборку, содержащий вложенный запрос
-- Источник: пособие, стр. 112–116
-- ============================================================

-- Пилоты, набравшие больше очков, чем среднее значение
SELECT d.name, SUM(r.points) AS total_points
FROM results r
JOIN drivers d ON r.driver_ID = d.driver_ID
GROUP BY d.driver_ID, d.name
HAVING SUM(r.points) > (
    SELECT AVG(points_sum)
    FROM (
        SELECT SUM(points) AS points_sum
        FROM results
        GROUP BY driver_ID
    ) AS avg_table
)
ORDER BY total_points DESC;

-- Пилоты, участвовавшие в гонке с ID = 1 (некоррелированный запрос)
SELECT name, country
FROM drivers
WHERE driver_ID IN (
    SELECT driver_ID
    FROM results
    WHERE race_ID = 1
)
ORDER BY name;

-- Команды с количеством пилотов больше среднего (коррелированный запрос)
SELECT t.name, COUNT(d.driver_ID) AS driver_count
FROM teams t
LEFT JOIN drivers d ON t.team_ID = d.team_ID
GROUP BY t.team_ID, t.name
HAVING COUNT(d.driver_ID) > (
    SELECT AVG(driver_count)
    FROM (
        SELECT COUNT(d2.driver_ID) AS driver_count
        FROM teams t2
        LEFT JOIN drivers d2 ON t2.team_ID = d2.team_ID
        GROUP BY t2.team_ID
    ) AS avg_table
)
ORDER BY driver_count DESC;

-- ============================================================
-- 2.10. Запрос с использованием условного выражения CASE
-- Источник: пособие, стр. 106
-- ============================================================

-- Классификация пилотов по очкам (HIGH, MEDIUM, LOW)
SELECT d.name,
       SUM(r.points) AS total_points,
       CASE
           WHEN SUM(r.points) >= 20 THEN 'HIGH'
           WHEN SUM(r.points) >= 10 THEN 'MEDIUM'
           ELSE 'LOW'
       END AS points_category
FROM results r
JOIN drivers d ON r.driver_ID = d.driver_ID
GROUP BY d.driver_ID, d.name
ORDER BY total_points DESC;

-- Статус гонки (прошедшая/будущая) на основе даты
SELECT r.name AS race,
       r.date,
       CASE
           WHEN r.date < CURRENT_DATE THEN 'Прошедшая'
           WHEN r.date = CURRENT_DATE THEN 'Сегодня'
           ELSE 'Будущая'
       END AS race_status
FROM races r
ORDER BY r.date;

-- Категория длины трассы (короткая, средняя, длинная)
SELECT name, country, length_km,
       CASE
           WHEN length_km < 5 THEN 'Короткая'
           WHEN length_km < 7 THEN 'Средняя'
           ELSE 'Длинная'
       END AS track_category
FROM tracks
ORDER BY length_km;

-- ============================================================
-- 2.11. Запрос с группировкой данных и простой сортировкой
-- Источник: пособие, стр. 104 (GROUP BY), стр. 104 (ORDER BY)
-- ============================================================

-- Количество очков каждого пилота, сортировка по убыванию очков
SELECT d.name AS driver, SUM(r.points) AS total_points
FROM results r
JOIN drivers d ON r.driver_ID = d.driver_ID
GROUP BY d.driver_ID, d.name
ORDER BY total_points DESC;

-- Количество гонок на каждой трассе, сортировка по убыванию количества
SELECT t.name AS track, t.country, COUNT(r.race_ID) AS race_count
FROM tracks t
LEFT JOIN races r ON t.track_ID = r.track_ID
GROUP BY t.track_ID, t.name, t.country
ORDER BY race_count DESC;

-- Количество пилотов в каждой команде, сортировка по названию команды
SELECT t.name AS team, COUNT(d.driver_ID) AS driver_count
FROM teams t
LEFT JOIN drivers d ON t.team_ID = d.team_ID
GROUP BY t.team_ID, t.name
ORDER BY t.name;

-- ============================================================
-- 2.12. Запрос с группировкой данных с условием и многоуровневой сортировкой
-- Источник: пособие, стр. 104 (GROUP BY, HAVING), стр. 104 (ORDER BY)
-- ============================================================

-- Пилоты с суммой очков > 15, сортировка: сначала по очкам DESC, затем по имени ASC
SELECT d.name AS driver, SUM(r.points) AS total_points
FROM results r
JOIN drivers d ON r.driver_ID = d.driver_ID
GROUP BY d.driver_ID, d.name
HAVING SUM(r.points) > 15
ORDER BY total_points DESC, d.name ASC;

-- Команды с > 1 пилотом, сортировка: по количеству пилотов DESC, по названию команды ASC
SELECT t.name AS team, COUNT(d.driver_ID) AS driver_count
FROM teams t
LEFT JOIN drivers d ON t.team_ID = d.team_ID
GROUP BY t.team_ID, t.name
HAVING COUNT(d.driver_ID) > 1
ORDER BY driver_count DESC, t.name ASC;

-- Трассы с > 1 гонкой, сортировка: по количеству гонок DESC, по длине трассы DESC, по названию ASC
SELECT t.name AS track, t.country, t.length_km, COUNT(r.race_ID) AS race_count
FROM tracks t
LEFT JOIN races r ON t.track_ID = r.track_ID
GROUP BY t.track_ID, t.name, t.country, t.length_km
HAVING COUNT(r.race_ID) > 1
ORDER BY race_count DESC, t.length_km DESC, t.name ASC;
