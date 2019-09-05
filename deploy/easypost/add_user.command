#!/bin/sh

# =====================
# Add User macOS Script
# =====================

{ # Wrap script in error logging
touch ~/add_user_script.log

# Check that the EPENROLL volume is mounted and named properly, otherwise installing apps won't work
if mount | grep /Volumes/EPENROLL > /dev/null; then
  echo "Starting EP Add User Script..."
else
  echo "The EPENROLL volume (USB) is not mounted or named properly. Please fix this before proceeding."
  exit 1
fi

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
  echo "Enter Admin password"
  read -s ADMINPASS  

  echo "Enter your desired user name: "  
  read USERNAME

  echo "Enter a full name for this user: "
  read FULLNAME

  echo "Enter a password for this user: "
  read PASSWORD

  echo "FullName: $FULLNAME"
  echo "Username: $USERNAME"
  echo "Password Entered: $PASSWORD"

  if [[ -z "${USERNAME// }" ]] ; then
    echo "Username cannot be blank"
  else
    echo "Is this info correct? y/N"
    read USERINFO
  fi
done

# Setup user groups
echo "Is this an administrative user? (y/N)"
read GROUP_ADD
case $GROUP_ADD in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";; # TODO: This doesn't repeat the prompt if the user clicks something other than y or n
esac

if [[ $GROUP_ADD = "n" || $GROUP_ADD = "N" ]] ; then
  SECONDARY_GROUPS="staff _lpadmin" # for a non-admin user
else [[ $GROUP_ADD = "y" || $GROUP_ADD = "Y" ]] ; SECONDARY_GROUPS="admin _lpadmin _appserveradm _appserverusr"
fi

# Setting up Temp Space for Downloads
temp=$TMPDIR$(uuidgen)
mkdir -p $temp/mount

echo "Have you downloaded default assets to EPENROLL? (y/N)"
read ASSETCHOICE
case $ASSETCHOICE in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";; # TODO: This doesn't repeat the prompt if the user clicks something other than y or n
esac

if [[ $ASSETCHOICE = "n" || $ASSETCHOICE = "N" ]] ; then 
  echo "Downloading Assets..."
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/MerakiSM-Agent-easypost-corp-mdm.pkg >/volumes/EPENROLL/MerakiSM-Agent-easypost-corp-mdm.pkg
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/Brother_PrinterDrivers_ColorLaser.pkg >/volumes/EPENROLL/Brother_PrinterDrivers_ColorLaser.pkg
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/Backup%20and%20Sync%20from%20Google.zip >/volumes/EPENROLL/Backup%20and%20Sync%20from%20Google.zip
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/RingCentral%20Phone.zip >/volumes/EPENROLL/RingCentral%20Phone.zip
  curl -s https://easypost-infotech-files.s3.amazonaws.com/default_install/Slack.zip >/volumes/EPENROLL/Slack.zip
else [[ $ASSETCHOICE = "y" || $ASSETCHOICE = "Y" ]] #; then
  break
fi

# Install Meraki Agent
echo "Has this machine been imaged or ever had the Meraki agent installed on it? (y/N)"
read MERAKICHOICE
case "$MERAKICHOICE" in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";; # TODO: This doesn't repeat the prompt if the user clicks something other than y or n
esac

if [[ $MERAKICHOICE = "n" || $MERAKICHOICE = "N" ]] ; then
  echo "Please deploy agent from the Meraki DEP console"
  echo "Enabling Location services"
  echo $ADMINPASS | sudo -S /usr/bin/defaults -currentHost write com.apple.locationd LocationServicesEnabled -int 1
else [[ $MERAKICHOICE = "y" || $MERAKICHOICE = "Y" ]] #; then
  echo $ADMINPASS | sudo -S installer -pkg /volumes/EPENROLL/MerakiSM-Agent-easypost-corp-mdm.pkg -target / ; echo "Meraki Agent installed"            
  break
fi

echo "Installing Brother Printer Drivers"
echo $ADMINPASS | sudo -S installer -pkg /volumes/EPENROLL/Brother_PrinterDrivers_ColorLaser.pkg -target / ; echo "Brother Drivers installed"

echo "Creating User Account"
export HISTIGNORE='*sudo -S*'
echo $ADMINPASS | sudo -S sysadminctl -adminUser epadmin -adminPassword $ADMINPASS -addUser $USERNAME -fullName $FULLNAME -password $PASSWORD

 # Add user to any specified groups
echo "Adding user to specified groups..."
for GROUP in $SECONDARY_GROUPS ; do
  echo $ADMINPASS | sudo -S dseditgroup -o edit -t user -a $USERNAME $GROUP
done

# User Creation Finished!
echo "Created user #$USERID: $USERNAME ($FULLNAME)"

# Copy Viscosity default prefs + Dock Default Prefs
echo "Copying Viscosity preferences"
echo $ADMINPASS | sudo -S cp /volumes/EPENROLL/xml/com.viscosityvpn.Viscosity.plist /Users/$USERNAME/Library/Preferences/
echo $ADMINPASS | sudo -S cp /volumes/EPENROLL/xml/com.apple.dock.plist /Users/$USERNAME/Library/Preferences
echo $ADMINPASS | sudo -S chown $USERNAME /Users/$USERNAME/Library/Preferences/com.viscosityvpn.Viscosity.plist

# Install Dockutil
echo $ADMINPASS | sudo -S cp /volumes/EPENROLL/xml/dockutil /usr/local/sbin/

# Updating MacOS
echo "Updating MacOS"
echo $ADMINPASS | sudo -S softwareupdate -l -ir

# Install Chrome
echo "Downloading Chrome"
tmpfile=$temp/chrome.dmg
curl -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg > $tmpfile

yes | hdiutil attach -noverify -nobrowse -mountpoint $temp/mount $tmpfile
echo $ADMINPASS | sudo -S cp -r $temp/mount/*.app /Applications
hdiutil detach $temp/mount
echo $ADMINPASS | sudo -S rm -r $tmpfile
open -a Google\ Chrome # We auto-launch Chrome so auto-updates can be initiated.
echo "Chrome Installed. Please verify automatic updates are enabled." 

# Copy Slack into Apps folder
echo $ADMINPASS | sudo -S mkdir /Users/$USERNAME/Applications
echo $ADMINPASS | sudo -S unzip -d /Users/$USERNAME/Applications/ /volumes/EPENROLL/Slack.zip 
echo $ADMINPASS | sudo -S chmod -R 755 /Users/$USERNAME/Applications
echo "Slack installed"

# Copy RingCentral into Apps folder
echo $ADMINPASS | sudo -S unzip -d /Users/$USERNAME/Applications /volumes/EPENROLL/RingCentral%20Phone.zip
echo "RingCentral Phone installed"
echo "Modifying Dock"
echo $ADMINPASS | sudo -S /usr/local/sbin/dockutil --add '/Users/$USERNAME/Applications/Slack.app' '/Users/$USERNAME' --no-restart
echo $ADMINPASS | sudo -S /usr/local/sbin/dockutil --remove 'Maps' '/Users/$USERNAME/' --no-restart
echo $ADMINPASS | sudo -S /usr/local/sbin/dockutil --remove 'Photos' '/Users/$USERNAME/' --no-restart
echo $ADMINPASS | sudo -S /usr/local/sbin/dockutil --add '~/Downloads' --view grid --display folder '/Users/$USERNAME/' --no-restart
echo $ADMINPASS | sudo -S chown -R $USERNAME /Users/$USERNAME/Applications

# Install Viscosity
echo "Downloading Viscosity"
tmpfile=$temp/viscosity.dmg
curl -L https://www.sparklabs.com/downloads/Viscosity.dmg > $tmpfile
yes | hdiutil attach -noverify -nobrowse -mountpoint $temp/mount $tmpfile
echo $ADMINPASS | sudo -S cp -r $temp/mount/*.app /Applications
hdiutil detach $temp/mount
echo $ADMINPASS | sudo -S rm -r $tmpfile
echo "Viscosity Installed" 

# Install Google Backup & Sync
echo "Installing Backup & Sync"
echo $ADMINPASS | sudo -S unzip -d /Applications /volumes/EPENROLL/Backup%20and%20Sync%20from%20Google.zip
echo "Backup & Sync installed"

# Install 1Password
echo "Downloading 1Pass"
tmpfile=$temp/1pass.pkg
curl -L https://app-updates.agilebits.com/download/OPM7 > $tmpfile
echo $ADMINPASS | sudo -S installer -pkg $tmpfile -target /

# Cleaning up temp directory
echo $ADMINPASS | sudo -S rm -r $temp

# Creating "Power Users"
echo "Giving non-admins System Preferences abilities"
echo $ADMINPASS | sudo -S security authorizationdb write system.preferences allow
echo $ADMINPASS | sudo -S security authorizationdb write system.preferences.datetime allow
echo $ADMINPASS | sudo -S security authorizationdb write system.preferences.network allow
echo $ADMINPASS | sudo -S security authorizationdb write system.print.admin allow
echo $ADMINPASS | sudo -S security authorizationdb write system.print.operator allow
echo $ADMINPASS | sudo -S security authorizationdb write system.preferences.printing allow
echo $ADMINPASS | sudo -S security authorizationdb write system.printingmanager allow
echo $ADMINPASS | sudo -S security authorizationdb write system.preferences.accessibility allow
echo $ADMINPASS | sudo -S security authorizationdb write system.preferences.energysaver allow
echo $ADMINPASS | sudo -S /usr/libexec/airportd prefs RequireAdminNetworkChange=NO RequireAdminIBSS=NO
echo $ADMINPASS | sudo -S /usr/bin/defaults -currentHost write com.apple.locationd LocationServicesEnabled -int 1
echo $ADMINPASS | sudo -S /usr/bin/defaults write /Library/Preferences/com.apple.timezone.auto Active -bool YES
echo $ADMINPASS | sudo -S /usr/bin/defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeOnlyEnabled -bool YES
echo $ADMINPASS | sudo -S /usr/bin/defaults write /private/var/db/timed/Library/Preferences/com.apple.timed.plist TMAutomaticTimeZoneEnabled -bool YES

echo "Syncing FileVault with APFS"
echo $ADMINPASS | sudo -S diskutil apfs updatePreboot /

# Change Computer Name
echo "Changing computer name..."
COMPUTERNAME=$FULLNAME # TODO: This is broken and isn't sending through strings
echo $ADMINPASS | sudo -S scutil --set ComputerName $COMPUTERNAME
echo $ADMINPASS | sudo -S scutil --set HostName $COMPUTERNAME
echo $ADMINPASS | sudo -S scutil --set LocalHostName $COMPUTERNAME
dscacheutil -flushcache

# Set password reset
echo "Setting password to require change..."
echo $ADMINPASS | sudo -S pwpolicy -u $USERNAME setpolicy newPasswordRequired=1

} 2> ~/add_user_script.log # End error logging wrapper
open ~/add_user_script.log # Open the log and have the user check for errors before finishing

echo -e "Script complete.\nPlease check error log (automatically opened) before restarting.\n\nPress <enter> to restart."
read -n 1 -s

# Restart the machine
echo "Restarting..."
sleep 10
history -c
echo $ADMINPASS | sudo -S shutdown -r now
