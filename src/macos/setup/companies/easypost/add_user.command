#!/bin/bash

# =====================
# Add User macOS Script
# =====================

{ # Wrap script in error logging

# Check that the EPENROLL volume is mounted and named properly, otherwise installing apps won't work
cd /volumes/EPENROLL || echo "The EPENROLL volume (USB) is not mounted or named properly. Please fix this before proceeding."
echo "Starting EP Add User Script..."

# Check to make sure that filevault is already started.
EXPECTEDFILEVAULTSTATUS="FileVault is On."
FILEVAULTSTATUSCHECK=$(fdesetup status | grep -c "$EXPECTEDFILEVAULTSTATUS")
if [ "$FILEVAULTSTATUSCHECK" -eq 0 ]; then
  echo "Filevault is not configured.  Please ensure Filevault has been set up before running."
  exit 1
fi

# === Typically, this is all the info the tech needs to enter ===
USERINFO="N"
while ! [[ $USERINFO = "Y" || $USERINFO = "y" ]] ; do
  echo "Enter epadmin password"
  read -sr ADMINPASS

  echo "Enter the desired username for the new account: "  
  read -r NEWUSERNAME

  echo "Enter a full name for this user: "
  read -r FULLNAME

  echo "Enter a password for this user: "
  read -r PASSWORD

  echo "Full Name: $FULLNAME"
  echo "Username: $NEWUSERNAME"
  echo "Password Entered: $PASSWORD"

  if [[ -z "${NEWUSERNAME// }" ]] ; then
    echo "Username cannot be blank"
  else
    echo "Is this info correct? y/N"
    read -r USERINFO
  fi
done

# Check epadmin password to make sure it's valid before proceeding
echo "$ADMINPASS" | sudo -S echo "Testing password match..." || { echo 'The epadmin password you provided does not match, please restart the script with the correct password.'; exit 1; }
echo "epadmin password matched"

# Setup user groups
echo "Is this an administrative user? (y/N)"
read -r GROUP_ADD
case $GROUP_ADD in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";; # TODO: This doesn't repeat the prompt if the user clicks something other than y or n, it actually just continues
esac

if [[ $GROUP_ADD = "n" || $GROUP_ADD = "N" ]] ; then
  SECONDARY_GROUPS="staff _lpadmin" # for a non-admin user
else [[ $GROUP_ADD = "y" || $GROUP_ADD = "Y" ]] ; SECONDARY_GROUPS="admin _lpadmin _appserveradm _appserverusr"
fi

# Setting up Temp Space for Downloads
temp=$TMPDIR$(uuidgen)
mkdir -p "$temp"/mount

echo "Have you downloaded default assets to EPENROLL? (y/N)"
read -r ASSETCHOICE
case $ASSETCHOICE in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";; # TODO: This doesn't repeat the prompt if the user clicks something other than y or n, it actually just continues
esac

if [[ $ASSETCHOICE = "n" || $ASSETCHOICE = "N" ]] ; then 
  echo "Downloading Assets..."
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/MerakiSM-Agent-easypost-corp-mdm.pkg >MerakiSM-Agent-easypost-corp-mdm.pkg
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/Brother_PrinterDrivers_ColorLaser.pkg >Brother_PrinterDrivers_ColorLaser.pkg
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/RingCentral%20Phone.zip >RingCentral%20Phone.zip
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/Slack.zip >Slack.zip
else [[ $ASSETCHOICE = "y" || $ASSETCHOICE = "Y" ]] #; then
  echo "Assets downloaded, continuing..."
fi

# Install Meraki Agent
echo "Has this machine been imaged or ever had the Meraki agent installed on it? (y/N)"
read -r MERAKICHOICE
case "$MERAKICHOICE" in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";; # TODO: This doesn't repeat the prompt if the user clicks something other than y or n, it actually just continues
esac

if [[ $MERAKICHOICE = "n" || $MERAKICHOICE = "N" ]] ; then
  echo "Please deploy agent from the Meraki DEP console"
  echo "Enabling Location services"
  echo "$ADMINPASS" | sudo -S /usr/bin/defaults -currentHost write com.apple.locationd LocationServicesEnabled -int 1
else [[ $MERAKICHOICE = "y" || $MERAKICHOICE = "Y" ]] #; then
  echo "$ADMINPASS" | sudo -S installer -pkg MerakiSM-Agent-easypost-corp-mdm.pkg -target / ; echo "Meraki Agent installed"            
fi

# Install Brother printer drivers
echo "Installing Brother Printer Drivers"
echo "$ADMINPASS" | sudo -S installer -pkg Brother_PrinterDrivers_ColorLaser.pkg -target / ; echo "Brother Drivers installed"

# Create user account
echo "Creating User Account"
export HISTIGNORE='*sudo -S*'
echo "$ADMINPASS" | sudo -S sysadminctl -adminUser epadmin -adminPassword "$ADMINPASS" -addUser "$NEWUSERNAME" -fullName "$FULLNAME" -password "$PASSWORD"

 # Add user to any specified groups
echo "Adding user to specified groups..."
for GROUP in $SECONDARY_GROUPS ; do
  echo "$ADMINPASS" | sudo -S dseditgroup -o edit -t user -a "$NEWUSERNAME" "$GROUP"
done

# User Creation Finished
echo "Created user #$USERID: $NEWUSERNAME ($FULLNAME)"

# Copy Viscosity default prefs + Dock Default Prefs
echo "Copying Viscosity preferences"
echo "$ADMINPASS" | sudo -S cp xml/com.viscosityvpn.Viscosity.plist /Users/"$NEWUSERNAME"/Library/Preferences/
echo "$ADMINPASS" | sudo -S cp xml/com.apple.dock.plist /Users/"$NEWUSERNAME"/Library/Preferences
echo "$ADMINPASS" | sudo -S chown "$NEWUSERNAME" /Users/"$NEWUSERNAME"/Library/Preferences/com.viscosityvpn.Viscosity.plist

# Install Dockutil
echo "$ADMINPASS" | sudo -S cp xml/dockutil /usr/local/sbin/

# Updating MacOS
echo "Updating macOS"
echo "$ADMINPASS" | sudo -S softwareupdate -l -ir

# Install Chrome
echo "Downloading Chrome"
tmpfile=$temp/chrome.dmg
curl -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg > "$tmpfile"
yes | hdiutil attach -noverify -nobrowse -mountpoint "$temp"/mount "$tmpfile"
echo "$ADMINPASS" | sudo -S cp -r "$temp"/mount/*.app /Applications
hdiutil detach "$temp"/mount
echo "$ADMINPASS" | sudo -S rm -r "$tmpfile"
sleep 8
open -a Google\ Chrome # We auto-launch Chrome so auto-updates can be initiated.
sleep 10
killall "Google Chrome" 
sleep 7
open -a Google\ Chrome
echo "Chrome Installed. Please verify automatic updates are enabled." 

# Copy Slack into Apps folder
echo "$ADMINPASS" | sudo -S mkdir /Users/"$NEWUSERNAME"/Applications
echo "$ADMINPASS" | sudo -S unzip -d /Users/"$NEWUSERNAME"/Applications/ Slack.zip 
echo "$ADMINPASS" | sudo -S chmod -R 755 /Users/"$NEWUSERNAME"/Applications
echo "Slack installed"

# Copy RingCentral into Apps folder
echo "$ADMINPASS" | sudo -S unzip -d /Users/"$NEWUSERNAME"/Applications RingCentral%20Phone.zip
echo "RingCentral Phone installed"

# Modify the new user's dock
echo "Modifying Dock"
echo "$ADMINPASS" | sudo -S /usr/local/sbin/dockutil --remove 'Maps' /Users/"$NEWUSERNAME" --no-restart
echo "$ADMINPASS" | sudo -S /usr/local/sbin/dockutil --remove 'Photos' /Users/"$NEWUSERNAME" --no-restart
echo "$ADMINPASS" | sudo -S /usr/local/sbin/dockutil --remove 'Podcasts' /Users/"$NEWUSERNAME" --no-restart
echo "$ADMINPASS" | sudo -S /usr/local/sbin/dockutil --remove 'TV' /Users/"$NEWUSERNAME" --no-restart
echo "$ADMINPASS" | sudo -S /usr/local/sbin/dockutil --add /Users/"$NEWUSERNAME"/Applications/Slack.app /Users/"$NEWUSERNAME" --no-restart # TODO: Fix this, can't setup from another user
echo "$ADMINPASS" | sudo -S /usr/local/sbin/dockutil --add '$HOME/Downloads' --view grid --display folder /Users/"$NEWUSERNAME" --no-restart # TODO: Fix this, can't setup from another user
echo "$ADMINPASS" | sudo -S chown -R "$NEWUSERNAME" /Users/"$NEWUSERNAME"/Applications

# Install Viscosity
echo "Downloading Viscosity"
tmpfile=$temp/viscosity.dmg
curl -L https://www.sparklabs.com/downloads/Viscosity.dmg > "$tmpfile"
yes | hdiutil attach -noverify -nobrowse -mountpoint "$temp"/mount "$tmpfile"
echo "$ADMINPASS" | sudo -S cp -r "$temp"/mount/*.app /Applications
hdiutil detach "$temp"/mount
echo "$ADMINPASS" | sudo -S rm -r "$tmpfile"
sleep 8 # Sometimes Viscosity opens too quickly so we'll wait here
open -a Viscosity # We open Viscosity to click through the prompt for the helper tool installer
echo "Viscosity Installed" 

# Install Google Backup & Sync
echo "Installing Backup & Sync"
curl -L https://meraki-na.s3.amazonaws.com/pcc/enterprise-apps/e0357daef51c533241d0b7603516e0ae/be2251996032c72c5b5c848de8287e4f.dmg >"$tmpfile"
yes | hdiutil attach -noverify -nobrowse -mountpoint "$temp"/mount "$tmpfile"
echo "$ADMINPASS" | sudo -S cp -r "$temp"/mount/*.app /Applications
hdiutil detach "$temp"/mount
echo "$ADMINPASS" | sudo -S rm -r "$tmpfile"
echo "Backup & Sync installed"

# Install 1Password
echo "Downloading 1Password"
tmpfile=$temp/1pass.pkg
curl -L https://app-updates.agilebits.com/download/OPM7 > "$tmpfile"
echo "$ADMINPASS" | sudo -S installer -pkg "$tmpfile" -target /

# Cleaning up temp directory
echo "$ADMINPASS" | sudo -S rm -r "$temp"

# Creating "Power Users"
echo "Giving non-admins System Preferences abilities"
echo "$ADMINPASS" | sudo -S security authorizationdb write system.preferences allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.preferences.datetime allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.preferences.network allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.print.admin allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.print.operator allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.preferences.printing allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.printingmanager allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.preferences.accessibility allow
echo "$ADMINPASS" | sudo -S security authorizationdb write system.preferences.energysaver allow
echo "$ADMINPASS" | sudo -S /usr/libexec/airportd prefs RequireAdminNetworkChange=NO RequireAdminIBSS=NO
echo "$ADMINPASS" | sudo -S /usr/bin/defaults -currentHost write com.apple.locationd LocationServicesEnabled -int 1
echo "$ADMINPASS" | sudo -S /usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool YES
echo "$ADMINPASS" | sudo -S /usr/bin/defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeOnlyEnabled -bool YES
echo "$ADMINPASS" | sudo -S /usr/bin/defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeZoneEnabled -bool YES

# Sync FileVault with APFS
echo "Syncing FileVault with APFS"
echo "$ADMINPASS" | sudo -S diskutil apfs updatePreboot /

# Change Computer Name
echo "Changing computer name..."
COMPUTERNAME="$FULLNAME"
echo "$ADMINPASS" | sudo -S scutil --set ComputerName "$COMPUTERNAME"
echo "$ADMINPASS" | sudo -S scutil --set HostName "$COMPUTERNAME"
echo "$ADMINPASS" | sudo -S scutil --set LocalHostName "$COMPUTERNAME"
dscacheutil -flushcache

# Set password reset
echo "Setting password to require change..."
echo "$ADMINPASS" | sudo -S pwpolicy -u "$NEWUSERNAME" setpolicy newPasswordRequired=1

} 2> ~/add_user_script.log # End error logging wrapper
open ~/add_user_script.log # Open the log and have the user check for errors before finishing

echo -e "Script complete.\nPlease check error log (automatically opened) before restarting.\n\nPress <enter> to shutdown and update."
read -rn 1

# Restart the machine
echo "Shutting down..."
sleep 5
history -c
echo "$ADMINPASS" | sudo -S shutdown -h now # We shutdown instead of restart so software updates can be applied properly via CLI
