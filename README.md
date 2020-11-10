[![pipeline status](https://gitlab.com/6go-srl/docker/badges/master/pipeline.svg)](https://gitlab.com/6go-srl/docker/-/commits/master)

# Docker

This repository contains all the docker images used by us internally.

## What's included

We are updating this repository to include every custom container we can release to the public in a secure way.
Below you will find a list of software, and their tags.

### Ansible

This container is primarly used to spawn control node on the fly in order to provision machines using
our [playbooks](https://gitlab.com/6go-srl/ansible) generally speaking you should provide a list of playbooks
and a host file to this image in order to use it.

Example of a `docker-compose.yml` container, assuming you have a hosts file and a playbooks on the same directory:

```YML
ansible:
  image: registry.gitlab.com/6go-srl/docker/ansible:2.10.1
  container_name: ansible
  restart: unless-stopped
  volumes:
    - ./hosts:/etc/ansible/hosts:ro
    - ./playbooks:/ansible/playbooks:ro
```

This container is a work in progress so it will be updated frequently

### MailHog

Mailhog is a SMTP mail catcher for developers, inspired by MailCatcher, easier to install.
You can check the repository [here](https://github.com/mailhog/MailHog).

The beauty of this mail catcher is that is a zero-config container so you can have a `docker-compose.yml` like this:

```yml
mail:
  image: registry.gitlab.com/6go-srl/docker/mailhog:latest
  container_name: mail
  restart: unless-stopped
  ports:
    - "8025:8025"
    - "1025:1025"
  networks:
    - customnet
```

As long as the other services are inside *custonet* you will automatically catch any email that goes to this host.

### NGINX

Nginx, stylized as NGINX or nginx or NginX, is a web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.
This container will create a full NGINX server and excepts to be conneted to a PHP-FPM powered container, in the future more template will be provided
for now we need only a PHP-FPM related conf.

When using this image you **must** pass some variables in order to generate the `default.conf` file, here an example:

```yml
  nginx:
    image: registry.gitlab.com/6go-srl/docker/nginx:latest
    container_name: nginx
    restart: on-failure
    environment:
      PORT: 80
      SERVER_NAME: web.app
      PHP_CONTAINER_NAME: php
      PHP_CONTAINER_PORT: 9000
      ROOT: /var/www/public/
    ports:
      - "80:80"
    volumes:
      - /path/to/source/code:/var/www/:ro
    networks:
      - customnet
```

The current template provided doesn't support HTTPS because it was designed for development purposes only. If you need HTTPS you should build a custom
image based on this and slap inside everything needed for HTTPS like certbot.


### PHP

Here you will find different folders for different versions of PHP starting from `v7.4.x`. You can specify the php version during image pulling.
A simple `docker-compose.yml` could look like this:

```yml
  php:
    image: registry.gitlab.com/6go-srl/docker/php:7.4
    container_name: php
    restart: always
    environment:
      APP_ENV: ${APP_ENV}
      CONTAINER_ROLE: development|production|scheduler|queue
    volumes:
      - /path/to/source/code:/var/www:delegated
    ports:
      - "9000:9000"
    networks:
      - customnet
```

This container should be in the same newtork as MailHog and NGINX if you plan to use them together!
