FROM php:8.2-fpm

 #Install system dependencies
RUN apt update && apt install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Clear cache
RUN apt clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Node.js version
ARG NODE_VERSION=20

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    apt install -y nodejs

# Check Node.js and NPM installation
RUN node --version && npm --version

# Get lastest Composer
COPY --from=composer:latest /usr/bin/composer /user/bin/composer

# Set working directory
WORKDIR /var/www

# Copy existing application directory contents

COPY . /var/www

# Copy existing application directory permissions

COPY --chown=www-data:www-data . /var/www

# Expose port 9000 and start php-fpm server

EXPOSE 9000

CMD ["php-fpm"]
