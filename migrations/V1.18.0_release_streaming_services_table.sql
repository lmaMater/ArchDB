CREATE TABLE if not exists release_streaming_services
(
    release_id           INT            NOT NULL REFERENCES releases (id),
    streaming_service_id INT            NOT NULL REFERENCES streaming_services (id),
    link                 VARCHAR UNIQUE NOT NULL,
    PRIMARY KEY (release_id, streaming_service_id)
);
