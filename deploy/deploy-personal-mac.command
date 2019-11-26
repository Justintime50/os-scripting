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
# brew cask install cakebrew # GUI app to manage Homebrew packages

# Install wget
brew install wget

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
echo "$PASSWORD" | sudo -S mv composer.phar /usr/local/bin/
echo "$PASSWORD" | sudo -S chmod 755 /usr/local/bin/composer.phar
echo 'alias composer="php /usr/local/bin/composer.phar"' >> ~/.zshrc
source ~/.zshrc
composer --version

# Install Laravel Globally
composer global require laravel/installer
echo "export PATH='$HOME/.composer/vendor/bin:$PATH'" >> ~/.zshrc
source ~/.zshrc

# Install Node package managers and Node
brew install npm
brew install yarn
brew install node

# Install Python3, PIP, and packages
brew install python3
echo "$PASSWORD" | sudo -S nano ~/.zshrc
echo "alias python='python3'" >> ~/.zshrc
echo "alias pip='pip3'" >> ~/.zshrc
pip install beautifulsoup4

# Install apps
brew cask install docker
brew cask install visual-studio-code
brew cask install google-chrome
brew cask install firefox
brew cask install teamviewer
brew cask install slack
brew cask install ccleaner
brew cask install funter
brew cask install filezilla
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
brew cask install tor
brew cask install virtualbox
brew cask install nrlquaker-winbox

# Check for updates and restart
echo "$PASSWORD" | sudo -S softwareupdate -i -a
} 2> ~/add_user_script.log # End error logging wrapper
open ~/add_user_script.log # Open the log and have the user check for errors before finishing
echo -e "Script complete.\nPlease check error log (automatically opened) before restarting.\n\nPress <enter> to restart."
read -rn 1
echo "Shutting down..."
sleep 5
history -c
echo "$PASSWORD" | sudo -S shutdown -h now
