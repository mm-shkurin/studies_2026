-- 1. СОЗДАНИЕ НОВЫХ ТАБЛИЦ (CREATE TABLE)

CREATE TABLE staff (
    staff_ID serial NOT NULL,
    full_name varchar(100) NOT NULL,
    role varchar(50) NOT NULL,
    team_ID integer,
    hire_date date DEFAULT CURRENT_DATE,
    salary numeric(10,2),
    CONSTRAINT staff_PK PRIMARY KEY (staff_ID),
    CONSTRAINT staff_salary_CHK CHECK (salary >= 0),
    CONSTRAINT staff_FK FOREIGN KEY (team_ID)
        REFERENCES teams(team_ID)
        ON DELETE SET NULL
        ON UPDATE CASCADE
);

COMMENT ON TABLE staff IS 'Персонал команд';

CREATE TABLE temp_log (
    log_ID serial PRIMARY KEY,
    message text NOT NULL,
    created_at timestamp DEFAULT now()
);

CREATE TABLE temp_archive (
    archive_ID serial PRIMARY KEY,
    log_ID integer NOT NULL,
    CONSTRAINT temp_archive_FK FOREIGN KEY (log_ID)
        REFERENCES temp_log(log_ID)
        ON DELETE CASCADE
);

-- 2. ИЗМЕНЕНИЕ СТРУКТУРЫ ТАБЛИЦ (ALTER TABLE)

ALTER TABLE drivers ADD COLUMN birth_year integer;

ALTER TABLE drivers ADD COLUMN height_cm numeric(4,1) CHECK (height_cm > 0);

ALTER TABLE drivers ALTER COLUMN country TYPE varchar(100);

ALTER TABLE drivers ALTER COLUMN birth_year SET DEFAULT 2000;

ALTER TABLE drivers ALTER COLUMN birth_year DROP DEFAULT;

ALTER TABLE drivers ALTER COLUMN country DROP NOT NULL;

ALTER TABLE drivers ALTER COLUMN country SET NOT NULL;

ALTER TABLE drivers RENAME COLUMN height_cm TO height;

ALTER TABLE drivers ADD CONSTRAINT drivers_birth_year_CHK
    CHECK (birth_year BETWEEN 1950 AND 2010);

ALTER TABLE drivers DROP CONSTRAINT drivers_birth_year_CHK;

ALTER TABLE temp_log RENAME TO event_log;

ALTER TABLE tracks ADD COLUMN length_meters integer
    GENERATED ALWAYS AS ((length_km * 1000)::integer) STORED;

ALTER TABLE staff ADD CONSTRAINT staff_role_team_UQ UNIQUE (role, team_ID);

-- 3. УДАЛЕНИЕ ТАБЛИЦ (DROP TABLE)

DROP TABLE temp_archive;

CREATE TABLE demo_parent (id integer PRIMARY KEY, val text);
CREATE TABLE demo_child  (id integer PRIMARY KEY, parent_id integer REFERENCES demo_parent(id));
INSERT INTO demo_parent VALUES (1, 'test');
INSERT INTO demo_child  VALUES (1, 1);

DROP TABLE demo_parent CASCADE;

DROP TABLE IF EXISTS demo_child;
DROP TABLE IF EXISTS nonexistent_table CASCADE;

DROP TABLE staff CASCADE;

-- 4. ОЧИСТКА — возврат исходной структуры

ALTER TABLE drivers DROP COLUMN IF EXISTS birth_year;
ALTER TABLE drivers DROP COLUMN IF EXISTS height;

ALTER TABLE drivers ALTER COLUMN country TYPE varchar(50);

ALTER TABLE tracks DROP COLUMN IF EXISTS length_meters;

-- 5. ПРОВЕРКА РЕЗУЛЬТАТОВ

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'drivers' AND table_schema = 'public'
ORDER BY ordinal_position;

SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;

SELECT conname, contype, pg_get_constraintdef(oid)
FROM pg_constraint
WHERE conrelid = 'tracks'::regclass
ORDER BY conname;