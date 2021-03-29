FROM node:lts-alpine

WORKDIR /usr/local/src

RUN apk add --update --no-cache \
  sqlite \
  openssl \
  curl

RUN apk add --update --no-cache --virtual .build-deps build-base \
  && yarn global add --prod --no-lockfile laravel-echo-server \
  && apk del .build-deps \
  && yarn cache clean

RUN mkdir -p database

COPY ./bin/entrypoint.sh /usr/local/bin/docker-entrypoint
COPY ./stubs/default.config.json /usr/local/src/laravel-echo-server.json

EXPOSE 6001

ENTRYPOINT ["docker-entrypoint"]
CMD ["start"]
