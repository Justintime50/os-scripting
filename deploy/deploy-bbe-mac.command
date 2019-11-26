#!/bin/bash

###########################
## DEPLOY NEW MAC SCRIPT ##
###########################

# Initialization
echo -e "BBE macOS deployment script started...\n"
USER=$(id -u -n) # explicitly assign user regardless of login or access
echo -n "Current User's Password: "
read -rs PASSWORD
echo ""
echo -n "BBE Admin Password (found in 1Password): "
read -rs ADMINPASSWORD
echo ""

# Install Command Line Tools (will require user input on pop-up window)
echo "Initializing tools, please acknowledge pop-up windows..."
xcode-select --install

# Install Homebrew
echo "$PASSWORD" | sudo -S curl -fsS 'https://raw.githubusercontent.com/Homebrew/install/master/install' | ruby
brew doctor

# Create the BBE Admin user and explicitly add SecureToken
echo "Creating BBE Admin user..."
echo "$PASSWORD" | sudo -S sysadminctl -addUser admin -password "$ADMINPASSWORD" -fullName "BBE Admin" -admin

# Assign variables to initialize computer name
MODEL=$(sysctl hw.model | sed 's/[0-9, ]//g' | cut -c 10-)
YEAR=$(curl -s https://support-sp.apple.com/sp/product?cc=JG5J | grep -o '\d\d\d\d' | cut -c 3-)
SERIAL=$(system_profiler SPHardwareDataType | awk '/Serial/ {print $4}' | cut -c 7-)

# Change computer name
echo "Updating computer name..."
COMPUTER_NAME=$MODEL$YEAR-$SERIAL
echo "$PASSWORD" | sudo -S scutil --set ComputerName "$COMPUTER_NAME"
echo "$PASSWORD" | sudo -S scutil --set HostName "$COMPUTER_NAME"
echo "$PASSWORD" | sudo -S scutil --set LocalHostName "$COMPUTER_NAME"
echo "$PASSWORD" | sudo -S defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$COMPUTER_NAME"
dscacheutil -flushcache # flush the DNS cache for good measure

# Turn on Firewall (will require a restart before it shows on)
echo "Turning on firewall..."
echo "$PASSWORD" | sudo -S defaults write /Library/Preferences/com.apple.alf globalstate -int 1

# Enable Remote Management (will require additional configuration through System Preferences for Mojave 10.14 and higher)
echo "Turning on remote management & login..."
echo "$PASSWORD" | sudo -S systemsetup -setremotelogin on
echo "$PASSWORD" | sudo -S /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

# Install Google Chrome
echo "Installing apps..."
brew cask install google-chrome

# Force a password reset on the *current* user upon login
echo "Cleaning up..."
echo "$PASSWORD" | sudo -S pwpolicy -a "$USER" -u "$USER" -setpolicy "newPasswordRequired=1"

# Open Jamf Enrollment Page & Run DEP Enrollment Command (only one is necessary depending on how the device was purchased)
open https://9ghcfm.jamfcloud.com
echo "$PASSWORD" | sudo -S profiles renew -type enrollment
echo -e "\nNOTE: Use the Open Enrollment webpage if macs were NOT bought directly from our DEP Authorized Supplier. Otherwise, check Profiles under System Preferences to verify this Mac has been enrolled.\n"

# Check for updates and restart
echo "$PASSWORD" | sudo -S softwareupdate -l -i -a
echo -e "Script complete.\nPlease check for errors and ensure this Mac is enrolled before proceeding.\n\nPress <enter> to shutdown and update."
read -rn 1
echo "Shutting down..."
sleep 5
history -c
echo "$PASSWORD" | sudo -S shutdown -h now
