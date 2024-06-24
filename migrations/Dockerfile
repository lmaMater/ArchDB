FROM alpine:latest

RUN apk add --no-cache postgresql-client bash

COPY version_controller.sh /docker-entrypoint-initdb.d/version_controller.sh

RUN chmod +x /docker-entrypoint-initdb.d/version_controller.sh

CMD ["/docker-entrypoint-initdb.d/version_controller.sh"]