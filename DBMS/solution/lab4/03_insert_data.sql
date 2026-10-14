-- ЛР 4: Заполнение таблиц данными
-- Источник: пособие, стр. 92, 97

-- Предполагаем, что таблица drivers уже заполнена данными из ЛР 2/3
-- driver_ID = 1 (Шарль Леклер), 2 (Ландо Норрис) и т.д.

-- Заполнение таблицы driver_season_races (массивы)
-- Источник: пособие, стр. 92 (пример с schedules)

INSERT INTO driver_season_races (driver_ID, year, race_ids)
VALUES
    (1, 2024, ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]),
    (2, 2024, ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]),
    (1, 2023, ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]),
    (2, 2023, ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22]);

-- Заполнение таблицы driver_stats (JSONB)
-- Источник: пособие, стр. 97 (пример с hobbies)

INSERT INTO driver_stats (driver_ID, stats)
VALUES
    (1, '{"wins": 5, "podiums": 12, "pole_positions": 8, "fastest_laps": 3, "championships": 0, "points": 312}'::jsonb),
    (2, '{"wins": 1, "podiums": 8, "pole_positions": 2, "fastest_laps": 4, "championships": 0, "points": 256}'::jsonb);

-- Проверка заполнения
SELECT * FROM driver_season_races;
SELECT * FROM driver_stats;
