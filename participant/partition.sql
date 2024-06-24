ALTER TABLE user_reviews RENAME TO user_reviews_old;

CREATE TABLE user_reviews
(
    user_id    INT       NOT NULL REFERENCES users (id),
    release_id INT       NOT NULL REFERENCES releases (id),
    content    TEXT,
    created_at TIMESTAMP NOT NULL,
    rating     INT CHECK (rating >= 0 AND rating <= 100),
    PRIMARY KEY (user_id, release_id, created_at)  -- Включение created_at в первичный ключ
) PARTITION BY RANGE (created_at);

CREATE TABLE user_reviews_before_2020 PARTITION OF user_reviews
FOR VALUES FROM (MINVALUE) TO ('2020-01-01');

CREATE TABLE user_reviews_2020_2022 PARTITION OF user_reviews
FOR VALUES FROM ('2020-01-01') TO ('2022-01-01');

CREATE TABLE user_reviews_after_2022 PARTITION OF user_reviews
FOR VALUES FROM ('2022-01-01') TO (MAXVALUE);

INSERT INTO user_reviews
SELECT * FROM user_reviews_old
WHERE created_at < '2020-01-01';

INSERT INTO user_reviews
SELECT * FROM user_reviews_old
WHERE created_at >= '2020-01-01' AND created_at < '2022-01-01';

INSERT INTO user_reviews
SELECT * FROM user_reviews_old
WHERE created_at >= '2022-01-01';

DROP TABLE user_reviews_old;

CREATE INDEX ON user_reviews_before_2020 (user_id, release_id, created_at);
CREATE INDEX ON user_reviews_2020_2022 (user_id, release_id, created_at);
CREATE INDEX ON user_reviews_after_2022 (user_id, release_id, created_at);
