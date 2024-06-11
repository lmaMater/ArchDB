FROM alpine:latest

RUN apk add --no-cache postgresql-client
COPY generate_data.sh /generate_data.sh

RUN chmod +x /generate_data.sh

EXPOSE 8081
CMD ["sh", "/generate_data.sh"]
