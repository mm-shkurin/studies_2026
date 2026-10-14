-- ЛР 4: Создание таблицы с JSON
-- Источник: пособие, стр. 96–97 (таблица hobbies)
-- Рекомендация: использовать jsonb (стр. 95)

-- Таблица: статистика пилота (победы, подиумы, лучшие круги и т.д. в формате JSON)
-- Связь с таблицей drivers: 1:1 (один пилот — одна запись статистики)

CREATE TABLE driver_stats (
    stats_id serial NOT NULL,
    driver_ID integer NOT NULL UNIQUE,
    stats jsonb NOT NULL,  -- статистика в формате JSONB
    CONSTRAINT driver_stats_PK PRIMARY KEY (stats_id),
    CONSTRAINT driver_stats_FK FOREIGN KEY (driver_ID)
        REFERENCES drivers(driver_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE
);

COMMENT ON TABLE driver_stats IS 'Статистика пилота в формате JSONB';
COMMENT ON COLUMN driver_stats.stats IS 'JSON-объект с полями: wins, podiums, pole_positions, fastest_laps, championships, points';
