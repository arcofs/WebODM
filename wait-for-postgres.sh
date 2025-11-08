#!/bin/bash

set -e

host="$1"
# Support optional port parameter (backward compatible)
if [[ "$2" =~ ^[0-9]+$ ]]; then
    port="$2"
    shift 2
else
    port="${WO_DATABASE_PORT:-5432}"
    shift
fi
cmd="$@"

until psql -h "$host" -p "$port" -U "postgres" -c '\q'; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

>&2 echo "Postgres is up - executing command"
exec $cmd