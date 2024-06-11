CREATE TABLE if not exists releases
(
    id     SERIAL PRIMARY KEY,
    title  VARCHAR        NOT NULL,
    cover  VARCHAR        NOT NULL,
    date   DATE           NOT NULL,
    format release_format NOT NULL
);
