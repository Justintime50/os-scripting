#!/bin/bash

sudo dscl . -create /Users/username
sudo dscl . -create /Users/username UserShell /bin/bash
sudo dscl . -create /Users/username RealName
sudo dscl . -create /Users/username UniqueID 1001
sudo dscl . -create /Users/username PrimaryGroupID 1000
sudo dscl . -create /Users/username NFSHomeDirectory /Local/Users/username
sudo dscl . -passwd /Users/username password
sudo dscl . -append /Groups/admin GroupMembership username