#!/bin/bash

user="${USER}"
password="${PASSWORD}"

echo "Partition started"

export PGPASSWORD="${password}"
psql -h db -U user -d aoty -f /partition.sql
unset PGPASSWORD

echo "Partition ended"
