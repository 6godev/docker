FROM php:7.4-fpm-alpine

ARG APP_ENV
ARG GITHUB_AUTH_TOKEN

ENV COMPOSER_ALLOW_SUPERUSER 1

COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/php.ini /usr/local/etc/php
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"

RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data

# Install Imagick, GD, MySQL, Redis and other necessary extensions
RUN apk add --no-cache --virtual .php-deps $PHPIZE_DEPS \
    && apk add --no-cache \
       freetype \
       freetype-dev \
       libtool \
       libpng \
       libpng-dev \
       libjpeg-turbo \
       libjpeg-turbo-dev \
       libzip-dev \
       git \
       icu-dev \
       imagemagick-dev \
       mysql-client \
       oniguruma-dev \
    && pecl install imagick redis \
    && docker-php-ext-enable imagick redis \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure zip \
    && docker-php-ext-install \
       bcmath \
       calendar \
       exif \
       gd \
       mbstring \
       opcache \
       pcntl \
       pdo \
       pdo_mysql \
       zip \
    && apk del -f .php-deps

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');"

# If requested we can install xDebug
RUN if [ ! "production" == "$APP_ENV" ] && [ ! "prod" == "$APP_ENV" ]; \
    then apk add --no-cache --virtual .php-deps $PHPIZE_DEPS \
         && pecl install xdebug \
         && docker-php-ext-enable xdebug \
         && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
         && echo "xdebug.remote_host = host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
         && apk del -f .php-deps ; \
    fi

# You can set a Github oauth token here
RUN if [[ -n "$GITHUB_AUTH_TOKEN" ]] ; \
    then composer config --global --auth github-oauth.github.com $GITHUB_AUTH_TOKEN ; \
    fi

# Cleanup dependencies
RUN rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

# Prepare the workdir
RUN mkdir -p /var/www \
    && chown -R www-data:www-data /var/www

WORKDIR /var/www
