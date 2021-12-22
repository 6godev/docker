FROM composer:latest as composer

RUN composer -v

FROM php:8.1.0-fpm-alpine

ARG BUILD_DATE
ARG VCS_REF

ENV COMPOSER_ALLOW_SUPERUSER=1

# We can decide to enable or disable opcache in runtime build
# for example in development it's useful to keep this disable
ENV OPCACHE_ENABLE=1
ENV OPCACHE_VALIDATE_TIMESTAMPS=0
ENV OPCACHE_JIT_DEBUG=0

# xDebug mode should be set off in production
ENV XDEBUG_MODE=off
ENV XDEBUG_CLIENT_HOST=localhost
ENV XDEBUG_CLIENT_PORT=9003

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
    PHP="8.1" \
    org.label-schema.name="6go-srl/docker" \
    org.label-schema.description=" Docker image for internal usage on development" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="1.2" \
    org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
    org.label-schema.vcs-ref=$VCS_REF

# Use this handy dandy installer
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Copy other .ini files after the installation process
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./config/php.ini "$PHP_INI_DIR"
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"
COPY ./config/xdebug.ini "$PHP_INI_DIR/conf.d/xdebug.ini"

# Add composer
COPY --from=composer /usr/bin/composer/ /usr/local/bin/composer

# Install Imagick, GD, MySQL, Redis and other necessary extensions
# Compile Imagick from the source code
# Install Composer
# Prepare the workdir
# Cleanup 
RUN apk add --no-cache --virtual .php-deps ${PHPIZE_DEPS} \
    && apk add --no-cache mysql-client \
    && install-php-extensions \
    bcmath \
    calendar \
    exif \
    gd \
    imagick \
    intl \
    opcache \
    pcntl \
    pdo_mysql \
    redis \
    xdebug \
    zip \
    && mkdir -p /var/www \
    && chown -Rf www-data:www-data /var/www \
    && apk del --no-cache -f .php-deps ${PHPIZE_DEPS} \
    && rm -rf /usr/share/php /tmp/* /var/cache/apk/* \
# Sanity check
    && php -v \
    && composer

WORKDIR /var/www

CMD ["php-fpm", "--nodaemonize"]
