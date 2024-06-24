CREATE TABLE if not exists release_artists
(
    release_id INT NOT NULL REFERENCES releases (id),
    artist_id  INT NOT NULL REFERENCES artists (id),
    PRIMARY KEY (release_id, artist_id)
);
