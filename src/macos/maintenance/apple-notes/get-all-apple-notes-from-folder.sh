#!/bin/bash

# Grab all notes from the Apple Notes application in a specific folder
# Returns all the notes as a single HTML blob
# NOTE: This will not grab photos imbedded in notes
# https://support.apple.com/guide/textedit/work-with-html-documents-txted0b6cd61/mac

echo "Getting Apple Notes, this could take some time..."
echo "DO NOT activate other windows during this process!"

# Wrap in osascript so we can use bash echo above ^
osascript <<EOD
    # Setup your variables
    set myAccount to "iCloud"
    set myFolder to "Notes"

    tell application "TextEdit"
        activate
        make new document
    end tell

    tell application "Notes"
        tell account myAccount
            # Grab each note from a the specified folder
            repeat with singleNote in notes in folder myFolder
                set noteText to "<!-- ### Start Note ### -->\n"
                set noteText to noteText & "<h1>" & (name of singleNote as string) & "</h1>\n"
                set noteText to noteText & "<p>Creation Date: " & (creation date of singleNote as string) & "</p>\n"
                set noteText to noteText & "<p>Modification Date: " & (modification date of singleNote as string) & "</p>\n"
                set noteText to noteText & (body of singleNote as string) & "\n\n"

                # Save the output to TextEdit
                tell application "TextEdit"
                    activate
                    set oldText to text of document 1
                    set text of document 1 to oldText & noteText
                end tell
            end repeat
        end tell
    end tell
EOD
