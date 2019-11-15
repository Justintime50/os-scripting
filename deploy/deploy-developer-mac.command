#!/bin/bash

#################################
## DEPLOY DEVELOPER MAC SCRIPT ##
#################################

# Install Command Line Tools
xcode-select --install

# Install Homebrew
curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
brew doctor
# brew cask install cakebrew # GUI app to manage Homebrew packages

# Install Composer for PHP package management
brew install php # we'll use Brew's PHP and not the built in Mac PHP
curl -sS https://getcomposer.org/installer | php
echo $PASSWORD | sudo -S mv composer.phar /usr/local/bin/
echo $PASSWORD | sudo -S chmod 755 /usr/local/bin/composer.phar
echo 'alias composer="php /usr/local/bin/composer.phar"' >> ~/.zshrc
source ~/.zshrc
composer --version

# Install other items
brew install npm
brew install yarn
brew install node
brew install python3
brew install git
brew cask install docker
brew cask install visual-studio-code
brew cask install google-chrome

# Clear Bash history from this script
history -c

# Check for updates
sudo softwareupdate -l -i -a
