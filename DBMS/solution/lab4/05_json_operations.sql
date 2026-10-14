-- ЛР 4: Операции с JSON
-- Источник: пособие, стр. 97–99

-- 1. Выборка: пилоты с определённым количеством побед
-- Источник: пособие, стр. 97 (пример с волейболистами)
-- Пилоты с 5 победами

SELECT d.name, dstats.stats
FROM driver_stats dstats
JOIN drivers d ON dstats.driver_ID = d.driver_ID
WHERE dstats.stats->>'wins' = '5';

-- 2. Выборка: пилоты с определённым количеством побед (вариант с ->)
-- Источник: пособие, стр. 98
-- Использование оператора -> для обращения к ключу

SELECT d.name, dstats.stats->'wins' AS wins
FROM driver_stats dstats
JOIN drivers d ON dstats.driver_ID = d.driver_ID
WHERE (dstats.stats->>'wins')::integer >= 5;

-- 3. Проверка наличия ключа
-- Источник: пособие, стр. 98
-- Проверка наличия ключа 'wins'

SELECT d.name, dstats.stats
FROM driver_stats dstats
JOIN drivers d ON dstats.driver_ID = d.driver_ID
WHERE dstats.stats ? 'wins';

-- 4. Проверка наличия ключа 'championships'
-- Источник: пособие, стр. 98

SELECT d.name, dstats.stats
FROM driver_stats dstats
JOIN drivers d ON dstats.driver_ID = d.driver_ID
WHERE dstats.stats ? 'championships';

-- 5. Проверка отсутствия ключа (пример с несуществующим ключом)
-- Источник: пособие, стр. 98 (ключ 'sport' отсутствует)
-- Ключ 'test_key' отсутствует

SELECT d.name, dstats.stats
FROM driver_stats dstats
JOIN drivers d ON dstats.driver_ID = d.driver_ID
WHERE dstats.stats ? 'test_key';

-- 6. Обновление JSON-объекта
-- Источник: пособие, стр. 99 (пример с Батовой А.Д.)
-- Изменим количество побед Леклера с 5 на 6

UPDATE driver_stats
SET stats = jsonb_set(stats, '{wins}', '6'::jsonb)
WHERE driver_ID = 1;

-- 7. Добавление нового поля в JSON-объект
-- Добавим поле 'dnf' (Did Not Finish - не финишировал)

UPDATE driver_stats
SET stats = stats || '{"dnf": 2}'::jsonb
WHERE driver_ID = 1;

-- 8. Удаление поля из JSON-объекта
-- Удалим поле 'dnf'

UPDATE driver_stats
SET stats = stats - 'dnf'
WHERE driver_ID = 1;

-- 9. Выборка с агрегацией по JSON-полям
-- Выборка пилотов с очками больше 250

SELECT d.name, (dstats.stats->>'points')::numeric AS points
FROM driver_stats dstats
JOIN drivers d ON dstats.driver_ID = d.driver_ID
WHERE (dstats.stats->>'points')::numeric > 250
ORDER BY points DESC;

-- 10. Выборка с несколькими условиями по JSON
-- Пилоты с >= 5 побед и >= 10 подиумов

SELECT d.name,
       (dstats.stats->>'wins')::integer AS wins,
       (dstats.stats->>'podiums')::integer AS podiums
FROM driver_stats dstats
JOIN drivers d ON dstats.driver_ID = d.driver_ID
WHERE (dstats.stats->>'wins')::integer >= 5
  AND (dstats.stats->>'podiums')::integer >= 10;

-- 11. Обновление нескольких полей одновременно
-- Увеличим победы и подиумы на 1

UPDATE driver_stats
SET stats = jsonb_set(
    jsonb_set(stats, '{wins}', ((stats->>'wins')::integer + 1)::text::jsonb),
    '{podiums}',
    ((stats->>'podiums')::integer + 1)::text::jsonb
)
WHERE driver_ID = 2;

-- Проверка результатов
SELECT * FROM driver_stats;
