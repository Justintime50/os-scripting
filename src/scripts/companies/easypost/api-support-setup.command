#!/bin/bash

# If running from Meraki:
# `systemsetup setremotelogin on`

# Grab the username of the non-admin
echo "Enter the username of the non-admin account: "
read -r USERNAME
echo "Enter the epadmin password: "
read -rs EPPASSWORD

# Install Brew and all Supported Programming Languages
echo "$EPPASSWORD" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
# brew install git # macOS already comes with Git installed
brew install node # installs npm as a part of this
brew install ruby
brew install php
# brew install python # PHP already installs Python3 as a dependency
brew install go
brew cask install adoptopenjdk # must come before maven, will require an admin password to install
brew install maven
brew cask install dotnet-sdk
brew cask install visual-studio-code --appdir=/Users/"$USERNAME"/Applications

# We switch the Homebrew instance ownership to the user instead of epadmin here
sudo chown -R "$USERNAME" "$(brew --prefix)"/*
chmod u+w "$(brew --prefix)"/*

# If running from Meraki:
# `systemsetup setremotelogin off`
