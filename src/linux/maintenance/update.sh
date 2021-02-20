#!/bin/sh

# This script updates all packages and reboots the system. Intended to be setup on a cron in the middle of the night

main() {
    echo "Updating Linux... the system will reboot once complete."
    update
}

update() {
    sudo apt-get update
    sudo apt-get upgrade
    sudo reboot
}

main
