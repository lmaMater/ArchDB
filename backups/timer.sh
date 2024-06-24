#!/bin/bash

BACKUP_TIME=${BACKUP_TIME}

crontab -r
echo "0 */${BACKUP_TIME} * * * /backups/backup.sh" | crontab -

echo "Starting cron daemon"
crond -f
