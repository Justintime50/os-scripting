#!/bin/bash

export MY_NAME="NAME HERE"
sudo scutil --set ComputerName "$MY_NAME" && \
sudo scutil --set HostName "$MY_NAME" && \
sudo scutil --set LocalHostName "$MY_NAME" && \
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$MY_NAME"
dscacheutil -flushcache # flush the DNS cache for good measure