
FROM alpine:3.12

ARG BUILD_DATE
ARG VCS_REF

# Metadata
LABEL maintainer="Pascal A. <pascalito@gmail.com>" \
      org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.docker.dockerfile="/Dockerfile" \
      org.label-schema.description="Ansible on alpine docker image" \
      org.label-schema.schema-version="1.0"

RUN apk --update --no-cache add \
        ca-certificates \
        git \
        openssh-client \
        openssl \
        python3\
        rsync \
        sshpass

RUN apk --update add --virtual \
        .build-deps \
        python3-dev \
        py3-pip \
        libffi-dev \
        openssl-dev \
        build-base \
        curl \
    && curl -s -L https://networkgenomics.com/try/mitogen-0.2.9.tar.gz | tar xzf - -C /opt/ \
    && mv /opt/mitogen-* /opt/mitogen \
    && pip3 install --upgrade \
        pip \
        cffi \
    && pip3 install \
        ansible \
        ansible-lint \
    && apk del .build-deps

# Cleanup dependencies
RUN rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && rm -rf /var/cache/apk/*

RUN mkdir -p /etc/ansible \
 && echo '[servers]' > /etc/ansible/hosts \
 && echo -e """\
\n\
Host *\n\
    StrictHostKeyChecking no\n\
    UserKnownHostsFile=/dev/null\n\
""" >> /etc/ssh/ssh_config

COPY entrypoint /usr/local/bin/

WORKDIR /ansible

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
