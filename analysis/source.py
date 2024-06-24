import psycopg2
import os
from datetime import datetime

db_name = os.getenv('DB_NAME')
db_user = os.getenv('DB_USER')
db_password = os.getenv('DB_PASSWORD')
db_host = os.getenv('DB_HOST')
db_port = os.getenv('DB_PORT')

num_queries = int(os.getenv('NUM_QUERIES', 5))


try:
    connection = psycopg2.connect(
        database=db_name,
        user=db_user,
        password=db_password,
        host=db_host,
        port=db_port
    )
    print('Database connected successfully')
except Exception as e:
    print(f'Database not connected successfully: {e}')

if connection:
    cursor = connection.cursor()
    print('Cursor created successfully')

    sql_queries = [
        '''
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
        ''',
        '''
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
        ''',
        '''
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
        '''
    ]

    results_dir = '/app/analysis_results'
    if not os.path.exists(results_dir):
        os.makedirs(results_dir)

    current_time = datetime.now().strftime('%Y-%m-%d_%H-%M-%S')

    # Запросы
    with open(f'{results_dir}/{current_time}_result.txt', 'a') as f:
        f.write(f'num_queries: {num_queries}\n')
        f.write('__________________________')

    for query_index, query in enumerate(sql_queries):
        costs = []
        for i in range(num_queries):
            cursor.execute("EXPLAIN ANALYZE " + query)
            explain_result = cursor.fetchall()
            cost = float(explain_result[-1][0].split(" ")[-2])
            costs += [cost]

        with open(f'{results_dir}/{current_time}_result.txt', 'a') as f:
            f.write(f'\nquery: {query_index + 1}\n')
            f.write(f'best    time: {min(costs)} ms\n')
            f.write(f'worst   time: {max(costs)} ms\n')
            f.write(f'average time: {sum(costs)/len(costs)} ms\n')
            f.write('__________________________')

    # Закрытие соединения с БД
    cursor.close()
    connection.close()
