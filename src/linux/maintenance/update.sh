#!/bin/sh

# This script updates all packages and reboots the system

main() {
    echo "Updating Linux... the system will reboot once complete."
    update
}

update() {
    sudo apt-get update
    sudo apt-get upgrade
    sudo apt autoremove
    sudo reboot
}

main
