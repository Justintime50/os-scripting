#!/bin/bash

###########################
## DEPLOY NEW MAC SCRIPT ##
###########################

################
## Initialize ##
################
USER=`id -u -n` # explicitly assign user regardless of login or access
ADMINPASSWORD="redgrapes20" # set the password for reuse in the script

##################
## MAIN CONTENT ##
##################

# Install Command Line Tools (will require user input on pop-up window)
xcode-select --install

# Install Homebrew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew tap caskroom/cask

# Install wget
brew install wget

# Open Jamf Enrollment Page & Run DEP Enrollment Command (only one is necessary depending on how the device was purchased)
open https://9ghcfm.jamfcloud.com
sudo profiles renew -type enrollment

# Create the Nozani Admin user and explicitly add SecureToken
sudo sysadminctl -addUser admin -password $ADMINPASSWORD -fullName "Nozani Admin" -admin
sysadminctl -adminUser $USER -adminPassword - -secureTokenOn admin -password $ADMINPASSWORD

# Assign variables to initialize computer name
MODEL=`sysctl hw.model | sed 's/[0-9, ]//g' | cut -c 10-`
YEAR=`curl -s https://support-sp.apple.com/sp/product?cc=JG5J | grep -o '\d\d\d\d' | cut -c 3-`
SERIAL=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 7-`

# Change computer name
COMPUTER_NAME=$MODEL$YEAR-$SERIAL
sudo scutil --set ComputerName $COMPUTER_NAME && \
sudo scutil --set HostName $COMPUTER_NAME && \
sudo scutil --set LocalHostName $COMPUTER_NAME && \
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
dscacheutil -flushcache # flush the DNS cache for good measure

# Turn on Firewall (will require a restart before it shows on)
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable Remote Management (will require additional configuration through System Preferences for Mojave 10.14 and higher)
sudo systemsetup -setremotelogin on
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# Install Google Chrome
brew cask install google-chrome

#############
## CLEANUP ##
#############

# Force a password reset on the *current* user upon login
pwpolicy -a $USER -u $USER -setpolicy "newPasswordRequired=1"

# Clear Bash history after running this script
history -c

# Check for updates
sudo softwareupdate -l -i -a
