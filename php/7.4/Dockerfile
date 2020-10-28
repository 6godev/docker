FROM php:7.4-fpm-alpine

ARG APP_ENV
ARG BUILD_DATE
ARG VCS_REF
ARG GITHUB_AUTH_TOKEN

ENV COMPOSER_ALLOW_SUPERUSER 1

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
  PHP="7.4" \
  org.label-schema.name="6go-srl/docker" \
  org.label-schema.description=" Docker image for internal usage on development and production" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
  org.label-schema.vcs-ref=$VCS_REF

COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/php.ini /usr/local/etc/php
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"

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
       intl \
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
