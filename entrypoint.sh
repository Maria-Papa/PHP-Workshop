#!/bin/sh
set -e

echo "⏳ Waiting for PostgreSQL to be available..."
until pg_isready -h postgres -p 5432 -U "$DB_USERNAME" >/dev/null 2>&1; do
  echo "Waiting for postgres at host 'postgres':5432..."
  sleep 1
done
echo "✅ PostgreSQL is ready."

echo "🔧 Fixing Laravel permissions..."
# No chown — user already owns files (host UID:GID)
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

echo "🔧 Clearing and caching Laravel config..."
php artisan config:clear
php artisan cache:clear
php artisan config:cache

echo "🚀 Starting main container command..."
exec "$@"
