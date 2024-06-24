-- artist_genres
CREATE INDEX idx_artist_genres_genre_id ON artist_genres USING btree (genre_id);
CREATE INDEX idx_artist_genres_artist_id ON artist_genres USING btree (artist_id);

-- release_artists
CREATE INDEX idx_release_artists_release_id ON release_artists USING btree (release_id);
CREATE INDEX idx_release_artists_artist_id ON release_artists USING btree (artist_id);

-- user_reviews
CREATE INDEX idx_user_reviews_release_id ON user_reviews USING btree (release_id);

-- genres
CREATE INDEX idx_genres_id ON genres USING btree (id);

-- artists
CREATE INDEX idx_artists_id ON artists USING btree (id);
