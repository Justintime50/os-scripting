#!/bin/bash

# Grab an single note from the Apple Notes application, returns the note as HTML
# NOTE: This will not grab photos imbedded in notes

osascript <<EOD
    tell application "Notes"
        tell account "iCloud"
            tell folder "My Folder Name"
            get body of note "My Note Name"
            end tell
        end tell
    end tell
EOD
