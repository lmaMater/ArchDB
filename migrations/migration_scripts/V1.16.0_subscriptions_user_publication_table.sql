CREATE TABLE if not exists subscriptions_user_publication
(
    user_subscriber_id INT NOT NULL REFERENCES users (id),
    publication_id     INT NOT NULL REFERENCES publications (id),
    PRIMARY KEY (user_subscriber_id, publication_id)
);
