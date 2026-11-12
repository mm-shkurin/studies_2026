TRUNCATE teams, cars, drivers, parts, car_parts, sponsors, tracks, races, results, driver_audit RESTART IDENTITY CASCADE;

\echo === transaction with savepoint ===
BEGIN;

INSERT INTO teams (team_ID, name, base)
VALUES (1, 'Ferrari', 'Maranello');

INSERT INTO teams (team_ID, name, base)
VALUES (2, 'Mercedes', 'Brackley');

SAVEPOINT sp_teams;

INSERT INTO teams (team_ID, name, base)
VALUES (3, 'Red Bull', 'Milton Keynes');

INSERT INTO teams (team_ID, name, base)
VALUES (4, 'McLaren', 'Woking');

ROLLBACK TO SAVEPOINT sp_teams;

COMMIT;

SELECT team_ID, name, base FROM teams ORDER BY team_ID;

DO $$
DECLARE
    n integer;
BEGIN
    SELECT count(*) INTO n FROM teams;
    IF n <> 2 THEN
        RAISE EXCEPTION 'after savepoint rollback expected 2 teams, got %', n;
    END IF;
    IF EXISTS (SELECT 1 FROM teams WHERE team_ID IN (3, 4)) THEN
        RAISE EXCEPTION 'teams 3 and 4 must be rolled back';
    END IF;
    RAISE NOTICE 'OK transaction';
END $$;

\echo === DML trigger driver_audit ===
INSERT INTO drivers (driver_ID, name, country, team_ID)
VALUES (1, 'Charles Leclerc', 'Monaco', 1);

UPDATE drivers
SET country = 'Монако'
WHERE driver_ID = 1;

DELETE FROM drivers
WHERE driver_ID = 1;

SELECT operation, userid, driver_ID, name, country, team_ID
FROM driver_audit
ORDER BY stamp, operation;

DO $$
DECLARE
    n_i integer;
    n_u integer;
    n_d integer;
BEGIN
    SELECT count(*) INTO n_i FROM driver_audit WHERE operation = 'I';
    SELECT count(*) INTO n_u FROM driver_audit WHERE operation = 'U';
    SELECT count(*) INTO n_d FROM driver_audit WHERE operation = 'D';
    IF n_i <> 1 OR n_u <> 1 OR n_d <> 1 THEN
        RAISE EXCEPTION 'audit counts I=% U=% D=%', n_i, n_u, n_d;
    END IF;
    RAISE NOTICE 'OK audit';
END $$;

\echo === DML trigger brud ===
DO $$
BEGIN
    INSERT INTO sponsors (sponsor_ID, name, budget)
    VALUES (99, 'Брудастый Орест Сергеевич', 0);
    RAISE EXCEPTION 'forbid trigger did not fire';
EXCEPTION
    WHEN raise_exception THEN
        IF SQLERRM LIKE '%спонсор не обслуживается%' THEN
            RAISE NOTICE 'OK forbid';
        ELSE
            RAISE;
        END IF;
END $$;

INSERT INTO sponsors (sponsor_ID, name, budget)
VALUES (1, 'Rolex', 50000000);

SELECT sponsor_ID, name FROM sponsors ORDER BY sponsor_ID;

\echo === DML trigger team_change_notice ===
UPDATE teams SET base = 'Maranello HQ' WHERE team_ID = 1;

\echo === event triggers ===
CREATE TABLE lab8_event_probe (id integer PRIMARY KEY);
DROP TABLE lab8_event_probe;

DO $$
BEGIN
    IF NOT EXISTS (
        SELECT 1 FROM pg_event_trigger
        WHERE evtname IN ('notice_ddl_end', 'notice_sql_drop')
    ) THEN
        RAISE EXCEPTION 'event triggers missing';
    END IF;
    RAISE NOTICE 'OK event triggers';
END $$;

BEGIN;
DROP TRIGGER brud ON sponsors;
ROLLBACK;

SELECT tgname
FROM pg_trigger
WHERE tgname IN ('driver_audit', 'brud', 'team_change_notice')
  AND NOT tgisinternal
ORDER BY tgname;

SELECT evtname, evtevent
FROM pg_event_trigger
WHERE evtname IN ('notice_ddl_end', 'notice_sql_drop')
ORDER BY evtname;
