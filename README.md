<div align="center">

# Mac Scripting

This is a collection of macOS scripts that can be used to automate deploying and administrating macOS devices.

[![Build Status](https://travis-ci.org/Justintime50/mac-scripting.svg?branch=master)](https://travis-ci.org/Justintime50/mac-scripting)
[![MIT Licence](https://badges.frapsoft.com/os/mit/mit.svg?v=103)](https://opensource.org/licenses/mit-license.php)

<img src="assets/showcase.png">

</div>

This project is intended to save IT professionals valuable hours, reduce user error, and provide consistency configuring macOS.

## Scripts

### Companies
These are scripts I built at the companies I've worked with either for deploying machines or troubleshooting issues.

### Legacy
The `legacy` folder contains depricated scripts replaced elsewhere.

### Personal
These are opinionated scripts I've used for re-deploying my personal machine and server.

### Troubleshooting
The following scripts can be used to troubleshoot macOS.

## Docs

## Single Commands

See the Single Commands [README](/single-commands.md) for info on useful terminal commands.

## Usage

### Creating Scripts

When creating a new script, make sure to save the file as a script file `.sh` or `.command` for double click execution and make the file executable with `sudo chmod 755 <filename>`.

### Running Scripts

If a script ends in `.command` the file can simply be double clicked.

If a script ends in `.sh`, drag it into the terminal or navigate to the directory it's housed in and run `./script-name.sh` and hit enter.

## Testing
This project is tested with [ShellCheck](https://github.com/koalaman/shellcheck) via [Travis CI](https://travis-ci.org/Justintime50/mac-scripting).
