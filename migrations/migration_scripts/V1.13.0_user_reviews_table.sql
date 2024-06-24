CREATE TABLE if not exists user_reviews
(
    user_id    INT       NOT NULL REFERENCES users (id),
    release_id INT       NOT NULL REFERENCES releases (id),
    content    TEXT,
    created_at TIMESTAMP NOT NULL,
    rating     INT CHECK (rating >= 0 AND rating <= 100),
    PRIMARY KEY (user_id, release_id)
);
