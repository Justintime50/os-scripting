#!/bin/bash

sudo dscl . -create /Users/username # swap username for the one-word username of the user
sudo dscl . -create /Users/username UserShell /bin/bash # sets the default shell
sudo dscl . -create /Users/username RealName "NAME HERE" # swap the name in quotes for the user's real name
sudo dscl . -create /Users/username UniqueID 1001 # give the user a unique ID not used by another user
sudo dscl . -create /Users/username PrimaryGroupID 20 # assign the group id to the user - 20 is staff, 80 is administrator. 20 is default
sudo dscl . -create /Users/username NFSHomeDirectory /Users/username # creates a home folder, swap username for the real username, won't be created until first login
sudo dscl . -passwd /Users/username password # swap password for the users password
sudo dscl . -append /Groups/admin GroupMembership username # This gives the new user administrative privileges. To make the new account a limited user account, skip this step.
