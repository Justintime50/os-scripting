#!/bin/bash

# Install Command Line Tools
xcode-select --install

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew update
brew tap caskroom/cask

# Install wget
brew install wget

# Create admin user
sudo dscl . -create /Users/admin # swap username for the one-word username of the user
sudo dscl . -create /Users/admin UserShell /bin/bash 
sudo dscl . -create /Users/admin RealName # swap RealName for the user's real name
sudo dscl . -create /Users/admin UniqueID 3000 # give the user a unique ID not used by another user
sudo dscl . -create /Users/admin PrimaryGroupID 1000 # swap username for the one-word username of the user
sudo dscl . -create /Users/admin NFSHomeDirectory /Local/Users/admin # creates a home folder, swap username for the real username
sudo dscl . -passwd /Users/admin redgrapes20 # swap password for the users password
sudo dscl . -append /Groups/admin GroupMembership admin # This gives the new user administrative privileges. To make the new account a limited user account, skip this step.

# Turn on Firewall (will require a restart before it shows on)
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable Remote Management (will require additional configuration through System Preferences)
sudo systemsetup -setremotelogin on
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# Install Google Chrome
brew cask install google-chrome

# Check for Updates
sudo softwareupdate -l -i -a