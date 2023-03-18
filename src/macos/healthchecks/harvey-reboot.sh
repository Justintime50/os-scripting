#!/bin/bash

# Harvey Reboot, intended to be used on a cron to reboot to clean up segfaults

main() {
    echo "Rebooting Harvey..."
    killall uwsgi &>/dev/null || exit 1
    sleep 5
    cd "$HOME/git/personal/harvey" || exit 1
    make prod || exit 1
}

main
