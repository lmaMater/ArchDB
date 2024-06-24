FROM alpine:latest

RUN apk add --no-cache postgresql-client bash

COPY backup.sh /backups/backup.sh
COPY timer.sh /backups/timer.sh

RUN chmod u+x /backups/backup.sh
RUN chmod u+x /backups/timer.sh

CMD ["sh", "-c", "/backups/backup.sh && /backups/timer.sh && tail -f /dev/null"]
