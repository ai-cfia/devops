# Custom Postgres image

This repository contains a custom PostgreSQL Docker image that dynamically
fetches the latest database schema from Bytebase during container startup. The
container dynamically retrieves the latest schema for a specified `INSTANCE_ID`
  and `DATABASE_ID` from Bytebase at runtime, ensuring the PostgreSQL database
  is always up-to-date.

## Environment Variables

To configure the schema-fetching process, the following environment variables
are required:

- `BB_URL` – The base URL to access the Bytebase API.
- `BB_SERVICE_ACCOUNT` – The service account email used for authentication with
  Bytebase.
- `BB_SERVICE_KEY` – The API key or password associated with the service
  account.
- `BB_INSTANCE_ID` – The ID of the Bytebase instance containing the desired
  schema.
- `BB_DATABASE_ID` – The ID of the specific database schema to be fetched from
  Bytebase.

## Usage example

The following is an example of how this custom image can be used in a Docker
Compose setup for the **Fertiscan** project:

```yaml
    services:
    postgres:
        image: ghcr.io/ai-cfia/postgres:latest
        container_name: fertiscan-postgres
        environment:
        - POSTGRES_USER=postgres
        - POSTGRES_PASSWORD=postgres
        - POSTGRES_DB=fertiscan
        - BB_URL=${BB_URL}
        - BB_SERVICE_ACCOUNT=${BB_SERVICE_ACCOUNT}
        - BB_SERVICE_KEY=${BB_SERVICE_KEY}
        - INSTANCE_ID=${BB_INSTANCE_ID}
        - DATABASE_ID=${BB_DATABASE_ID}
        env_file:
        - .env
        ports:
        - "5432:5432"
        healthcheck:
        test: ["CMD", "pg_isready", "-U", "postgres"]
        timeout: 10s
        retries: 5
        networks:
        - fertiscan-network
        volumes:
        - postgres-data:/var/lib/postgresql/data
```
