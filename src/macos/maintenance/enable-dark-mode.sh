#!/bin/bash

# Enable macOS Dark Mode

echo "Enabling Dark Mode..."

osascript <<EOD
    tell application "System Events"
        tell appearance preferences
            set dark mode to true
        end tell
    end tell
EOD
