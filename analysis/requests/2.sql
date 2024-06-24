-- Request 2: Artists reviewed by random user
WITH RandomUser AS (
    SELECT id
    FROM users
    ORDER BY random()
    LIMIT 1
)
SELECT
    ur.user_id AS user_id,
    a.id AS artist_id,
    a.name AS artist_name
FROM
    RandomUser ru
JOIN
    user_reviews ur ON ru.id = ur.user_id
JOIN
    release_artists ra ON ur.release_id = ra.release_id
JOIN
    artists a ON ra.artist_id = a.id;
