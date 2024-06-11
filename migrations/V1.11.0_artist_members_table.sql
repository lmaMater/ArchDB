CREATE TABLE if not exists artist_members
(
    artist_id INT NOT NULL REFERENCES artists (id),
    member_id INT NOT NULL REFERENCES artists (id),
    PRIMARY KEY (artist_id, member_id)
);
