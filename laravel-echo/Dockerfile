FROM node:lts-alpine

ARG BUILD_DATE

WORKDIR /usr/local/src

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
  org.label-schema.build-date=${BUILD_DATE} \
  org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
  org.label-schema.vcs-ref=${VCS_REF} \
  org.label-schema.docker.dockerfile="/Dockerfile" \
  org.label-schema.description="Laravel echo standalone server" \
  org.label-schema.schema-version="1.0"

RUN apk add --update --no-cache \
  sqlite \
  openssl \
  curl

RUN apk add --update --no-cache --virtual .build-deps build-base \
  && yarn global add --prod --no-lockfile laravel-echo-server \
  && apk del .build-deps \
  && yarn cache clean

RUN mkdir -p database

COPY ./bin/entrypoint.sh /usr/local/bin/docker-entrypoint.sh
COPY ./stubs/default.config.json /usr/local/src/laravel-echo-server.json

EXPOSE 6001

ENTRYPOINT ["docker-entrypoint"]
CMD ["start"]
