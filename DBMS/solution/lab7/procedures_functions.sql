DROP PROCEDURE IF EXISTS team_insert(INTEGER, VARCHAR, VARCHAR);
DROP PROCEDURE IF EXISTS team_update(INTEGER, VARCHAR, VARCHAR);
DROP PROCEDURE IF EXISTS team_delete(INTEGER);
DROP FUNCTION IF EXISTS driver_insert(INTEGER, VARCHAR, VARCHAR, INTEGER);
DROP PROCEDURE IF EXISTS driver_update(INTEGER, VARCHAR, VARCHAR, INTEGER);
DROP PROCEDURE IF EXISTS driver_delete(INTEGER);
DROP FUNCTION IF EXISTS get_team_stats(INTEGER);
DROP FUNCTION IF EXISTS get_driver_stats(INTEGER);

CREATE OR REPLACE PROCEDURE team_insert(p_team_id INTEGER, p_name VARCHAR(100), p_base VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO teams (team_ID, name, base)
    VALUES (p_team_id, p_name, p_base);
END;
$$;

CREATE OR REPLACE PROCEDURE team_update(p_team_id INTEGER, p_name VARCHAR(100), p_base VARCHAR(100))
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE teams
    SET name = p_name,
        base = p_base
    WHERE team_ID = p_team_id;
END;
$$;

CREATE OR REPLACE PROCEDURE team_delete(p_team_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM teams
    WHERE team_ID = p_team_id;
END;
$$;

CREATE OR REPLACE FUNCTION driver_insert(p_driver_id INTEGER, p_name VARCHAR(100), p_country VARCHAR(50), p_team_id INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO drivers (driver_ID, name, country, team_ID)
    VALUES (p_driver_id, p_name, p_country, p_team_id);

    RETURN p_driver_id;
END;
$$;

CREATE OR REPLACE PROCEDURE driver_update(p_driver_id INTEGER, p_name VARCHAR(100), p_country VARCHAR(50), p_team_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE drivers
    SET name = p_name,
        country = p_country,
        team_ID = p_team_id
    WHERE driver_ID = p_driver_id;
END;
$$;

CREATE OR REPLACE PROCEDURE driver_delete(p_driver_id INTEGER)
LANGUAGE plpgsql
AS $$
BEGIN
    DELETE FROM drivers
    WHERE driver_ID = p_driver_id;
END;
$$;

CREATE OR REPLACE FUNCTION get_team_stats(p_team_id INTEGER)
RETURNS TABLE(driver_count BIGINT, total_points NUMERIC(8,1))
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT COUNT(d.driver_ID),
           COALESCE(SUM(r.points), 0)
    FROM drivers d
    LEFT JOIN results r ON d.driver_ID = r.driver_ID
    WHERE d.team_ID = p_team_id
    GROUP BY d.team_ID;
END;
$$;

CREATE OR REPLACE FUNCTION get_driver_stats(p_driver_id INTEGER, OUT race_count BIGINT, OUT total_points NUMERIC, OUT avg_points NUMERIC)
LANGUAGE plpgsql
AS $$
BEGIN
    SELECT COUNT(r.race_ID),
           COALESCE(SUM(r.points), 0),
           COALESCE(AVG(r.points), 0)
    INTO race_count, total_points, avg_points
    FROM results r
    WHERE r.driver_ID = p_driver_id;
END;
$$;
