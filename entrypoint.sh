#!/bin/sh

set -e

# Wait for PostgreSQL to be ready
echo "⏳ Waiting for PostgreSQL to be available..."
until pg_isready -h postgres -p 5432 -U "$DB_USERNAME"; do
  echo "Waiting for postgres at host 'postgres':5432..."
  sleep 1
done
echo "✅ PostgreSQL is ready."

# Fix Laravel permissions
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Optional: Laravel setup
echo "🔧 Running Laravel setup..."
php artisan config:clear
php artisan cache:clear
php artisan config:cache
php artisan migrate --force || true  # Avoid hard crash on failed migration

# Run the main container command
exec "$@"
