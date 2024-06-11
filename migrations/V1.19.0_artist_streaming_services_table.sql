CREATE TABLE if not exists artist_streaming_services
(
    artist_id            INT            NOT NULL REFERENCES artists (id),
    streaming_service_id INT            NOT NULL REFERENCES streaming_services (id),
    link                 VARCHAR UNIQUE NOT NULL,
    PRIMARY KEY (artist_id, streaming_service_id)
);
