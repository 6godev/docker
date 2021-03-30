FROM node:lts-alpine

WORKDIR /app

RUN apk add --update --no-cache \
  sqlite \
  openssl \
  curl

RUN apk add --update --no-cache --virtual .build-deps build-base \
  && yarn global add --prod --no-lockfile laravel-echo pusher-js \
  && apk del .build-deps \
  && yarn cache clean \
  && mkdir -p /app/database

COPY ./bin/docker-entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./bin/health-check.sh /usr/local/bin/health-check
COPY ./stubs/default.config.json /usr/local/src/laravel-echo-server.json

RUN chmod +x /usr/local/bin/docker-entrypoint

VOLUME /app
EXPOSE 6001

ENTRYPOINT ["/usr/local/bin/docker-entrypoint"]
CMD ["start"]
