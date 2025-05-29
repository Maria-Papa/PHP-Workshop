FROM php:8.2-fpm-alpine

# Install system dependencies and PHP extensions
RUN apk add --no-cache \
        bash \
        git \
        unzip \
        libzip-dev \
        icu-dev \
        oniguruma-dev \
        libpq-dev \
        netcat-openbsd \
        postgresql-client \
        autoconf \
        g++ \
        make \
        openssl-dev

# Install PHP extensions
RUN docker-php-ext-install \
        pdo \
        pdo_pgsql \
        pdo_mysql \
        zip \
        intl

# Install PHP Redis extension
RUN pecl install redis \
    && docker-php-ext-enable redis

# Install MongoDB extension via PECL
RUN pecl install mongodb \
    && docker-php-ext-enable mongodb

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files (This will be overridden by volume mounting in dev)
COPY ../src /var/www/html

# Copy custom entrypoint script
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# Set ownership (optional)
RUN chown -R www-data:www-data /var/www/html

# Expose PHP-FPM port
EXPOSE 9000

# Use entrypoint for permissions
ENTRYPOINT ["entrypoint.sh"]

# Start php-fpm
CMD ["php-fpm"]
