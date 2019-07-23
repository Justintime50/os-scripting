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
sudo dscl . -create /Users/admin # swap admin for the one-word admin of the user
sudo dscl . -create /Users/admin UserShell /bin/bash # sets the default shell
sudo dscl . -create /Users/admin RealName "NAME HERE" # swap the name in quotes for the user's real name
sudo dscl . -create /Users/admin UniqueID 1001 # give the user a unique ID not used by another user
sudo dscl . -create /Users/admin PrimaryGroupID 20 # assign the group id to the user - 20 is staff, 80 is administrator. 20 is default
sudo dscl . -create /Users/admin NFSHomeDirectory /Users/admin # creates a home folder, swap admin for the real admin, won't be created until first login
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