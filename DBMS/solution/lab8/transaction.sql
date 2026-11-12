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

SELECT team_ID, name, base
FROM teams
ORDER BY team_ID;
