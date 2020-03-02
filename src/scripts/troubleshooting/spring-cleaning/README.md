# Spring Cleaning

Script that performs spring cleaning.

Reclaim your hard drive space. Performs duties such as `brew cleanup`, `docker system prune`, and empties the `Trash` and `Downloads`.

## Usage

```bash
./clean.sh
```

### Launch Agent

Edit the path in the `plist` file to your script and logs as well as the time to execute, then setup the Launch Agent:

```bash
# Copy the plist to the Launch Agent directory
cp local.springCleaning.plist ~/Library/LaunchAgents

# Use `load/unload` to add/remove the script as a Launch Agent
launchctl load ~/Library/LaunchAgents/local.springCleaning.plist

# To `start/stop` the script from running, use the following
launchctl start local.springCleaning.plist
```
