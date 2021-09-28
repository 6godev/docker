FROM php:7.4-fpm-alpine

ARG BUILD_DATE
ARG VCS_REF

ENV COMPOSER_ALLOW_SUPERUSER=1

# We can decide to enable or disable opcache in runtime build
# for example in development it's useful to keep this disable
ENV OPCACHE_ENABLE=1
ENV OPCACHE_VALIDATE_TIMESTAMPS=0

# xDebug mode should be set off in production
ENV XDEBUG_MODE=off
ENV XDEBUG_CLIENT_HOST=localhost
ENV XDEBUG_CLIENT_PORT=9003

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
    PHP="7.4" \
    org.label-schema.name="6go-srl/docker" \
    org.label-schema.description="Docker image for internal usage on development" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="1.1" \
    org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
    org.label-schema.vcs-ref=$VCS_REF

COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./config/php.ini "$PHP_INI_DIR"

# Install Imagick, GD, MySQL, Postgres, Redis and other necessary extensions
RUN apk add --no-cache --virtual .php-deps $PHPIZE_DEPS autoconf gcc g++ libtool make \
    && apk add --no-cache \
    freetype \
    freetype-dev \
    libpng \
    libpng-dev \
    postgresql-dev \
    libjpeg-turbo \
    libjpeg-turbo-dev \
    libzip-dev \
    git \
    gmp-dev \
    icu-dev \
    imagemagick \
    imagemagick-dev \
    mysql-client \
    oniguruma-dev \
    && pecl install imagick redis \
    && docker-php-ext-enable imagick redis \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl --enable-intl \
    && docker-php-ext-configure pdo_mysql --with-pdo-mysql \
    && docker-php-ext-configure zip opcache gmp \
    && docker-php-ext-install -j$(nproc) \
    bcmath \
    calendar \
    exif \
    gd \
    gmp \
    intl \
    mbstring \
    opcache \
    pcntl \
    pgsql \
    pdo_pgsql \
    pdo_mysql \
    zip \
    && apk del -f .php-deps

# Copy other .ini files after the installation process
COPY ./config/opcache.ini "$PHP_INI_DIR/conf.d/opcache.ini"
COPY ./config/xdebug.ini "$PHP_INI_DIR/conf.d/xdebug.ini"

# Install Composer
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
    && php composer-setup.php --install-dir=/usr/local/bin/ --filename=composer \
    && php -r "unlink('composer-setup.php');"

# Cleanup dependencies
RUN rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

# Prepare the workdir
RUN mkdir -p /var/www \
    && chown -Rf www-data:www-data /var/www

WORKDIR /var/www

CMD ["php-fpm", "--nodaemonize"]
