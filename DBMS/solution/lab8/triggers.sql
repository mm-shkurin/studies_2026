DROP EVENT TRIGGER IF EXISTS notice_ddl_end;
DROP EVENT TRIGGER IF EXISTS notice_sql_drop;
DROP TRIGGER IF EXISTS driver_audit ON drivers;
DROP TRIGGER IF EXISTS brud ON sponsors;
DROP TRIGGER IF EXISTS team_change_notice ON teams;
DROP FUNCTION IF EXISTS process_driver_audit();
DROP FUNCTION IF EXISTS forbid_brud();
DROP FUNCTION IF EXISTS notice_team_change();
DROP FUNCTION IF EXISTS notice_ddl();
DROP FUNCTION IF EXISTS notice_drop();
DROP TABLE IF EXISTS driver_audit;

CREATE TABLE driver_audit (
    operation char(1) NOT NULL,
    stamp timestamp NOT NULL,
    userid text NOT NULL,
    driver_ID integer NOT NULL,
    name varchar(100) NOT NULL,
    country varchar(50) NOT NULL,
    team_ID integer NOT NULL
);

CREATE OR REPLACE FUNCTION process_driver_audit()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF (TG_OP = 'DELETE') THEN
        INSERT INTO driver_audit
        SELECT 'D', now(), user, OLD.*;
    ELSIF (TG_OP = 'UPDATE') THEN
        INSERT INTO driver_audit
        SELECT 'U', now(), user, NEW.*;
    ELSIF (TG_OP = 'INSERT') THEN
        INSERT INTO driver_audit
        SELECT 'I', now(), user, NEW.*;
    END IF;
    RETURN NULL;
END;
$$;

CREATE TRIGGER driver_audit
AFTER INSERT OR UPDATE OR DELETE ON drivers
FOR EACH ROW EXECUTE FUNCTION process_driver_audit();

CREATE OR REPLACE FUNCTION forbid_brud()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    IF NEW.name LIKE 'Брудастый%' THEN
        RAISE EXCEPTION 'спонсор не обслуживается';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER brud
BEFORE INSERT ON sponsors
FOR EACH ROW EXECUTE PROCEDURE forbid_brud();

CREATE OR REPLACE FUNCTION notice_team_change()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'trigger %: op % on table %',
        TG_NAME, TG_OP, TG_TABLE_NAME;
    RETURN NULL;
END;
$$;

CREATE TRIGGER team_change_notice
AFTER INSERT OR UPDATE OR DELETE ON teams
FOR EACH STATEMENT EXECUTE FUNCTION notice_team_change();

CREATE OR REPLACE FUNCTION notice_ddl()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
BEGIN
    RAISE NOTICE 'event trigger: event %, tag %',
        TG_EVENT, TG_TAG;
END;
$$;

CREATE EVENT TRIGGER notice_ddl_end
ON ddl_command_end
EXECUTE FUNCTION notice_ddl();

CREATE OR REPLACE FUNCTION notice_drop()
RETURNS event_trigger
LANGUAGE plpgsql
AS $$
DECLARE
    obj record;
BEGIN
    FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
    LOOP
        RAISE NOTICE 'event trigger: % dropped % (%)',
            TG_TAG, obj.object_identity, obj.object_type;
    END LOOP;
END;
$$;

CREATE EVENT TRIGGER notice_sql_drop
ON sql_drop
EXECUTE FUNCTION notice_drop();
