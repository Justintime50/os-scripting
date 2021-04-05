<div align="center">

# macOS Scripts

A collection of macOS scripts that can be used to automate deploying and administrating macOS devices.

<img src="../../assets/macos.png">

</div>

## Scripts

### Companies

The `companies` folder contains scripts I built at the companies I've worked with either for deploying machines or troubleshooting issues.

### Legacy

The `legacy` folder contains depricated scripts replaced elsewhere.

### Personal

The `personal` folder contains opinionated scripts I've used for re-deploying my personal machine and server.

**NOTE:** Personal scripts should be used in conjuction with my [Dotfiles project](https://github.com/Justintime50/dotfiles) as no configuration happens in these personal scripts.

### Troubleshooting

The `troubleshooting` folder contains scripts that can be used to troubleshoot macOS.

## Docs

### Single Commands

See the [Single Commands](src/docs/single-commands.md) doc for info on useful terminal commands.

### Gotchas

See the [Gotchas](src/docs/gotchas.md) doc for gotchas on administering macOS in enterprise.

## Usage

To run a script without downloading this entire project, use the following. Change out the name/destination of the script in this repo in the command below:

```bash
# NOTE: not all scripts in this project can be run this way, some require to be downloaded
bash <(curl -s https://raw.githubusercontent.com/justintime50/mac-scripting/master/src/scripts/companies/buyboxexperts/deploy-bbe-mac.command)
```

### Creating Scripts

1. When creating a new script, save the file with the `.sh` extension to execute from a terminal or `.command` for double click execution.
1. Make the file executable, replace FILENAME with the name of your file:

```bash
chmod 755 FILENAME
```

### Running Scripts

If a script has the `.command` extension, the file can simply be double clicked like any program.

If a script ends with the `.sh` extension, either drag the script file into the terminal or navigate to the directory it's housed in and run `./script-name.sh` and hit enter.

## Attribution

* [Scripting the "Notes" Application](https://www.macosxautomation.com/applescript/notes/index.html)
* [Export Notes via AppleScript](https://gist.github.com/jthigpen/5067358)
