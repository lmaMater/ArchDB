CREATE TABLE if not exists publication_reviews
(
    publication_id INT       NOT NULL REFERENCES publications (id),
    release_id     INT       NOT NULL REFERENCES releases (id),
    content        TEXT,
    created_at     TIMESTAMP NOT NULL,
    rating         INT CHECK (rating >= 0 AND rating <= 100),
    reference      VARCHAR,
    PRIMARY KEY (publication_id, release_id)
);
