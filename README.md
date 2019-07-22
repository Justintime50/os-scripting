# Mac Scripting
This is a collection of macOS scripts that can be used to automate certain administrative tasks for a fleet of Macs.

## Scripts

### Single Commands
The following can be found in the `single-commands` folder and serve a single purpose.
- `create-user.sh` - creates a user, adds a home folder, and makes them an admin.
- `delete-user.sh` - deletes a user and their home folder.
- `disable-filevault.sh` - disables filevault. May require the user to authenticate before it takes effect.
- `enable-filevault.sh` - enables filevault. May require the user to authenticate before it takes effect.
- `enable-remote-management.sh` - enables remote management and SSH access for admin users.
- `jamf-enrollment.sh` - allows you to retroactively enroll a device in Jamf. See [this article](https://support.jamfnow.com/s/article/360007191652-Enrolling-a-Computer-via-Automated-MDM-Enrollment-Post-Setup-Assistant) for additional info.
- `software-update.sh` - lists all available updates and then installs them without opening the app store. May require admin password.

### Deployment Scripts
The following are an all-inclusive script to deploy a machine:
- `deploy-new-mac.sh` - deploys a new mac, installing the necessary software, setting up users, enforcing security policies.
- `deploy-recycled-mac.sh` - deploys a mac if it previously belonged to another user.

## Usage
When creating a new script, make sure to save the file as a script file `.sh` and make the file executable with `sudo chmod 755 'filename'`.

## Gotchas

### Remote Management
In 10.14 Mojave, Control via Screen Sharing can only be turned on via the GUI in System Preferences. Observation mode can be configured via the CLI still.

### Jamf Now Re-Enrollment
If a Mac stops being able to inventory, it's probably because the original user that enrolled in Jamf is now deleted or inactive. Simply re-enroll the device in Jamf with the new local active account and the device will be able to inventory again. 
1. Send an "unenroll device" command via Jamf Now. This will remove the existing MDM profile from the Mac. Any lingering Apps may need to be removed manually if previously managed by Jamf Now.
2. Run the [Terminal command](https://support.jamfnow.com/s/article/360007191652-Enrolling-a-Computer-via-Automated-MDM-Enrollment-Post-Setup-Assistant) linked to re-enroll the Mac via Business Manager.

### Software Update
The software update script only updates macOS and 1st party apps. This means 3rd party apps like Slack, 1Password, and others will require an update via the app store or managed software.