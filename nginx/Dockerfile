FROM nginx:stable-alpine

COPY ./etc/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/default_headers /etc/nginx/default_headers

RUN mkdir -p /var/www

RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data

RUN chown -R www-data:www-data /var/www
