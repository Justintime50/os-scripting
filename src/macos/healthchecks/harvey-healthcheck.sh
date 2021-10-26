#!/bin/bash

# Harvey Healthcheck
#
# If Harvey is not running, restart the app
# 1) Ping the app for a response, if 200, healthcheck succeeds and no action is taken
# 2) If bad ping, attempt to restart Harvey
# This script is intended be run as a cron job to ensure Harvey remains running

main() {
    if curl -X GET 192.168.1.2:5000/health 2>&1 | grep -q "Connection refused"; then
        echo "Harvey's healthcheck failed, restarting Harvey..."
        cd "$HOME/git/personal/harvey" && make prod
    else
        echo "Harvey's healthcheck passed."
    fi 
}

main
