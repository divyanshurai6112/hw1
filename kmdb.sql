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
