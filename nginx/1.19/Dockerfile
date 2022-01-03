FROM nginx:1.19-alpine

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
  NGINX="1.19" \
  org.label-schema.name="6go-srl/docker" \
  org.label-schema.description=" Docker image for internal usage on development" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.3" \
  org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
  org.label-schema.vcs-ref=$VCS_REF

COPY ./config/ /etc/nginx/
COPY ./templates /etc/nginx/available-templates

RUN apk add --no-cache  openssl \
  && mkdir -p /var/www \
  && mkdir -p /var/cache/nginx \
  && mkdir -p /etc/nginx/templates \
  && mkdir -p /etc/ssl/certs \
  && mkdir -p /etc/letsencrypt \
  && mkdir -p /etc/nginx/available-templates \
  && touch /var/run/nginx.pid \
  && chmod -R g+w /var/cache/nginx \
  /etc/nginx \
  && openssl dhparam -out /etc/letsencrypt/ssl-dhparams.pem 4096 \
  && rm -rf /var/cache/apk/*

