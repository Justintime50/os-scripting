#!/bin/bash

# This script resets the DEP Enrollment prompt

rm /volumes/Macintosh\ HD/var/db/.AppleSetupDone 
rm /volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Store/Conf* 
cd /volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/ 
rm -rf .[^.]* 
shutdown -r now
