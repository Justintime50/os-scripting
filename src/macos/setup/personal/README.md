# Scripting macOS for Personal Use

The following checklist are items that I do for any new setup (that aren't already handled via the deploy script). If the item is checked below, I've added an automated CLI implementation in the `deploy-personal-mac.sh` script in this directory. Long-term I'd like to automate as much of this process as possible.

See the accompanying `macos_defaults.md` file for details about Apple `defaults`.

## Manual Tasks

The following cannot be automated and must be done in the following order:

1. [ ] Sign in to iCloud
1. [ ] Change shell to `zsh` via `chsh -s /bin/zsh` (open a new terminal once done before proceeding)
1. [ ] Install Dotfiles: <https://github.com/Justintime50/dotfiles>
1. [ ] Install Brewfile for machine: <https://github.com/Justintime50/dotfiles>
1. [ ] Copy working `git` folder from previous machine
1. [ ] Automatically keep the Mac up to date
1. [ ] Turn on FileVault (restart required)
1. [ ] Turn on trim for SSD (once done as it restarts machine) `sudo trimforce enable` (only for machines with a custom SSD installed)

### Order Insignificant

The following can be done in any order after the above section:

- [ ] Turn on Aerial screensaver
- [ ] Bottom right corner set to hot corner “screensaver”
- [ ] Start screensaver after 20 mins
- [ ] Setup the dock the way we want
  - [ ] Remove downloads from the dock
  - [ ] App icons (and their order)
- [ ] Finder sidebar
  - [x] Add hard drives
  - [ ] Add home folder
  - [ ] Add computer
  - [ ] Set `git` as default location when Finder opens
- [ ] Do not disturb schedule (11:30pm - 7:00 am)
- [ ] Set ethernet preference over wifi when available
- [ ] Enable time machine
- [ ] Install App Store specific items (Final Cut Pro, Logic Pro, etc)
- [ ] Remove unneeded apps from Apple

### macOS Server

- [ ] For Server, ensure that `cron` has `full-disk access`
- [ ] Setup local mail server for things like crontabs: <https://gist.github.com/Justintime50/6053e4657dd6d9ccec6cda20ec5389a5>
- [ ] Spin up Harvey and install initially
- [ ] Grab the previous crontab env file or rebuild with necessary env variables
- [ ] Install Python scripts/tools with custom virtual envs per project (github-archive, pullbug, etc)
