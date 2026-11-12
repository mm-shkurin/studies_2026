INSERT INTO teams (team_ID, name, base) VALUES
    (1, 'Ferrari', 'Maranello'),
    (2, 'Mercedes', 'Brackley');

INSERT INTO drivers (driver_ID, name, country, team_ID) VALUES
    (1, 'Charles Leclerc', 'Monaco', 1),
    (2, 'Lewis Hamilton', 'UK', 2);

INSERT INTO cars (car_ID, model, year, team_ID) VALUES
    (1, 'SF-24', 2026, 1),
    (2, 'W15', 2026, 2),
    (3, 'SF-24B', 2026, 1);

INSERT INTO tracks (track_ID, name, country, length_km) VALUES
    (1, 'Circuit de Monaco', 'Monaco', 3.337),
    (2, 'Silverstone', 'UK', 5.891);

INSERT INTO sponsors (sponsor_ID, name, budget) VALUES
    (1, 'Rolex', 50000000);

INSERT INTO races (race_ID, name, date, track_ID, sponsor_ID) VALUES
    (1, 'Monaco Grand Prix', DATE '2026-05-24', 1, 1),
    (2, 'British Grand Prix', DATE '2026-07-05', 2, 1);

INSERT INTO results (race_ID, driver_ID, car_ID, position, points) VALUES
    (1, 1, 1, 1, 25.0),
    (1, 2, 2, 2, 18.0),
    (2, 1, 3, 2, 18.0),
    (2, 2, 2, 1, 25.0);

CALL result_select(NULL, NULL, NULL);
CALL result_select(1, NULL, NULL);
CALL result_select(NULL, 1, NULL);
CALL result_select(NULL, NULL, 1);
CALL result_select(1, 1, NULL);

TRUNCATE may_results;
CALL fill_may();

SELECT race_ID, driver_ID, car_ID, position, points
FROM may_results
ORDER BY race_ID, position;

DO $$
DECLARE
    n integer;
    n_may integer;
BEGIN
    SELECT count(*) INTO n_may FROM may_results;
    SELECT count(*) INTO n
    FROM results res
    JOIN races r ON r.race_ID = res.race_ID
    WHERE r.date BETWEEN DATE '2026-05-01' AND DATE '2026-05-31';
    IF n_may <> 2 OR n <> 2 THEN
        RAISE EXCEPTION 'may_results=% select=%', n_may, n;
    END IF;
    RAISE NOTICE 'OK may';
END $$;
