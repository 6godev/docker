FROM alpine:3.12

ARG ANSIBLE_VERSION=2.10.7
ARG ANSIBLE_LINT_VERSION=4.3.5
ARG BUILD_DATE
ARG MITOGEN_VERSION=0.2.9
ARG VCS_REF

LABEL maintainer="6GO S.r.l. <opensource@6go.it>" \
    org.label-schema.build-date=${BUILD_DATE} \
    org.label-schema.vcs-url="https://gitlab.com/6go-srl/docker" \
    org.label-schema.vcs-ref=${VCS_REF} \
    org.label-schema.docker.dockerfile="/Dockerfile" \
    org.label-schema.description="Ansible on alpine docker image" \
    org.label-schema.schema-version=${ANSIBLE_VERSION}

RUN apk --update --no-cache add \
    ca-certificates \
    git \
    gcc \
    openssh-client \
    openssl \
    python3\
    py3-pip \
    rsync \
    sshpass \
    make \
    python3-dev \
    musl-dev \
    libffi-dev \
    openssl-dev \
    build-base \
    curl \
    rust \
    cargo

RUN pip install --upgrade pip \
    && curl -s -L https://networkgenomics.com/try/mitogen-{$MITOGEN_VERSION}.tar.gz | tar xzf - -C /opt/ \
    && mv /opt/mitogen-* /opt/mitogen \
    pip \
    cffi \
    && pip3 install \
    ansible==${ANSIBLE_VERSION} \
    ansible-lint==${ANSIBLE_LINT_VERSION}

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

WORKDIR /ansible

# default command: display Ansible version
CMD [ "ansible-playbook", "--version" ]
