FROM nginx:stable-alpine

COPY ./config/nginx.conf /etc/nginx/nginx.conf
COPY ./config/default_headers /etc/nginx/default_headers
COPY ./templates /etc/nginx/templates

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
  NGINX="1.19" \
  org.label-schema.name="6go-srl/docker" \
  org.label-schema.description=" Docker image for internal usage on development and production" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
  org.label-schema.vcs-ref=$VCS_REF

RUN mkdir -p /var/www

RUN adduser -D -H -u 1000 -s /bin/bash www-data -G www-data

RUN chown -R www-data:www-data /var/www
