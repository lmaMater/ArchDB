CREATE TABLE if not exists artist_genres
(
    artist_id INT NOT NULL REFERENCES artists (id),
    genre_id  INT NOT NULL REFERENCES genres (id),
    PRIMARY KEY (artist_id, genre_id)
);
