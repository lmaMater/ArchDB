CREATE TABLE if not exists release_genres (
  release_id INT NOT NULL REFERENCES releases(id),
  genre_id INT NOT NULL REFERENCES genres(id),
  PRIMARY KEY (release_id, genre_id)
);
