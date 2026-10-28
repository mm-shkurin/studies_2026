UPDATE driver_season_races
SET race_ids = race_ids || 23
WHERE driver_ID = 1 AND year = 2024;

UPDATE driver_season_races
SET race_ids = array_append(race_ids, 24)
WHERE driver_ID = 2 AND year = 2024;

UPDATE driver_season_races
SET race_ids = array_prepend(0, race_ids)
WHERE driver_ID = 2 AND year = 2024;

UPDATE driver_season_races
SET race_ids = array_remove(race_ids, 0)
WHERE driver_ID = 2 AND year = 2024;

-- 5. Изменение элементов массива по индексу
-- Источник: пособие, стр. 93 (пример с Котовым В.И.)
-- Изменим первую гонку сезона на ID 1

UPDATE driver_season_races
SET race_ids[1] = 1
WHERE driver_ID = 1 AND year = 2024;

-- 6. Срез массива (slice)
-- Источник: пособие, стр. 94
-- Заменим первые 5 гонок на другой диапазон

UPDATE driver_season_races
SET race_ids[1:5] = ARRAY[1, 2, 3, 4, 5]
WHERE driver_ID = 1 AND year = 2024;

-- 7. Выборка: пилоты, участвовавшие в гонке 1
-- Источник: пособие, стр. 94 (пример с сотрудниками, работающими в среду)
-- Используем array_position

SELECT d.name, dsr.year, dsr.race_ids
FROM driver_season_races dsr
JOIN drivers d ON dsr.driver_ID = d.driver_ID
WHERE array_position(dsr.race_ids, 1) IS NOT NULL;

-- 8. Выборка: пилоты, участвовавшие в гонках 1 и 2
-- Источник: пособие, стр. 95
-- Оператор @> проверяет, что левый массив содержит все элементы правого

SELECT d.name, dsr.year, dsr.race_ids
FROM driver_season_races dsr
JOIN drivers d ON dsr.driver_ID = d.driver_ID
WHERE dsr.race_ids @> ARRAY[1, 2];

-- 9. Выборка: пилоты, участвовавшие в гонках 3 или 4
-- Источник: пособие, стр. 95
-- Оператор && проверяет наличие общих элементов

SELECT d.name, dsr.year, dsr.race_ids
FROM driver_season_races dsr
JOIN drivers d ON dsr.driver_ID = d.driver_ID
WHERE dsr.race_ids && ARRAY[3, 4];

-- 10. Выборка: пилоты, НЕ участвовавшие в гонках 3 и 4
-- Источник: пособие, стр. 96

SELECT d.name, dsr.year, dsr.race_ids
FROM driver_season_races dsr
JOIN drivers d ON dsr.driver_ID = d.driver_ID
WHERE NOT (dsr.race_ids && ARRAY[3, 4]);

-- 11. Разворачивание массива в столбец (unnest)
-- Источник: пособие, стр. 96

SELECT d.name, dsr.year, unnest(dsr.race_ids) AS race_id
FROM driver_season_races dsr
JOIN drivers d ON dsr.driver_ID = d.driver_ID
WHERE dsr.year = 2024
ORDER BY d.name, race_id;

-- Проверка результатов
SELECT * FROM driver_season_races;
