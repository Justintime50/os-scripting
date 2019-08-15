# Mac Scripting
This is a collection of macOS scripts that can be used to automate certain administrative tasks for a fleet of Macs.

This project is intended to save IT professionals valuable hours, reduce user error, and provide consistency configuring macOS.

## Scripts

### Deployment Scripts
The following are an all-inclusive script to deploy a machine, found in the `deploy` folder. All macOS deployments rely on `Homebrew`. Various GUI apps are installed via `Homebrew Cask`.
- `deploy-new-mac.command` - deploys a new mac, installing the necessary software, setting up an admin user, changing computer name, enrolling the device in Jamf, forcing a password reset, etc.
- `deploy-dev-mac.command` - deploys a mac intended for a software developer. Installs Command Line Tools, Homebrew, wget, npm, Yarn, Node, Python3 & PIP, Git, Docker, VS Code, and Chrome.

### Legacy
The `legacy` folder contains depricated scripts replaced elsewhere.

### Single Commands
The following can be found in the `single-commands` folder. Each script serves a single purpose.
- `create-user.sh` - creates a user, adds a home folder, enables Secure Token, and makes them an admin.
- `delete-user.sh` - deletes a user and their home folder.
- `disable-filevault.sh` - disables filevault. May require the user to authenticate before it takes effect.
- `disable-firewall.sh` - disables the firewall. Will require a restart to take effect.
- `enable-filevault.sh` - enables filevault. May require the user to authenticate before it takes effect.
- `enable-firewall.sh` - disables the firewall. Will require a restart to take effect.
- `enable-remote-management.sh` - enables remote management and SSH access for admin users.
- `erase-touchbar-data.sh` - erases the touchbar data for Macs equipped with a touchbar. Used when recycling the device.
- `force-password-reset.sh` - force the designated user to reset their password on next login.
- `jamf-enrollment.sh` - allows you to retroactively enroll a device in Jamf. See [this article](https://support.jamfnow.com/s/article/360007191652-Enrolling-a-Computer-via-Automated-MDM-Enrollment-Post-Setup-Assistant) for additional info.
- `print-device-info.sh` - prints the model and serial of the device.
- `software-update.sh` - lists all available updates and then installs them without opening the app store. May require admin password.
- `update-mac-name.sh` - updates the mac's computer name, hostname and bonjour name.

## Usage

### Creating Scripts
When creating a new script, make sure to save the file as a script file `.sh` or `.command` for double click execution and make the file executable with `sudo chmod 755 <filename>`.

### Running Scripts
If a script ends in `.command` the file can simply be double clicked.

If a script ends in `.sh`, drag it into the terminal or navigate to the directory it's housed in and run `./script-name.sh` and hit enter.

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