CREATE TABLE if not exists subscriptions_user_user
(
    user_subscriber_id INT NOT NULL REFERENCES users (id),
    user_id            INT NOT NULL REFERENCES users (id),
    PRIMARY KEY (user_subscriber_id, user_id)
);
