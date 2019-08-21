#!/bin/bash

###########################
## DEPLOY NEW MAC SCRIPT ##
###########################

################
## INITIALIZE ##
################
echo -e "Nozani macOS deploy script started...\n"
USER=`id -u -n` # explicitly assign user regardless of login or access
echo -n "Current User's Password: "
read -s PASSWORD
echo ""
echo -n "Nozani Admin's Password (found in 1Password): "
read -s ADMINPASSWORD
echo ""

##################
## MAIN CONTENT ##
##################

# Install Command Line Tools (will require user input on pop-up window)
echo "Initializing tools, please acknowledge pop-up windows..."
xcode-select --install

# Install Homebrew
echo $PASSWORD | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew doctor
brew tap caskroom/cask

# Open Jamf Enrollment Page & Run DEP Enrollment Command (only one is necessary depending on how the device was purchased)
open https://9ghcfm.jamfcloud.com
echo $PASSWORD | sudo -S profiles renew -type enrollment
echo -e "\nNOTE: Use the Open Enrollment webpage if macs were NOT bought from Apple or Best Buy. Otherwise, check Profiles under System Preferences to verify this Mac has been enrolled.\n"

# Ensure the mac has been enrolled before proceeding
echo "Press <return> once this Mac has been enrolled in Jamf:"
read -n 1 -s

# Create the Nozani Admin user and explicitly add SecureToken
echo "Creating Nozani Admin user..."
echo $PASSWORD | sudo -S sysadminctl -addUser admin -password $ADMINPASSWORD -fullName "Nozani Admin" -admin

# Assign variables to initialize computer name
MODEL=`sysctl hw.model | sed 's/[0-9, ]//g' | cut -c 10-`
YEAR=`curl -s https://support-sp.apple.com/sp/product?cc=JG5J | grep -o '\d\d\d\d' | cut -c 3-`
SERIAL=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 7-`

# Change computer name
echo "Updating computer name..."
COMPUTER_NAME=$MODEL$YEAR-$SERIAL
echo $PASSWORD | sudo -S scutil --set ComputerName $COMPUTER_NAME && \
echo $PASSWORD | sudo -S scutil --set HostName $COMPUTER_NAME && \
echo $PASSWORD | sudo -S scutil --set LocalHostName $COMPUTER_NAME && \
echo $PASSWORD | sudo -S defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string $COMPUTER_NAME
dscacheutil -flushcache # flush the DNS cache for good measure

# Turn on Firewall (will require a restart before it shows on)
echo "Turning on firewall..."
echo $PASSWORD | sudo -S defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable Remote Management (will require additional configuration through System Preferences for Mojave 10.14 and higher)
echo "Turning on remote management & login..."
echo $PASSWORD | sudo -S systemsetup -setremotelogin on
echo $PASSWORD | sudo -S /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# Install Google Chrome
echo "Installing apps..."
brew cask install google-chrome

#############
## CLEANUP ##
#############

# Force a password reset on the *current* user upon login
echo "Cleaning up..."
echo $PASSWORD | sudo -S pwpolicy -a $USER -u $USER -setpolicy "newPasswordRequired=1"

# Check for updates and restart
echo $PASSWORD | sudo -S softwareupdate -l -i -a
echo "Script complete, restarting..."
sleep 10
history -c
echo $PASSWORD | sudo -S shutdown -r now
