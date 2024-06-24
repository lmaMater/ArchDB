CREATE TABLE if not exists users
(
    id            SERIAL PRIMARY KEY,
    username      VARCHAR UNIQUE NOT NULL,
    role          user_role      NOT NULL,
    email         VARCHAR UNIQUE NOT NULL,
    creation_date DATE           NOT NULL,
    description   VARCHAR
);
