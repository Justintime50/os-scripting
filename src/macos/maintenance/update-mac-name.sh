#!/bin/bash

# Update the Mac's name throughout the system.
# Usage: ./update-mac-name.sh "My New Computer Name"

main() {
    NEW_COMPUTER_NAME="$1"

    sudo scutil --set ComputerName "$NEW_COMPUTER_NAME"
    sudo scutil --set HostName "$NEW_COMPUTER_NAME"
    sudo scutil --set LocalHostName "$NEW_COMPUTER_NAME"

    dscacheutil -flushcache

    echo -e "Script complete.\n\nPress <enter> to restart for changes to take effect."
    read -rn 1
    sudo -S shutdown -h now
}

main "$1"
