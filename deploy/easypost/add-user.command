#!/bin/sh
# =========================
# Add User macOS Command Line
# =========================

#if [ $UID -ne 0 ] ; then echo "Please run $0 as root.  Your UID is currently: $UID" && exit 1; fi

# Check to make sure that filevault is already started.

expectedStatus="FileVault is On."
statusCheck=$(fdesetup status | grep -c "${expectedStatus}")
if [ "${statusCheck}" -eq 0 ]; then
  echo "Filevault is not configured.  Please ensure Filevault has been set up before running."
  exit 1
fi

# === Typically, this is all the info you need to enter ===
userinfo="N"

while ! [ $userinfo = "Y" ] ; do
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
    echo "Is this info correct? Y/N"
    read userinfo
  fi

done

# ====
#echo "Is this an administrative user? (Y/N)"
#read GROUP_ADD
#GROUP_ADD=Y

read -p "Is this an administrative user? (Y/N)" GROUP_ADD
case "$GROUP_ADD" in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";;
esac

if [[ "$GROUP_ADD" = n ]] ; then
    SECONDARY_GROUPS="staff _lpadmin" # for a non-admin user
else [[ "$GROUP_ADD" = y ]] ; SECONDARY_GROUPS="admin _lpadmin _appserveradm _appserverusr"

fi

#if [ "$GROUP_ADD" = N ] ; then
 #   SECONDARY_GROUPS="staff"  # for a non-admin user
#elif [ "$GROUP_ADD" = Y ] ; then
 #   SECONDARY_GROUPS="admin _lpadmin _appserveradm _appserverusr" # for an admin user
#else
 #   echo  "You did not make a valid selection!"
#fi

#Setting up Temp Space for Downloads

temp=$TMPDIR$(uuidgen)
mkdir -p $temp/mount


#Install Meraki Agent

read -p "Has this machine been imaged or ever had the Meraki agent installed on it? (y/n)" choice
#CHOICE=y
case "$choice" in
  y|Y ) echo "yes";;
  n|N ) echo "no";;
  * ) echo "y or n (Boolean) input required";;
esac


if [[ "$choice" = n ]] ; then
 echo "Please deploy agent from the Meraki DEP console"
 echo "Enabling Location services"
echo $ADMINPASS | sudo -S /usr/bin/defaults -currentHost write com.apple.locationd LocationServicesEnabled -int 1

else [[ "$choice" = y ]] #; then
echo $ADMINPASS | sudo -S installer -pkg /volumes/EPENROLL/MerakiSM-Agent-easypost-corp-mdm.pkg -target / ; echo "Meraki Agent installed"
#echo $ADMINPASS | sudo -S cp MerakiSM-Agent-easypost-corp-mdm.pkg $tmpfile
#echo "copying meraki agent to tempfile"
#echo $ADMINPASS | sudo -S installer -pkg $tmpfile -target /
#echo "Meraki agent installed"
#echo $ADMINPASS | sudo -S rm -r $tmpfile
#echo "cleaning up"
#else echo "you did not make a valid selection"
#else              
break
fi

echo "Press <enter> to continue"
read -n 1 -s
echo "Installing Brother Printer Drivers"
echo $ADMINPASS | sudo -S installer -pkg /volumes/EPENROLL/Brother_PrinterDrivers_ColorLaser.pkg -target / ; echo "Brother Drivers installed"

echo "Creating User Account"
export HISTIGNORE='*sudo -S*'
echo $ADMINPASS | sudo -S sysadminctl -adminUser epadmin -adminPassword $ADMINPASS -addUser "$USERNAME" -fullName "$FULLNAME" -password $PASSWORD

 #Add user to any specified groups
echo "Adding user to specified groups..."

for GROUP in $SECONDARY_GROUPS ; do
    echo $ADMINPASS | sudo -S dseditgroup -o edit -t user -a $USERNAME $GROUP
done

# User Creation Finished!
echo "Created user #$USERID: $USERNAME ($FULLNAME)"

#Copy Viscosity default prefs + Dock Default Prefs
echo "Copying Viscosity preferences"
echo ${ADMINPASS} | sudo -S cp /volumes/EPENROLL/xml/com.viscosityvpn.Viscosity.plist /Users/$USERNAME/Library/Preferences/
echo $ADMINPASS | sudo -S cp /volumes/EPENROLL/com.apple.dock.plist /Users/$USERNAME/Library/Preferences
echo ${ADMINPASS} | sudo -S chown $USERNAME /Users/$USERNAME/Library/Preferences/com.viscosityvpn.Viscosity.plist

#Install Dockutil
echo $ADMINPASS | sudo -S cp /volumes/EPENROLL/xml/dockutil /usr/local/sbin/

#Updating MacOS
echo "Updating MacOS"
echo ${ADMINPASS} | sudo -S softwareupdate -l
echo ${ADMINPASS} | sudo -S softwareupdate -ir 


#Install Chrome
echo "Downloading Chrome"
tmpfile=$temp/chrome.dmg
curl -L https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg > $tmpfile

yes | hdiutil attach -noverify -nobrowse -mountpoint $temp/mount $tmpfile
echo ${ADMINPASS} | sudo -S cp -r $temp/mount/*.app /Applications
hdiutil detach $temp/mount
echo ${ADMINPASS} | sudo -S rm -r $tmpfile

echo "Chrome Installed" 
echo "Press <enter> to continue"
read -n 1 -s

#Copy Slack into Apps folder
echo ${ADMINPASS} | sudo -S mkdir /Users/$USERNAME/Applications
echo ${ADMINPASS} | sudo -S cp -r /volumes/EPENROLL/Slack.app /Users/$USERNAME/Applications
echo ${ADMINPASS} | sudo -S chmod -R 755 /Users/$USERNAME/Applications

echo "Slack 4 installed" 

echo ${ADMINPASS} | sudo -S cp -r /volumes/EPENROLL/RingCentral\ for\ Mac.app /Users/$USERNAME/Applications
echo "RingCentral Phone 19.22 installed"
echo "Copying Default Dock plist and modifying Dock"
echo ${ADMINPASS} | sudo -S cp -r /volumes/EPENROLL/xml/com.apple.dock.plist /Users/$USERNAME/Library/Preferences
echo ${ADMINPASS} | sudo -S /usr/local/sbin/dockutil --add '~/Applications/Slack.app' '/Users/$USERNAME' --no-restart
echo ${ADMINPASS} | sudo -S /usr/local/sbin/dockutil --remove 'Maps' '/Users/$USERNAME/' --no-restart
echo ${ADMINPASS} | sudo -S /usr/local/sbin/dockutil --remove 'Photos' '/Users/$USERNAME/' --no-restart
echo ${ADMINPASS} | sudo -S /usr/local/sbin/dockutil --add '~/Downloads' --view grid --display folder '/Users/$USERNAME/' --no-restart
echo ${ADMINPASS} | sudo -S chown -R $USERNAME /Users/$USERNAME/Applications




#Install Viscosity
echo "Downloading Viscosity"
tmpfile=$temp/viscosity.dmg
curl -L https://www.sparklabs.com/downloads/Viscosity.dmg > $tmpfile
yes | hdiutil attach -noverify -nobrowse -mountpoint $temp/mount $tmpfile
echo ${ADMINPASS} | sudo -S cp -r $temp/mount/*.app /Applications
hdiutil detach $temp/mount
echo ${ADMINPASS} | sudo -S rm -r $tmpfile


echo "Viscosity Installed" 
echo "Press <enter> to continue"
read -n 1 -s

#Install Google Backup & Sync
echo "Installing Backup&Sync"
echo $ADMINPASS | sudo -S cp -r /volumes/EPENROLL/Backup\ and\ Sync.app /Applications/
echo "Backup & Sync installed"

#Install 1Password
echo "Downloading 1Pass"
tmpfile=$temp/1pass.pkg
curl -L https://app-updates.agilebits.com/download/OPM7 > $tmpfile
echo $ADMINPASS | sudo -S installer -pkg $tmpfile -target /

echo "Press <enter> to continue"
read -n 1 -s

#echo "Downloading Google Backup & Sync"
#tmpfile=$temp/InstallBackupAndSync.dmg
#curl -L https://dl.google.com/drive-file-stream/googledrivefilestream.dmg > $tmpfile
#yes | hdiutil attach -noverify -nobrowse -mountpoint $temp/mount $tmpfile
#echo "Installing Google File Stream"
#echo $ADMINPASS | sudo -S installer -pkg $temp/mount/GoogleDriveFileStream.pkg -target /

#Cleaning up temp directory
echo ${ADMINPASS} | sudo -S rm -r $temp

#echo "Press <enter> to continue"
#read -n 1 -s

# Add User to Encryption
#encryptCheck=fdesetup status\
#statusCheck=$(echo "${encryptCheck}" | grep "FileVault is On.")
#expectedStatus="FileVault is On."
#if [ "${statusCheck}" = "${expectedStatus}" ]; then 
#  echo "Enter the epadmin password"
#  read -s epadminpw
  #echo '<?xml version="1.0" encoding="UTF-8"?>
#<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
#<plist version="1.0">
#<dict>
#<key>Username</key>
#<string>'$epadmin'</string>
#<key>Password</key>
#<string>'$epadminpw'</string>
#<key>AdditionalUsers</key>
#<array>
  #  <dict>
 #       <key>Username</key>
#        <string>'$USERNAME'</string>
##       <key>Password</key>
 #       <string>'$PASSWORD'</string>
#    </dict>
#</array>
#</dict>
#</plist>' | fdesetup add -i
#else
#  echo "The encryption process has not completed, unable to add the user promgramically at this time.  User will need to be manually added.  Go to System Preferences -> Security & Privacy -> FileVault and add the user." 
#  echo "${encryptCheck}"
#  echo "Press <enter> to continue"
#  read -n 1 -s
#fi
#Creating "Power Users"
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
echo "$ADMINPASS" | sudo -S diskutil apfs updatePreboot /

# Change Computer Name
echo "Changing computer name..."

COMPUTERNAME="$FULLNAME\'s MacBook"

Echo “$ADMINPASS” | sudo -S scutil --set HostName $COMPUTERNAME
Echo “$ADMINPASS” | sudo -S scutil --set ComputerName $COMPUTERNAME
Echo “$ADMINPASS” | sudo -S scutil --set LocalHostName $COMPUTERNAME
Echo “$ADMINPASS” | sudo -S dscacheutil -flushcache

echo "Password Change Required and then Reboot.  Press <enter> to continue"
read -n 1 -s

# Set password reset
echo "Setting password to require change..."
Echo “$ADMINPASS” | sudo -S pwpolicy -u $USERNAME setpolicy newPasswordRequired=1

# Cleanup
history -c
sleep 30

# Restart machine
echo ${ADMINPASS} | sudo -S shutdown -r now
