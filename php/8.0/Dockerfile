FROM php:8.0-fpm-alpine3.15

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
    PHP="8.0" \
    org.label-schema.name="6go-srl/docker" \
    org.label-schema.description=" Docker image for internal usage on development" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="1.2" \
    org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
    org.label-schema.vcs-ref=$VCS_REF

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

# dependencies required for running "phpize"
# these get automatically installed and removed by "docker-php-ext-*" (unless they're already installed)
ENV PHPIZE_DEPS \
    autoconf \
    dpkg-dev \
    dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    re2c \
    wget

RUN set -eux; \
# Install Dependencies
    apk add --no-cache --virtual .build-deps $PHPIZE_DEPS \
    curl \
    fcgi \
    freetype-dev \
    git \
    icu-dev \
    imagemagick \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libmcrypt-dev \
    libpng \
    libpng-dev \
    libtool \
    libwebp-dev \
    libxml2-dev \
    libzip-dev \
    mysql-client \
    oniguruma-dev \
    unzip \
# Install pecl packages
    && pecl install -o -f imagick xdebug redis \
# install imagick
# use github version for now until release from https://pecl.php.net/get/imagick is ready for PHP 8
# ref: https://github.com/Imagick/imagick/issues/358
    && mkdir -p /usr/src/php/ext/imagick \
    && curl -fsSL https://github.com/Imagick/imagick/archive/06116aa24b76edaf6b1693198f79e6c295eda8a9.tar.gz | tar xvz -C "/usr/src/php/ext/imagick" --strip 1 \
# Configure PHP extensions
    && docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure zip \
    && docker-php-ext-configure opcache \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    calendar \
    exif \
    gd \
    intl \
    mbstring \
    opcache \
    pcntl \
    pdo_mysql \
    zip \
    && docker-php-ext-enable imagick xdebug redis \
# Install Composer
    && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');" \
# Cleanup
    && mkdir -p /var/www \
    && chown -Rf www-data:www-data /var/www \
    && apk del -f .php-deps \
    && rm -rf /usr/share/php /tmp/* /var/cache/apk/*

# https://github.com/docker-library/php/issues/1121
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Copy other .ini files after the installation process
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./config/php.ini "$PHP_INI_DIR"
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"
COPY ./config/xdebug.ini "$PHP_INI_DIR/conf.d/xdebug.ini"

# Sanity check
RUN php -v

WORKDIR /var/www

CMD ["php-fpm", "--nodaemonize"]
