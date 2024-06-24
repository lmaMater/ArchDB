#!/bin/bash

FILLING_COUNT="${FILLING_COUNT:-1000}"
FILLING_COUNT=$((FILLING_COUNT < 1000 ? 1000 : FILLING_COUNT))
SMALLER_FILLING_COUNT=$((FILLING_COUNT / 10))

GENRES_COUNT=$((SMALLER_FILLING_COUNT > 1000 ? 1000 : FILLING_COUNT))

generate_data() {
  if [ -z "${USER}" ] || [ -z "${PASSWORD}" ]; then
    echo "Environment variables USER and PASSWORD must be set"
    exit 1
  fi

  export PGPASSWORD="${PASSWORD}"
  echo "Using USER: ${USER}"
  echo "Using PASSWORD: ${PASSWORD}"

  # users ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO users (username, role, email, creation_date, description) SELECT 'user' || gs || '_' || md5(random()::text), CASE WHEN random() < 0.80 THEN 'user'::user_role WHEN random() < 0.95 THEN 'premium_user'::user_role ELSE 'admin'::user_role END, 'user' || gs || '_' || md5(random()::text) || '@example.com', CURRENT_DATE - interval '1' day * floor(random() * 3650), 'description' FROM generate_series(1, $SMALLER_FILLING_COUNT) AS gs;" -W

  # artists ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO artists (id, name) SELECT generate_series(1, $SMALLER_FILLING_COUNT), 'artist' || md5(random()::text);" -W

  # releases ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO releases (id, title, cover, date, format) SELECT generate_series(1, $SMALLER_FILLING_COUNT), 'title' || md5(random()::text), 'cover' || generate_series(1, $SMALLER_FILLING_COUNT), CURRENT_DATE - interval '1' day * floor(random() * 18250), CASE WHEN random() < 0.33 THEN 'single'::release_format WHEN random() < 0.66 THEN 'ep'::release_format ELSE 'lp'::release_format END;" -W

  # streaming_services ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO streaming_services (id, name) SELECT generate_series(1, $SMALLER_FILLING_COUNT), 'service' || generate_series(1, $SMALLER_FILLING_COUNT);" -W

  # genres ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO genres (id, name) SELECT generate_series(1, $GENRES_COUNT), 'genre' || generate_series(1, $GENRES_COUNT);" -W

  # publications ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO publications (id, name, link) SELECT generate_series(1, $SMALLER_FILLING_COUNT), 'publication' || generate_series(1, $SMALLER_FILLING_COUNT), 'http://example.com/' || md5(random()::text);" -W

  # release_artists each release - >= 1 artist
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO release_artists (release_id, artist_id)
  SELECT DISTINCT ON (release_id, artist_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS release_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS artist_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # release_producers ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO release_producers (release_id, artist_id)
  SELECT DISTINCT ON (release_id, artist_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS release_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS artist_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # release_genres ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO release_genres (release_id, genre_id)
  SELECT DISTINCT ON (release_id, genre_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS release_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS genre_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # artist_members ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO artist_members (artist_id, member_id)
  SELECT DISTINCT ON (artist_id, member_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS artist_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS member_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # artist_genres ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO artist_genres (artist_id, genre_id)
  SELECT DISTINCT ON (artist_id, genre_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS artist_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS genre_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # subscriptions_user_user ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO subscriptions_user_user (user_subscriber_id, user_id)
  SELECT DISTINCT ON (user_subscriber_id, user_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS user_subscriber_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS user_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # subscriptions_user_publication ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO subscriptions_user_publication (user_subscriber_id, publication_id)
  SELECT DISTINCT ON (user_subscriber_id, publication_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS user_subscriber_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS publication_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # subscriptions_user_artist ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO subscriptions_user_artist (user_subscriber_id, artist_id)
  SELECT DISTINCT ON (user_subscriber_id, artist_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS user_subscriber_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS artist_id
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # release_streaming_services ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO release_streaming_services (release_id, streaming_service_id, link)
  SELECT DISTINCT ON (release_id, streaming_service_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS release_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS streaming_service_id,
      'link' || md5(random()::text)
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # artist_streaming_services ok
  psql -h db -U "${USER}" -d aoty -c "INSERT INTO artist_streaming_services (artist_id, streaming_service_id, link)
  SELECT DISTINCT ON (artist_id, streaming_service_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS artist_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS streaming_service_id,
      'link' || md5(random()::text)
  FROM
      generate_series(1, $FILLING_COUNT);" -W

  # user_reviews ok
  psql -h db -U "${USER}" -d aoty -c "
  INSERT INTO user_reviews (user_id, release_id, content, created_at, rating)
  SELECT DISTINCT ON (user_id, release_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS user_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS release_id,
      md5(random()::text) AS content,
      (SELECT CURRENT_DATE - (random() * interval '5 years')) - (random() * interval '5 years') AS created_at,
      floor(random() * 101) AS rating
  FROM
      generate_series(1, $FILLING_COUNT) gs
  ORDER BY user_id, release_id
  LIMIT $FILLING_COUNT;" -W

  # publication_reviews ok
  psql -h db -U "${USER}" -d aoty -c "
  INSERT INTO publication_reviews (publication_id, release_id, content, created_at, rating, reference)
  SELECT DISTINCT ON (publication_id, release_id)
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS publication_id,
      floor(random() * $SMALLER_FILLING_COUNT) + 1 AS release_id,
      md5(random()::text) AS content,
      (SELECT CURRENT_DATE - (random() * interval '5 years')) - (random() * interval '5 years') AS created_at,
      floor(random() * 101) AS rating,
      'link' || md5(random()::text) AS reference
  FROM
      generate_series(1, $FILLING_COUNT) gs
  ORDER BY publication_id, release_id
  LIMIT $FILLING_COUNT;" -W

  if [ $? -ne 0 ]; then
    echo "Data generation failed"
    exit 1
  fi

  unset PGPASSWORD
}

wait_for_db() {
    until pg_isready -h db -U "${USER}" -d aoty; do
        echo "waiting for db"
        sleep 2
    done
    echo "DB ok!"
}

wait_for_db
generate_data
