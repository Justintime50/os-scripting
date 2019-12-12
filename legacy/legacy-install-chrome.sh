#!/bin/bash

# Navigate to downloads
cd Downloads || exit

# Download Chrome
wget https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg

# Open and copy Chrome
open googlechrome.dmg
sudo cp -r /Volumes/Google\ Chrome/Google\ Chrome.app /Applications/