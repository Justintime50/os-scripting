#!/bin/bash

# Harvey Healthcheck
#
# If Harvey is not running, restart the app
# 1) Ping the app for a response, if 200, healthcheck succeeds and no action is taken
# 2) If bad ping, attempt to restart Harvey
# This script is intended be run as a cron job to ensure Harvey remains running

main() {
    if curl -X GET https://harveyapi.justinpaulhammond.com/health --max-time 10 2>&1 | grep -q "Connection refused\|timed out"; then
        echo "Harvey's healthcheck failed, restarting Harvey..."
        killall uwsgi &>/dev/null
        sleep 10
        cd "$HOME/git/personal/harvey" || exit 1
        just prod || exit 1
    else
        echo "Harvey's healthcheck passed."
    fi
}

main
