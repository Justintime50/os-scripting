#!/bin/bash

# Update the Mac's name throughout the system.
# Usage: ./update-mac-name.sh "My New Computer Name"

main() {
    NEW_COMPUTER_NAME="$1"

    sudo scutil --set ComputerName "$NEW_COMPUTER_NAME" && \
    sudo scutil --set HostName "$NEW_COMPUTER_NAME" && \
    sudo scutil --set LocalHostName "$NEW_COMPUTER_NAME" && \
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$NEW_COMPUTER_NAME"
    
    dscacheutil -flushcache # flush the DNS cache for good measure
}

main "$1"
