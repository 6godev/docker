FROM golang:alpine

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
  org.label-schema.name="6go-srl/docker" \
  org.label-schema.description=" Docker image for internal usage on development and production" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.0" \
  org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
  org.label-schema.vcs-ref=$VCS_REF

# Install MailHog:
RUN apk --no-cache add --virtual build-dependencies git \
  && mkdir -p /root/gocode \
  && export GOPATH=/root/gocode \
  && go install github.com/mailhog/MailHog@latest \
  && mv /root/gocode/bin/MailHog /usr/local/bin \
  && apk del --purge build-dependencies

# Cleanup dependencies
RUN rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && rm -rf /root/gocode \
    && rm -rf /var/cache/apk/*

# Add mailhog user/group with uid/gid 1000.
# This is a workaround for boot2docker issue #581, see
# https://github.com/boot2docker/boot2docker/issues/581
RUN adduser -D -u 1000 mailhog

USER mailhog

WORKDIR /home/mailhog

ENTRYPOINT ["MailHog"]

# Expose the SMTP and HTTP ports:
EXPOSE 1025 8025
