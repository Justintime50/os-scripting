#!/bin/bash

# This script resets the DEP Enrollment prompt for Sierra and earlier.

rm /volumes/Macintosh\ HD/var/db/.AppleSetupDone 
rm /volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Store/Conf* 
cd /volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/ || exit
rm -rf .[^.]* 
shutdown -r now
