#!/bin/bash

python3 /app/fetch_schema.py

pg_ctl -D "/var/lib/postgresql/data" -o "-c listen_addresses=''" -w start

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /app/schema.sql

if [ "$PROJECT_NAME" = "fertiscan" ]; then
    curl -o /app/init_data.sql https://raw.githubusercontent.com/ai-cfia/ailab-datastore/main/datastore/db/bytebase/FertiScan/init_data.sql
    
    psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /app/init_data.sql
fi

pg_ctl -D "/var/lib/postgresql/data" -m fast -w stop

exec docker-entrypoint.sh "$@"
