-- Request 1: Highest rated artist by genres
WITH GenreArtistRatings AS (
    SELECT
        g.id AS genre_id,
        g.name AS genre_name,
        a.id AS artist_id,
        a.name AS artist_name,
        AVG(ur.rating) AS average_rating
    FROM
        genres g
        JOIN artist_genres ag ON g.id = ag.genre_id
        JOIN artists a ON ag.artist_id = a.id
        JOIN release_artists ra ON a.id = ra.artist_id
        JOIN user_reviews ur ON ra.release_id = ur.release_id
    GROUP BY
        g.id, g.name, a.id, a.name
),
RankedRatings AS (
    SELECT
        gar.*,
        RANK() OVER (PARTITION BY gar.genre_id ORDER BY gar.average_rating DESC) AS ranking
    FROM
        GenreArtistRatings gar
)
SELECT
    genre_name,
    artist_name,
    average_rating
FROM
    RankedRatings
WHERE
    ranking = 1;

