-- KMDB: Kellogg Movie Database
-- Christopher Nolan's Batman Trilogy

.mode column
.headers off

-- ============================================================
-- DROP TABLES (in reverse dependency order)
-- ============================================================
DROP TABLE IF EXISTS roles;
DROP TABLE IF EXISTS movies;
DROP TABLE IF EXISTS actors;
DROP TABLE IF EXISTS studios;
DROP TABLE IF EXISTS agents;

-- ============================================================
-- CREATE TABLES
-- ============================================================

CREATE TABLE agents (
  agent_id   INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT NOT NULL
);

CREATE TABLE studios (
  studio_id  INTEGER PRIMARY KEY AUTOINCREMENT,
  name       TEXT NOT NULL
);

CREATE TABLE movies (
  movie_id      INTEGER PRIMARY KEY AUTOINCREMENT,
  title         TEXT NOT NULL,
  year_released INTEGER NOT NULL,
  mpaa_rating   TEXT NOT NULL,
  studio_id     INTEGER NOT NULL,
  FOREIGN KEY (studio_id) REFERENCES studios(studio_id)
);

CREATE TABLE actors (
  actor_id  INTEGER PRIMARY KEY AUTOINCREMENT,
  name      TEXT NOT NULL,
  agent_id  INTEGER,
  FOREIGN KEY (agent_id) REFERENCES agents(agent_id)
);

-- "roles" captures the many-to-many relationship between actors and movies
CREATE TABLE roles (
  role_id        INTEGER PRIMARY KEY AUTOINCREMENT,
  movie_id       INTEGER NOT NULL,
  actor_id       INTEGER NOT NULL,
  character_name TEXT NOT NULL,
  billing_order  INTEGER NOT NULL,
  FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
  FOREIGN KEY (actor_id) REFERENCES actors(actor_id)
);

-- ============================================================
-- INSERT DATA
-- ============================================================

-- Agents
INSERT INTO agents (name) VALUES ('CAA');         -- agent_id = 1

-- Studios
INSERT INTO studios (name) VALUES ('Warner Bros.');  -- studio_id = 1

-- Movies
INSERT INTO movies (title, year_released, mpaa_rating, studio_id) VALUES
  ('Batman Begins',         2005, 'PG-13', 1),  -- movie_id = 1
  ('The Dark Knight',       2008, 'PG-13', 1),  -- movie_id = 2
  ('The Dark Knight Rises', 2012, 'PG-13', 1);  -- movie_id = 3

-- Actors
INSERT INTO actors (name) VALUES
  ('Christian Bale'),       -- actor_id = 1
  ('Michael Caine'),        -- actor_id = 2
  ('Liam Neeson'),          -- actor_id = 3
  ('Katie Holmes'),         -- actor_id = 4
  ('Gary Oldman'),          -- actor_id = 5
  ('Heath Ledger'),         -- actor_id = 6
  ('Aaron Eckhart'),        -- actor_id = 7
  ('Maggie Gyllenhaal'),    -- actor_id = 8
  ('Tom Hardy'),            -- actor_id = 9
  ('Joseph Gordon-Levitt'), -- actor_id = 10
  ('Anne Hathaway');        -- actor_id = 11

-- Roles: Batman Begins (movie_id = 1)
INSERT INTO roles (movie_id, actor_id, character_name, billing_order) VALUES
  (1, 1,  'Bruce Wayne',        1),
  (1, 2,  'Alfred',             2),
  (1, 3,  'Ra''s Al Ghul',      3),
  (1, 4,  'Rachel Dawes',       4),
  (1, 5,  'Commissioner Gordon',5);

-- Roles: The Dark Knight (movie_id = 2)
INSERT INTO roles (movie_id, actor_id, character_name, billing_order) VALUES
  (2, 1,  'Bruce Wayne',        1),
  (2, 6,  'Joker',              2),
  (2, 7,  'Harvey Dent',        3),
  (2, 2,  'Alfred',             4),
  (2, 8,  'Rachel Dawes',       5);

-- Roles: The Dark Knight Rises (movie_id = 3)
INSERT INTO roles (movie_id, actor_id, character_name, billing_order) VALUES
  (3, 1,  'Bruce Wayne',        1),
  (3, 5,  'Commissioner Gordon',2),
  (3, 9,  'Bane',               3),
  (3, 10, 'John Blake',         4),
  (3, 11, 'Selina Kyle',        5);

-- ============================================================
-- UPDATE: Assign agent to Christian Bale (actor_id = 1)
-- ============================================================
UPDATE actors SET agent_id = 1 WHERE actor_id = 1;

-- ============================================================
-- REPORT
-- ============================================================

.print "Movies"
.print "======"
.print ""

-- (a) List of movies with studio
SELECT
  m.title,
  m.year_released,
  m.mpaa_rating,
  s.name
FROM movies m
JOIN studios s ON m.studio_id = s.studio_id
ORDER BY m.year_released;

.print ""
.print "Top Cast"
.print "========"
.print ""

-- (b) Cast for each movie, ordered by movie then billing
SELECT
  m.title,
  a.name,
  r.character_name
FROM roles r
JOIN movies m ON r.movie_id = m.movie_id
JOIN actors a ON r.actor_id = a.actor_id
ORDER BY m.year_released, r.billing_order;

.print ""
.print "Represented by agent"
.print "===================="
.print ""

-- (c) Actors represented by agent_id = 1
SELECT a.name
FROM actors a
JOIN agents ag ON a.agent_id = ag.agent_id
WHERE ag.agent_id = 1;