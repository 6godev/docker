FROM nginx:stable-alpine

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/default_headers /etc/nginx/default_headers
COPY ./templates /etc/nginx/templates

RUN mkdir -p /var/www

RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data

RUN chown -R www-data:www-data /var/www
