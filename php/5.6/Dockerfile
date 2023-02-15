FROM composer:2.2 as COMPOSER

RUN composer -v

FROM php:5.6-cli-alpine as EXTENSION_INSTALLER

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions

FROM php:5.6-fpm-alpine

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
    PHP="5.6" \
    org.label-schema.name="6go-srl/docker" \
    org.label-schema.description="Docker image for internal usage on development" \
    org.label-schema.build-date=$BUILD_DATE \
    org.label-schema.schema-version="1.0" \
    org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
    org.label-schema.vcs-ref=$VCS_REF

ARG BUILD_DATE
ARG VCS_REF

ENV COMPOSER_ALLOW_SUPERUSER=1

# xDebug mode should be set off in production
ENV XDEBUG_MODE=off
ENV XDEBUG_CLIENT_HOST=localhost
ENV XDEBUG_CLIENT_PORT=9003

# Copy other .ini files after the installation process
COPY ./conf/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./conf/zz-docker.conf /usr/local/etc/php-fpm.d/zz-docker.conf
COPY ./ini/xdebug.ini "$PHP_INI_DIR/conf.d/xdebug.ini"

# Add composer
COPY --from=COMPOSER /usr/bin/composer/ /usr/local/bin/composer

# Add installer
COPY --from=EXTENSION_INSTALLER /usr/local/bin/install-php-extensions /usr/local/bin/install-php-extensions

# Install Imagick, GD, MySQL, Redis and other necessary extensions
# Prepare the workdir
# Cleanup 
RUN apk add --no-cache git \
    && IPE_GD_WITHOUTAVIF=1 install-php-extensions \
    bcmath \
    calendar \
    exif \
    gd \
    imagick \
    intl \
    mbstring \
    mysql \
    mysqli \
    opcache \
    pcntl \
    pdo_mysql \
    redis \
    xdebug \
    zip \
    && mkdir -p /var/www \
    && chown -Rf www-data:www-data /var/www \
    && rm -rf /usr/share/php /tmp/* /var/cache/apk/* \
# Sanity check
    && php -v \
    && composer


WORKDIR /var/www

CMD ["php-fpm", "--nodaemonize"]
