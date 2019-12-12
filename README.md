# Mac Scripting
[![Build Status](https://travis-ci.org/Justintime50/mac-scripting.svg?branch=master)](https://travis-ci.org/Justintime50/mac-scripting)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)

This is a collection of macOS scripts that can be used to automate deploying and administrating macOS devices.

This project is intended to save IT professionals valuable hours, reduce user error, and provide consistency configuring macOS.

## Scripts

### Deployment Scripts
The following are an all-inclusive script to deploy a machine, found in the `deploy` folder. Many of these are for companies I've worked with or personal use.

### Legacy
The `legacy` folder contains depricated scripts replaced elsewhere.

### Single Commands
See the Single Commands [README](/single-commands.md) for info on useful terminal commands.

### Troubleshooting
The following scripts can be used to troubleshoot macOS
- `dep-reset-high-sierra.sh` - reset the DEP prompt to appear again on boot up for High Sierra and later. (Must be run in recovery mode terminal.)
- `dep-reset-sierra.sh` - reset the DEP prompt to appear again on boot up for Sierra. (Must be run in recovery mode terminal.)

## Usage

### Creating Scripts
When creating a new script, make sure to save the file as a script file `.sh` or `.command` for double click execution and make the file executable with `sudo chmod 755 <filename>`.

### Running Scripts
If a script ends in `.command` the file can simply be double clicked.

If a script ends in `.sh`, drag it into the terminal or navigate to the directory it's housed in and run `./script-name.sh` and hit enter.

## Testing
This project is tested with [ShellCheck](https://github.com/koalaman/shellcheck) via [Travis CI](https://travis-ci.org/Justintime50/mac-scripting).

## Gotchas

### Remote Management
In 10.14 Mojave, Control via Screen Sharing can only be turned on via the GUI in System Preferences. Observation mode can be configured via the CLI still.

### Jamf Re-Enrollment
If a Mac stops being able to inventory, it's probably because the original user that enrolled in Jamf is now deleted or inactive. Simply re-enroll the device in Jamf with the new local active account and the device will be able to inventory again. 
1. Send an "unenroll device" command via Jamf Now. This will remove the existing MDM profile from the Mac. Any lingering Apps may need to be removed manually if previously managed by Jamf Now.
2. Run the [Terminal command](https://support.jamfnow.com/s/article/360007191652-Enrolling-a-Computer-via-Automated-MDM-Enrollment-Post-Setup-Assistant) linked to re-enroll the Mac via Business Manager.

### Software Update
The software update script only updates macOS and 1st party apps. This means 3rd party apps like Slack, 1Password, and others will require an update via the app store or managed software.

### FileVault
Once FileVault is enabled, the user will need to punch in their password upon restart or shutdown. Additionally, FileVault may only be enabled for the user logged in when the command is run. This means other users on the machine may need to be enabled via the System Preferences GUI to unlock the disk. If they are not granted access, they won't show up on the login screen.

### "setpolicy" terminal command
This terminal command is [supposedly depricated](https://www.jamf.com/jamf-nation/discussions/25933/using-pwpolicy-to-require-an-immediate-password-reset) and may be replaced or done away with in coming macOS updates.

### DEP Prompt Not Showing
If you can't get a DEP prompt and it is enrolled, typically the battery died completely and it's running off default 1970 time. Boot into recovery mode and run `sntp -sS time.apple.com` to set the current time (requires internet connection).