CREATE TABLE if not exists user_review_comments
(
    id                SERIAL PRIMARY KEY,
    review_user_id    INT       NOT NULL REFERENCES users (id),
    review_release_id INT       NOT NULL REFERENCES releases (id),
    user_id           INT       NOT NULL REFERENCES users (id),
    content           TEXT      NOT NULL,
    time              TIMESTAMP NOT NULL,
    UNIQUE (review_user_id, review_release_id, user_id, time)
);
