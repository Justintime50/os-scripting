#!/bin/bash

###########################
## DEPLOY DEV MAC SCRIPT ##
###########################

####################
## INITIALIZATION ##
# Install Command Line Tools
xcode-select --install

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew tap caskroom/cask
brew tap homebrew/cask-versions
# brew cask install cakebrew # GUI app to manage Homebrew packages

# Install wget
brew install wget

####################################
## PACKAGE MANAGERS AND LANGUAGES ##
# Install Composer for PHP package management
brew install php # we'll use Brew's PHP and not the built in Mac PHP
curl -sS https://getcomposer.org/installer | php
echo $PASSWORD | sudo -S mv composer.phar /usr/local/bin/
echo $PASSWORD | sudo -S chmod 755 /usr/local/bin/composer.phar
echo 'alias composer="php /usr/local/bin/composer.phar"' >> ~/.zshrc
source ~/.zshrc
composer --version

# Install Node package managers and Node
brew install npm
brew install yarn
brew install node

# Install Python3 and PIP
brew install python3
# brew unlink python && brew link python # Used if linking does not work properly during install

######################
## UTILITIES & APPS ##
# Install Git
brew install git

# Install Docker
brew cask install docker

# Install Visual Studio Code
brew cask install visual-studio-code

# Install Google Chrome
brew cask install google-chrome

#############
## CLEANUP ##
# Clear Bash history from this script
history -c

# Check for updates
sudo softwareupdate -l -i -a
