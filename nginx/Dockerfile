FROM nginx:1.19-alpine

ENV TEMPLATE=php-socket.conf.template

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
  NGINX="1.19" \
  org.label-schema.name="6go-srl/docker" \
  org.label-schema.description=" Docker image for internal usage on development" \
  org.label-schema.build-date=$BUILD_DATE \
  org.label-schema.schema-version="1.1" \
  org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
  org.label-schema.vcs-ref=$VCS_REF

RUN mkdir -p /var/www \
  && mkdir -p /var/cache/nginx \
  && mkdir -p /etc/nginx/templates \
  && mkdir -p /etc/nginx/available-templates

COPY ./config/ /etc/nginx/
COPY ./templates /etc/nginx/available-templates

# User can opt-in on a template during container build
RUN cp /etc/nginx/available-templates/$TEMPLATE /etc/nginx/templates/default.conf.template

RUN touch /var/run/nginx.pid \
  && chmod -R g+w /var/cache/nginx \
  /etc/nginx

STOPSIGNAL SIGQUIT
