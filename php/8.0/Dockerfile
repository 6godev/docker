FROM php:8.0-fpm-bullseye

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
    PHP="8.0" \
    org.label-schema.name="6go-srl/docker" \
    org.label-schema.description=" Docker image for internal usage on development" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="2.0" \
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

# Main RUN trunk for installing everything needed
RUN set -eux; \
    apt-get update \
    && apt-get install -y --no-install-recommends $PHPIZE_DEPS \
    git \
    imagemagick \
    libapache2-mod-fcgid \
    libfreetype6-dev \    
    libicu-dev \
    libjpeg-dev \
    libmagickwand-dev \
    libmcrypt-dev \
    libpng-dev \
    libonig-dev \
    libtool \
    libwebp-dev \
    libxml2-dev \
    libzip-dev \
    unzip \
# Install PHP Extensions
    && pecl install -f imagick xdebug redis \
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
    && mkdir -p /var/www \
    && chown -Rf www-data:www-data /var/www \
# Cleanup
    && apt-get remove -y $BUILD_PACKAGES $PHPIZE_DEPS \
    && apt autoremove -y \
    && apt-get autoclean -y \
    && rm -rf /usr/share/php /tmp/* /var/cache/apt/*
# Sanity check
    && php -v && composer -v

# Get latest Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy other .ini files after the installation process
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./config/php.ini "$PHP_INI_DIR"
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"
COPY ./config/xdebug.ini "$PHP_INI_DIR/conf.d/xdebug.ini"

WORKDIR /var/www

CMD ["php-fpm", "--nodaemonize"]
