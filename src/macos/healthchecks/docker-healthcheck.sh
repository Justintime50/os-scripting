#!/bin/bash

# Docker Healthcheck
#
# If Docker is not running or cannot be connected to, restart the Daemon (non-running Docker, restarting state, running but broken state)
# 1) Ping the daemon for a response, if 200, healthcheck succeeds and no action is taken
# 2) If bad ping, attempt to restart Docker
# This script is intended be run as a cron job to ensure Docker remains running

DOCKER_API_VERSION="1.41"

main() {
    if curl --unix-socket /var/run/docker.sock http:/v"$DOCKER_API_VERSION"/_ping 2>&1 | grep -q "Couldn't connect\|connection refused\|Bad response from Docker engine\|Something went wrong."; then
        case "$OSTYPE" in
        darwin*)
            echo "Docker's healthcheck failed, restarting Docker..." >&2
            killall -I Docker &>/dev/null
            killall -I "Docker Desktop" &>/dev/null
            killall -I com.docker.backend &>/dev/null
            sleep 10
            open /Applications/Docker.app
            ;;
        linux-gnu*)
            echo "Docker's healthcheck failed, restarting Docker..." >&2
            service docker stop &>/dev/null
            sleep 10
            service docker start
            ;;
        *)
            echo "Docker Healthcheck is not compatible with your OS." >&2
            ;;
        esac
    else
        echo "Docker's healthcheck passed."
    fi
}

main
