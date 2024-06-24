CREATE TABLE if not exists publications
(
    id   SERIAL PRIMARY KEY,
    name VARCHAR NOT NULL,
    link VARCHAR
);
