#!/bin/bash

DB_NAME=${DB_NAME}
DB_USER=${USER}
DB_PASSWORD=${PASSWORD}
DB_HOST=${DB_HOST}
DB_PORT=${DB_PORT}
BACKUP_COUNT=${BACKUP_COUNT}

BACKUP_DIR="/backups/db_backups"
mkdir -p ${BACKUP_DIR}

CURRENT_TIME=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="${BACKUP_DIR}/${DB_NAME}_backup_${CURRENT_TIME}.sql"

echo "Starting backup at ${CURRENT_TIME}"
START_TIME=$(date +%s)

PGPASSWORD="${DB_PASSWORD}" pg_dumpall -U "${DB_USER}" -h "${DB_HOST}" -p "${DB_PORT}" > "${BACKUP_FILE}"

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

if [ $? -eq 0 ]; then
    echo "Backup created successfully at ${BACKUP_FILE} (Duration: ${DURATION} seconds)"
else
    echo "Backup failed (Duration: ${DURATION} seconds)"
    exit 1
fi

CURRENT_BACKUP_COUNT=$(ls -1 ${BACKUP_DIR} | wc -l)
echo "Current backup count: ${CURRENT_BACKUP_COUNT}"

if [ ${CURRENT_BACKUP_COUNT} -gt ${BACKUP_COUNT} ]; then
    BACKUPS_TO_DELETE=$(ls -1t ${BACKUP_DIR} | tail -n +$((${BACKUP_COUNT} + 1)))
    echo "Backups to delete:"
    echo "${BACKUPS_TO_DELETE}"

    echo "${BACKUPS_TO_DELETE}" | xargs -I {} rm -f "${BACKUP_DIR}/{}"
    if [ $? -eq 0 ]; then
        echo "Old backups deleted! Keeping only the latest ${BACKUP_COUNT} backups."
    else
        echo "Failed to delete old backups."
    fi
fi
