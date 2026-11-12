DROP PROCEDURE IF EXISTS result_select(integer, integer, integer);
DROP PROCEDURE IF EXISTS fill_may();
DROP TABLE IF EXISTS may_results;

CREATE OR REPLACE PROCEDURE result_select(
    IN p_race_id integer,
    IN p_driver_id integer,
    IN p_car_id integer)
LANGUAGE plpgsql
AS $$
DECLARE
    v_race_id integer;
    v_race_name varchar(100);
    v_driver_id integer;
    v_driver_name varchar(100);
    v_car_id integer;
    v_car_model varchar(50);
    v_position integer;
    v_points numeric(4,1);
    cur CURSOR FOR
        SELECT r.race_ID, r.name, d.driver_ID, d.name, c.car_ID, c.model,
               res.position, res.points
        FROM results res
        JOIN races r ON r.race_ID = res.race_ID
        JOIN drivers d ON d.driver_ID = res.driver_ID
        JOIN cars c ON c.car_ID = res.car_ID
        WHERE (p_race_id IS NULL OR res.race_ID = p_race_id)
          AND (p_driver_id IS NULL OR res.driver_ID = p_driver_id)
          AND (p_car_id IS NULL OR res.car_ID = p_car_id)
        ORDER BY res.race_ID, res.position;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO v_race_id, v_race_name, v_driver_id, v_driver_name,
                       v_car_id, v_car_model, v_position, v_points;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'Результат: %, %, %, %, %, %, %, %',
            v_race_id, v_race_name, v_driver_id, v_driver_name,
            v_car_id, v_car_model, v_position, v_points;
    END LOOP;
    CLOSE cur;
END;
$$;

CREATE TABLE may_results (
    race_ID integer NOT NULL,
    driver_ID integer NOT NULL,
    car_ID integer NOT NULL,
    position integer NOT NULL,
    points numeric(4,1) NOT NULL,
    CONSTRAINT may_results_PK PRIMARY KEY (race_ID, driver_ID)
);

CREATE OR REPLACE PROCEDURE fill_may()
LANGUAGE plpgsql
AS $$
DECLARE
    v_race_id integer;
    v_driver_id integer;
    v_car_id integer;
    v_position integer;
    v_points numeric(4,1);
    cur CURSOR FOR
        SELECT res.race_ID, res.driver_ID, res.car_ID, res.position, res.points
        FROM results res
        JOIN races r ON r.race_ID = res.race_ID
        WHERE r.date BETWEEN DATE '2026-05-01' AND DATE '2026-05-31'
        ORDER BY res.race_ID, res.position;
BEGIN
    OPEN cur;
    LOOP
        FETCH cur INTO v_race_id, v_driver_id, v_car_id, v_position, v_points;
        EXIT WHEN NOT FOUND;
        INSERT INTO may_results (race_ID, driver_ID, car_ID, position, points)
        VALUES (v_race_id, v_driver_id, v_car_id, v_position, v_points);
    END LOOP;
    CLOSE cur;
END;
$$;
