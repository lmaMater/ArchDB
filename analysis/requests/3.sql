-- Request 3: Amount of registered users by month within last 5 years
WITH months AS (
    SELECT TO_CHAR(generate_series(date_trunc('month', CURRENT_DATE - INTERVAL '5 years'), date_trunc('month', CURRENT_DATE), '1 month'::interval), 'YYYY-MM') AS year_month
)
SELECT
    m.year_month,
    COUNT(u.creation_date) AS user_count
FROM
    months m
LEFT JOIN
    users u
ON
    TO_CHAR(u.creation_date, 'YYYY-MM') = m.year_month
GROUP BY
    m.year_month
ORDER BY
    m.year_month;

