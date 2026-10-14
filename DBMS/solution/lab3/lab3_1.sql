-- Проверка целостности данных

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

ALTER TABLE staff ADD COLUMN test_age integer DEFAULT -5;

ALTER TABLE staff ADD CONSTRAINT staff_test_age_CHK CHECK (test_age > 0);

DO $$
BEGIN
    BEGIN
        INSERT INTO staff (staff_ID, full_name, role, team_ID, salary, test_age)
        VALUES (100, NULL, 'Инженер', 1, 50000, 25);
        RAISE NOTICE 'FAIL: NULL в NOT NULL поле вставлен';
    EXCEPTION WHEN not_null_violation THEN
        RAISE NOTICE 'OK  NOT NULL: запись с NULL в full_name отклонена';
    END;

    BEGIN
        INSERT INTO staff (staff_ID, full_name, role, team_ID, salary)
        VALUES (101, 'Иван Иванов', 'Инженер', 1, 50000);
        RAISE NOTICE 'FAIL: DEFAULT значение нарушило CHECK и всё равно вставилось';
    EXCEPTION WHEN check_violation THEN
        RAISE NOTICE 'OK  DEFAULT+CHECK: DEFAULT значение -5 отклонено ограничением CHECK';
    END;

    BEGIN
        INSERT INTO staff (staff_ID, full_name, role, team_ID, salary, test_age)
        VALUES (102, 'Пётр Петров', 'Механик', 9999, 40000, 30);
        RAISE NOTICE 'FAIL: несуществующий team_ID вставлен';
    EXCEPTION WHEN foreign_key_violation THEN
        RAISE NOTICE 'OK  FOREIGN KEY: запись с team_ID=9999 отклонена';
    END;

    BEGIN
        INSERT INTO staff (staff_ID, full_name, role, team_ID, salary, test_age)
        VALUES (103, 'Анна Смирнова', 'Дизайнер', 1, 60000, 28);
    END;

    BEGIN
        INSERT INTO staff (staff_ID, full_name, role, team_ID, salary, test_age)
        VALUES (103, 'Дубликат', 'Тест', 1, 10000, 20);
        RAISE NOTICE 'FAIL: дубликат PRIMARY KEY вставлен';
    EXCEPTION WHEN unique_violation THEN
        RAISE NOTICE 'OK  PRIMARY KEY: дубликат staff_ID=103 отклонён';
    END;
END $$;

ALTER TABLE staff DROP COLUMN test_age;

DROP TABLE staff CASCADE;

SELECT column_name, data_type, is_nullable, column_default
FROM information_schema.columns
WHERE table_name = 'staff' AND table_schema = 'public'
ORDER BY ordinal_position;

SELECT tablename
FROM pg_tables
WHERE schemaname = 'public'
ORDER BY tablename;