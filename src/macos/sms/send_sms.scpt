# Send an SMS from your Mac
# Usage: osascript send_imessage.scpt +1555555555 "Hello, here is a message."

on run {targetBuddyPhone, targetMessage}
    tell application "Messages"
        set targetService to 1st service whose service type = SMS
        set targetBuddy to buddy targetBuddyPhone of targetService
        send targetMessage to targetBuddy
    end tell
end run
