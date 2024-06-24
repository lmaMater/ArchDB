CREATE TABLE if not exists user_review_likes
(
    review_user_id    INT       NOT NULL REFERENCES users (id),
    review_release_id INT       NOT NULL REFERENCES releases (id),
    user_id           INT       NOT NULL REFERENCES users (id),
    time              TIMESTAMP NOT NULL,
    PRIMARY KEY (review_user_id, review_release_id, user_id)
);
