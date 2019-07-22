#!/bin/bash

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# Navigate to downloads
cd Downloads

# Install wget
brew install wget

# Download Chrome
wget https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg

# Open and copy Chrome
open googlechrome.dmg
sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/