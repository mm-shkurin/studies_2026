INSERT INTO teams (team_ID, name, base) VALUES (1, 'Ferrari', 'Maranello');
INSERT INTO teams (team_ID, name, base) VALUES (2, 'Mercedes', 'Brackley');
INSERT INTO drivers (driver_ID, name, country, team_ID) VALUES (1, 'Charles Leclerc', 'Monaco', 1);
INSERT INTO drivers (driver_ID, name, country, team_ID) VALUES (2, 'Carlos Sainz', 'Spain', 1);
INSERT INTO drivers (driver_ID, name, country, team_ID) VALUES (3, 'Lewis Hamilton', 'UK', 2);
INSERT INTO drivers (driver_ID, name, country, team_ID) VALUES (4, 'George Russell', 'UK', 2);
INSERT INTO tracks (track_ID, name, country, length_km) VALUES (1, 'Circuit de Monaco', 'Monaco', 3.337);
INSERT INTO sponsors (sponsor_ID, name, budget) VALUES (1, 'Rolex', 50000000);
INSERT INTO races (race_ID, name, date, track_ID, sponsor_ID) VALUES (1, 'Monaco Grand Prix', '2026-05-24', 1, 1);
INSERT INTO cars (car_ID, model, year, team_ID) VALUES (1, 'SF-24', 2026, 1);
INSERT INTO cars (car_ID, model, year, team_ID) VALUES (2, 'SF-24', 2026, 1);
INSERT INTO cars (car_ID, model, year, team_ID) VALUES (3, 'W15', 2026, 2);
INSERT INTO cars (car_ID, model, year, team_ID) VALUES (4, 'W15', 2026, 2);
INSERT INTO results (race_ID, driver_ID, car_ID, position, points) VALUES (1, 1, 1, 1, 25.0);
INSERT INTO results (race_ID, driver_ID, car_ID, position, points) VALUES (1, 2, 2, 3, 15.0);
INSERT INTO results (race_ID, driver_ID, car_ID, position, points) VALUES (1, 3, 3, 2, 18.0);
INSERT INTO results (race_ID, driver_ID, car_ID, position, points) VALUES (1, 4, 4, 4, 12.0);

CALL team_insert(3, 'Red Bull Racing', 'Milton Keynes');
SELECT * FROM teams WHERE name = 'Red Bull Racing';

CALL team_update(3, 'Red Bull Racing', 'Milton Keynes, UK');
SELECT * FROM teams WHERE team_ID = 3;

CALL team_delete(3);
SELECT * FROM teams WHERE team_ID = 3;

SELECT driver_insert(5, 'Max Verstappen', 'Netherlands', 2);
SELECT * FROM drivers WHERE name = 'Max Verstappen';

CALL driver_update(5, 'Max Verstappen', 'Netherlands', 2);
SELECT * FROM drivers WHERE driver_ID = 5;

CALL driver_delete(5);
SELECT * FROM drivers WHERE driver_ID = 5;

SELECT * FROM get_team_stats(1);
SELECT * FROM get_team_stats(2);

SELECT * FROM get_driver_stats(1);
SELECT * FROM get_driver_stats(2);
SELECT * FROM get_driver_stats(3);
SELECT * FROM get_driver_stats(4);
