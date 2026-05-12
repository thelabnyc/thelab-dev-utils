#!/usr/bin/env bash

set -euxo pipefail

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc \
    | gpg --dearmor -o /etc/apt/keyrings/pgdg.gpg
echo "deb [signed-by=/etc/apt/keyrings/pgdg.gpg] http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" \
    > /etc/apt/sources.list.d/pgdg.list

apt-get update
apt-get install -y \
    "postgresql-${POSTGRES_VERSION}" \
    "python3-psycopg2"

# Cleanup
rm -rf /var/lib/apt/lists/*
