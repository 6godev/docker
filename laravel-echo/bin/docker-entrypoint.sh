#!/bin/sh
set -e

# laravel-echo-server init
if [[ "$1" == 'init' ]]; then
    set -- laravel-echo-server "$@"
fi

if [ "$1" == 'start' ] && [ -f '/app/laravel-echo-server.lock' ]; then
    rm /app/laravel-echo-server.lock
fi

# laravel-echo-server <sub-command>
if [[ "$1" == 'start' ]] || [[ "$1" == 'client:add' ]] || [[ "$1" == 'client:remove' ]]; then
    if [[ "${LARAVEL_ECHO_SERVER_GENERATE_CONFIG:-true}" == "false" ]]; then
        # wait for another process to inject the config
        echo -n "Waiting for /app/laravel-echo-server.json"
        while [[ ! -f /app/laravel-echo-server.json ]]; do
            sleep 2
            echo -n "."
        done
    elif [[ ! -f /app/laravel-echo-server.json ]]; then
        cp /usr/local/src/laravel-echo-server.json /app/laravel-echo-server.json
        # Replace with environment variables
        sed -i "s|LARAVEL_ECHO_SERVER_DB|${LARAVEL_ECHO_SERVER_DB:-redis}|i" /app/laravel-echo-server.json
        sed -i "s|REDIS_HOST|${REDIS_HOST:-redis}|i" /app/laravel-echo-server.json
        sed -i "s|REDIS_PORT|${REDIS_PORT:-6379}|i" /app/laravel-echo-server.json
        sed -i "s|REDIS_PASSWORD|${REDIS_PASSWORD}|i" /app/laravel-echo-server.json
        sed -i "s|REDIS_PREFIX|${REDIS_PREFIX:-laravel_database_}|i" /app/laravel-echo-server.json
        sed -i "s|REDIS_DB|${REDIS_DB:-0}|i" /app/laravel-echo-server.json
        # Remove password config if it is empty
        sed -i "s|\"password\": \"\",||i" /app/laravel-echo-server.json
    fi
    set -- laravel-echo-server "$@"
fi

# first arg is `-f` or `--some-option`
if [[ "${1#-}" != "$1" ]]; then
	set -- laravel-echo-server "$@"
fi

exec "$@"
