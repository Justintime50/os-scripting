# Single Commands

## creates an admin account. Replace <user> and <password> with desired values. For a standard account, remove "-admin"

```bash
sudo sysadminctl -addUser <new user> -password <password> -fullName "Real Name Here" -admin
```

## enables Secure Token required to unlock FileVault Disks in 10.13+

```bash
sysadminctl -adminUser <current user> -adminPassword - -secureTokenOn admin -password <password>
```

## Remove User

```bash
sudo dscl . delete /Users/username # remove user
sudo rm -rf /Users/username # remove home folder
```

## Enable/Disable FileVault

```bash
sudo fdesetup disable
```

## Disable Filevault (requires restart, 0 for disabled, 1 for enabled)

```bash
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 0
```

## Enable Remote Management (only works on 10.13 and earlier to have control, otherwise this must be enabled via GUI in System Preferences)

```bash
sudo systemsetup -setremotelogin on

sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu
```

## Erase Touchbar Data

```bash
xartutil --erase-all
```

## Force Password Reset

```bash
pwpolicy -a adminuser -u usertoforcechange -setpolicy "newPasswordRequired=1"
```
Replace "adminuser" with the user authenticating the policy and "usertoforcechange" to the user you want to force the password reset on

## Jamf Enrollment

```bash
sudo profiles renew -type enrollment
```

## Software Update

```bash
sudo softwareupdate -l -i -a
```

## View User Groups

```bash
id -G USERNAME
```

## Add admin permisisons

```bash
dseditgroup -o edit -a USERNAME admin
```

## Remove admin permissions

```bash
dseditgroup -o edit -d USERNAME admin
```
