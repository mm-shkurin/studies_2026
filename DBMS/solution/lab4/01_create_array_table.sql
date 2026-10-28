
CREATE TABLE driver_season_races (
    season_id serial NOT NULL,
    driver_ID integer NOT NULL,
    year integer NOT NULL,
    race_ids integer[] NOT NULL,
    CONSTRAINT driver_season_races_PK PRIMARY KEY (season_id),
    CONSTRAINT driver_season_races_FK FOREIGN KEY (driver_ID)
        REFERENCES drivers(driver_ID)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT driver_season_races_year_CHK CHECK (year >= 1950 AND year <= 2030)
);

COMMENT ON TABLE driver_season_races IS 'Участие пилота в гонках сезона (массив race_ID)';
COMMENT ON COLUMN driver_season_races.race_ids IS 'Массив ID гонок, в которых участвовал пилот в этом сезоне';
