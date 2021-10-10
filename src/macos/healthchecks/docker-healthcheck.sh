#!/bin/bash

# Docker Healthcheck
#
# If Docker is not running, restart the Daemon
# 1) Ping the daemon for a response, if 200, healthcheck succeeds and no action is taken
# 2) If bad ping, attempt to restart Docker
# This script is intended be run as a cron job to ensure Docker remains running

main() {
    if curl --unix-socket /var/run/docker.sock http:/v1.24/containers/json 2>&1 | grep -q "Couldn't connect"; then
        case "$OSTYPE" in
            darwin*)
                open /Applications/Docker.app
                echo "Docker's healthcheck failed, restarting Docker..." >&2
            ;;
            linux-gnu*)
                sudo service docker start
                echo "Docker's healthcheck failed, restarting Docker..." >&2
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
