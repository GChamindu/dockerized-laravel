# Use official PHP image with extensions
FROM php:8.2-fpm

# Set working directory
WORKDIR /var/www

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    npm \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# Copy project files (from context: laravel-app/)
COPY app/ .

# Install PHP dependencies
RUN composer install --no-interaction --prefer-dist --optimize-autoloader

# Permissions (use www-data user)
RUN chown -R www-data:www-data /var/www
RUN chmod -R 755 /var/www/storage

# Expose port for FPM
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
