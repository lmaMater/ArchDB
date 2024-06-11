-- Request 1: Highest rated artist by genres
WITH GenreArtistRatings AS (
    SELECT
        g.name AS genre_name,
        a.id AS artist_id,
        a.name AS artist_name,
        AVG(ur.rating) AS avg_rating
    FROM
        genres g
    JOIN
        artist_genres ag ON g.id = ag.genre_id
    JOIN
        artists a ON ag.artist_id = a.id
    JOIN
        release_artists ra ON a.id = ra.artist_id
    JOIN
        releases r ON ra.release_id = r.id
    JOIN
        user_reviews ur ON ur.release_id = r.id
    GROUP BY
        g.name, a.id, a.name
)
SELECT
    genre_name,
    artist_id,
    artist_name,
    avg_rating
FROM (
    SELECT
        genre_name,
        artist_id,
        artist_name,
        avg_rating,
        ROW_NUMBER() OVER (PARTITION BY genre_name ORDER BY avg_rating DESC) AS rn
    FROM
        GenreArtistRatings
) sub
WHERE
    rn = 1;
