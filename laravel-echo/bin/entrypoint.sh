#!/bin/sh
set -e

# laravel-echo-server init
if [[ "$1" == 'init' ]]; then
    set -- laravel-echo-server "$@"
fi

if [ "$1" == 'start' ] && [ -f '/usr/local/src/laravel-echo-server.lock' ]; then
    echo "Remove lock file"
    rm /usr/local/src/laravel-echo-server.lock
fi

# laravel-echo-server <sub-command>
if [[ "$1" == 'start' ]] || [[ "$1" == 'client:add' ]] || [[ "$1" == 'client:remove' ]]; then
    if [[ "${LARAVEL_ECHO_SERVER_GENERATE_CONFIG:-true}" == "false" ]]; then
        # wait for another process to inject the config
        echo -n "Waiting for /usr/local/src/laravel-echo-server.json"
        while [[ ! -f /usr/local/src/laravel-echo-server.json ]]; do
            sleep 2
            echo -n "."
        done
    else
        # Replace with environment variables
        echo "Replace with environment variables"
        sed -i "s|LARAVEL_ECHO_SERVER_DB|${LARAVEL_ECHO_SERVER_DB:-redis}|i" /usr/local/src/laravel-echo-server.json
        sed -i "s|REDIS_HOST|${REDIS_HOST:-redis}|i" /usr/local/src/laravel-echo-server.json
        sed -i "s|REDIS_PORT|${REDIS_PORT:-6379}|i" /usr/local/src/laravel-echo-server.json
        sed -i "s|REDIS_PASSWORD|${REDIS_PASSWORD}|i" /usr/local/src/laravel-echo-server.json
        sed -i "s|REDIS_PREFIX|${REDIS_PREFIX:-laravel_database_}|i" /usr/local/src/laravel-echo-server.json
        sed -i "s|REDIS_DB|${REDIS_DB:-0}|i" /usr/local/src/laravel-echo-server.json
        # Remove password config if it is empty
        sed -i "s|\"password\": \"\",||i" /usr/local/src/laravel-echo-server.json
    fi
    set -- laravel-echo-server "$@"
fi

# first arg is `-f` or `--some-option`
if [[ "${1#-}" != "$1" ]]; then
	set -- laravel-echo-server "$@"
fi

exec "$@"
