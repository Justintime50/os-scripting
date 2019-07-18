# Mac Scripting
This is a collection of macOS scripts that can be used to automate certain administrative tasks for a fleet of Macs.

## Scripts
- `create-user.sh` - creates a user
- `enable-filevault.sh` - enables filevault. Will require the user to authenticate before it takes effect
- `enable-remote-management.sh` - enables remote management and SSH access for admin users
- `jamf-enrollment.sh` - allows you to retroactively enroll a device in Jamf. See [this article](https://support.jamfnow.com/s/article/360007191652-Enrolling-a-Computer-via-Automated-MDM-Enrollment-Post-Setup-Assistant) for additional info

## Usage
When creating a new script, make sure to save the file as a script file `.sh` and make the file executable with `sudo chmod 755 'filename'`.

## Gotchas

### Remote Management
In 10.14 Mojave, Control via Screen Sharing can only be turned on via the GUI in System Preferences. Observation mode can be configured via the CLI still.

### Jamf Now Re-Enrollment
If a Mac stops being able to inventory, it's probably because the original user that enrolled in Jamf is now deleted or inactive. Simply re-enroll the device in Jamf with the new local active account and the device will be able to inventory again. 
1. Send an "unenroll device" command via Jamf Now. This will remove the existing MDM profile from the Mac. Any lingering Apps may need to be removed manually if previously managed by Jamf Now.
2. Run the [Terminal command](https://support.jamfnow.com/s/article/360007191652-Enrolling-a-Computer-via-Automated-MDM-Enrollment-Post-Setup-Assistant) linked to re-enroll the Mac via Business Manager.