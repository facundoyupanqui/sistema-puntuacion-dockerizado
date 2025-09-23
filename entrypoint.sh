#!/bin/sh
set -e

echo "Waiting for database $MYSQL_HOST:$MYSQL_PORT..."
MYSQL_HOST=${MYSQL_HOST:-db}
MYSQL_PORT=${MYSQL_PORT:-3306}

until nc -z "$MYSQL_HOST" "$MYSQL_PORT"; do
  echo "DB not ready, sleeping..."
  sleep 2
done

echo "Running migrations..."
python manage.py migrate --noinput

echo "Collecting static files..."
python manage.py collectstatic --noinput

echo "Starting gunicorn..."
exec gunicorn config.wsgi:application --bind 0.0.0.0:5001 --workers 3 --timeout 60 --graceful-timeout 60


