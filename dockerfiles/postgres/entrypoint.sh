#!/bin/bash

python3 /app/fetch_schema.py

pg_ctl -D "/var/lib/postgresql/data" -o "-c listen_addresses=''" -w start

psql -U "$POSTGRES_USER" -d "$POSTGRES_DB" -f /app/schema.sql

pg_ctl -D "/var/lib/postgresql/data" -m fast -w stop

exec docker-entrypoint.sh "$@"
