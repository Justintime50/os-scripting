# Scripting macOS for Personal Use

The following checklist are items that I do for any new setup (that aren't already handled via the deploy script). If the items is checked below, I've added an automated CLI implementation in the `deploy-personal-mac.sh` script in this directory. Long-term I'd like to automate as much of this process as possible.

See the accompanying `macos_defaults.md` file for details about Apple `defaults`.

## General

- [ ] Sign in to iCloud
- [ ] Turn on trim for SSD (once done as it restarts machine) `sudo trimforce enable`
- [x] Turn on dark mode

## Desktop & Screen Saver

- [ ] Turn on Aerial screensaver
- [ ] Bottom right corner set to hot corner “screensaver”
- [ ] Start screensaver after 20 mins

## Dock & Menu Bar

- [x] Turn on date in nav bar
- [x] Hide dock by default
- [x] Show battery percentage
- [ ] Setup the dock the way we want
  - [ ] Remove downloads from the dock
  - [x] Don't show recents
  - [ ] App icons (and their order)

## Finder

- [ ] Add HD’s to the finder sidebar
- [ ] Add connected servers to the finder sidebar
- [ ] Add home folder to finder sidebar
- [ ] Add computer to the finder sidebar
- [x] Show mounted media on Desktop
- [x] Enable hidden files

## Notifications

- [ ] Do not disturb schedule (11:30pm - 7:00 am)

## Security & Privacy

- [ ] Turn on FileVault
- [ ] Allow Apple Watch to unlock Mac
- [x] Turn on firewall

## Software Updates

- [ ] Automatically keep the Mac up to date

## Network

- [ ] Set ethernet preference over wifi when available

## Trackpad & Mouse

- [x] Enable all the features

## Keyboard

- [x] If there is a Touch Bar, set it to the “Expanded Control Strip”
- [ ] Turn keyboard backlight off after 30 seconds

## Battery

- [x] Power settings (never turn off when plugged in, 15mins turn off display on battery

## Sharing

- [x] Enable remote management
- [x] Set computer name

## Time Machine

- [ ] Enable time machine

## Misc

- [x] Change shell to zsh
- [x] Whatever else is in the current scripting setup
- [x] Install homebrew and packages
- [x] Install dotfiles

## Cron

- [ ] For Server, ensure that `cron` has `full-disk access`
- [ ] Setup local mail server for things like crontabs: https://gist.github.com/Justintime50/6053e4657dd6d9ccec6cda20ec5389a5

## Server

- [ ] Copy working `git` folder from previous environment
- [ ] Spin up Harvey and install initially `make install`
- [ ] Grab the previous crontab env file or rebuild with necessary env variables
