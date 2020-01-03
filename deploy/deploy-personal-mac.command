#!/bin/bash

##################################
## DEPLOY PERSONAL MAC - JUSTIN ##
##################################

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

# Install PHP & Composer for PHP package management
brew install php # we'll use Brew's PHP and not the built in Mac PHP
curl -sS https://getcomposer.org/installer | php
echo "$PASSWORD" | sudo -S mv composer.phar composer
echo "$PASSWORD" | sudo -S mv composer /usr/local/bin/
echo "$PASSWORD" | sudo -S chmod 755 /usr/local/bin/composer

# Install Laravel Globally
composer global require laravel/installer
echo "$HOME/.composer/vendor/bin'" >> ~/etc/paths

# Install Node package managers and Node
brew install npm
brew install yarn
# brew install node # Already installed as an npm dependency

# Install Python3, PIP, and packages
# brew install python3 # Already installed as a PHP dependency
pip3 install beautifulsoup4

# Install apps
brew cask install docker
brew cask install kitematic
brew cask install visual-studio-code
brew cask install google-chrome
brew cask install firefox
brew cask install teamviewer
brew cask install slack
brew cask install ccleaner
brew cask install funter
brew cask install mamp
brew cask install steam
brew cask install 1password
brew cask install rocket-chat
brew cask install gimp
brew cask install nextcloud
brew cask install anytrans
brew cask install discord
brew cask install ibackup-viewer
brew cask install microsoft-word
brew cask install microsoft-excel
brew cask install microsoft-powerpoint
brew cask install minecraft
brew cask install mysqlworkbench
brew cask install origin
brew cask install battle-net
brew cask install tor-browser
brew cask install nrlquaker-winbox
brew cask install aerial
brew cask install postman
brew cask install virtualbox # Troubled installer, requires password and permissions on Catalina

# Check for updates and restart
echo "$PASSWORD" | sudo -S softwareupdate -i -a
} 2> ~/deploy_script.log # End error logging wrapper
open ~/deploy_script.log # Open the log and have the user check for errors before finishing
echo -e "Script complete.\nPlease check error log (automatically opened) before restarting.\n\nPress <enter> to restart."
read -rn 1
echo "Shutting down..."
sleep 5
history -c
echo "$PASSWORD" | sudo -S shutdown -h now
