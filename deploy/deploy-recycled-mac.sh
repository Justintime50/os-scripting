#!/bin/bash

# Install Command Line Tools
xcode-select --install

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew tap caskroom/cask

# Install wget
brew install wget

# Turn on Firewall (will require a restart before it shows on)
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable Remote Management (will require additional configuration through System Preferences)
sudo systemsetup -setremotelogin on
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# Install Google Chrome
brew cask install google-chrome

# Check for Updates
sudo softwareupdate -l -i -a