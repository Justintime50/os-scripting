#!/bin/bash

#####################################
## DEPLOY PERSONAL SERVER - JUSTIN ##
#####################################

{ # Wrap script in error logging

# Gather necessary input
echo -n "Admin Password: "
read -rs PASSWORD

# Install Command Line Tools
xcode-select --install

# Install Homebrew
echo "$PASSWORD" | sudo -S curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
brew doctor

# Install Git
brew install git
# Configure git config file
echo "[core]
	editor = nano
[user]
	name = Justintime50
	email = justinpaulhammond@gmail.com" >> ~/.gitconfig

# Install PHP
brew install php # we'll use Brew's PHP and not the built in Mac PHP

# Install apps
brew cask install smcfancontrol
brew cask install docker
brew cask install kitematic
brew cask install sublime-text
brew cask install google-chrome
brew cask install teamviewer
brew cask install ccleaner
brew cask install funter
brew cask install makemkv

# Check for updates and restart
echo "$PASSWORD" | sudo -S softwareupdate -i -a
} 2> ~/deploy_script.log # End error logging wrapper
open ~/deploy_script.log # Open the log and have the user check for errors before finishing
echo -e "Script complete.\nPlease check error log (automatically opened) before restarting\n\nNEXT STEPS: Deploy server-infra project to server for all docker containers.\n\nPress <enter> to restart."
read -rn 1
echo "Shutting down..."
sleep 5
history -c
echo "$PASSWORD" | sudo -S shutdown -h now