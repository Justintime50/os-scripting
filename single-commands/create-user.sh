#!/bin/bash

sudo dscl . -create /Users/username # swap username for the one-word username of the user
sudo dscl . -create /Users/username UserShell /bin/bash 
sudo dscl . -create /Users/username RealName # swap RealName for the user's real name
sudo dscl . -create /Users/username UniqueID 1001 # give the user a unique ID not used by another user
sudo dscl . -create /Users/username PrimaryGroupID 1000 # swap username for the one-word username of the user
sudo dscl . -create /Users/username NFSHomeDirectory /Local/Users/username # creates a home folder, swap username for the real username
sudo dscl . -passwd /Users/username password
sudo dscl . -append /Groups/admin GroupMembership username # This gives the new user administrative privileges. To make the new account a limited user account, skip this step.