CREATE TABLE if not exists subscriptions_user_artist
(
    user_subscriber_id INT NOT NULL REFERENCES users (id),
    artist_id          INT NOT NULL REFERENCES artists (id),
    PRIMARY KEY (user_subscriber_id, artist_id)
);
