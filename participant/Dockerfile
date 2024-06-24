FROM alpine:latest

RUN apk add --no-cache postgresql-client

COPY partition.sh /partition.sh
COPY partition.sql /partition.sql

RUN chmod +x /partition.sh

EXPOSE 8083
CMD ["sh", "/partition.sh"]
