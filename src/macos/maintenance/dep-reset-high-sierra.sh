#!/bin/bash

# This script resets the DEP Enrollment prompt for High Sierra and later.

rm /volumes/Macintosh\ HD/var/db/.AppleSetupDone
rm /volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Setup/.profileSetupDone
cd /volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Store/ || exit
rm -rf ./*
cd /volumes/Macintosh\ HD/var/db/ConfigurationProfiles/Settings/ || exit
rm -rf .[^.]*
shutdown -r now
