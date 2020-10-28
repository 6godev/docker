FROM nginx:stable-alpine

COPY ./etc/nginx.conf /etc/nginx/nginx.conf
COPY ./etc/default_headers /etc/nginx/default_headers

RUN mkdir -p /var/www

RUN adduser -u 1000 -S -D -G www-data www-data

RUN chown -R www-data:www-data /var/www
