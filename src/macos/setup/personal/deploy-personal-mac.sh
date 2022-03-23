#!/bin/bash

# shellcheck disable=SC1091

## DEPLOY PERSONAL MAC
## Can be used for MacBook or Server

main() {
    echo "This script is almost completely automated! It will prompt for an initial password, initial computer name, and eventually copy your SSH key to the clipboard to be pasted into GitHub. Finally, you'll press enter to restart the device and install updates."

    { # Wrap script in error logging
        change_shell
        prompt_for_password
        change_computer_name
        setup_preferences
        install_command_line_tools
        install_rosetta
        install_homebrew
        install_git
        install_composer
        install_dotfiles
        install_brewfile
        install_python_tools
        install_updates
        generate_ssh_key
    } 2>~/deploy_script.log # End error logging wrapper

    cleanup
}

change_shell() {
    # THIS STEP MUST COME FIRST
    # Change shell to ZSH
    echo "Changing default shell..."
    chsh -s /bin/zsh
}

prompt_for_password() {
    echo -n "Admin Password: "
    read -rs PASSWORD
}

change_computer_name() {
    # Change the computer name in all applicable places
    echo -n "New computer name (eg: 'MacBook-Pro-Justin', 'Server', 'MacBook-Pro-Justin-EasyPost', etc): "
    read -rs NEW_COMPUTER_NAME

    echo "$PASSWORD" | sudo scutil --set ComputerName "$NEW_COMPUTER_NAME"
    echo "$PASSWORD" | sudo scutil --set HostName "$NEW_COMPUTER_NAME"
    echo "$PASSWORD" | sudo scutil --set LocalHostName "$NEW_COMPUTER_NAME"
    echo "$PASSWORD" | sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$NEW_COMPUTER_NAME"

    dscacheutil -flushcache # flush the DNS cache for good measure
}

setup_preferences() {
    # There are MANY more steps that for now will require manual work
    # TODO: See the accompanying README on personal deployments for more information on manual work required, eventually automate it here
    # Most of these will require a restart to take effect
    # Enable dark mode
    echo "Enabling dark mode..."
    echo "$PASSWORD" | sudo defaults write /Library/Preferences/.GlobalPreferences.plist _HIEnableThemeSwitchHotKey -bool true

    # Enable trim for SSD's (may need to be run separately from the rest of this since it has its own prompt)
    # echo "Enabling Trim for SSDs..."
    # echo "$PASSWORD" | sudo trimforce enable

    # Turn on Firewall
    echo "Turning on firewall..."
    echo "$PASSWORD" | sudo -S defaults write /Library/Preferences/com.apple.alf globalstate -int 1

    # Enable Remote Management (will require additional configuration through System Preferences for Mojave 10.14 and higher)
    echo "Turning on remote management & login..."
    echo "$PASSWORD" | sudo -S systemsetup -setremotelogin on
    echo "$PASSWORD" | sudo -S /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

    # Setup the Dock
    echo "Setting up the Dock..."
    defaults write com.apple.dock "autohide" -bool "true"
    defaults write com.apple.dock "show-recents" -bool "false"

    # Always show hidden files
    echo "Enabling hidden files..."
    defaults write com.apple.finder AppleShowAllFiles -bool YES

    # Setup Finder
    echo "Setting up Finder..."
    defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
    defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
    defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true

    # Setup the navbar
    echo "Setting up navbar..."
    defaults write com.apple.menuextra.clock DateFormat -string "EEE MMM d  j:mm a"
    defaults write com.apple.menuextra.battery ShowPercent ShowPercent -bool YES

    # Setup Trackpad
    echo "Setting up the Trackpad..."
    defaults write com.apple.AppleMultitouchTrackpad ActuateDetents -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -integer 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerHorizSwipeGesture -integer 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerPinchGesture -integer 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadFourFingerVertSwipeGesture -integer 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadMomentumScroll -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadPinch -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadRotate -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -integer 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerHorizSwipeGesture -integer 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerTapGesture -integer 0
    defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerVertSwipeGesture -integer 2
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerDoubleTapGesture -integer 1
    defaults write com.apple.AppleMultitouchTrackpad TrackpadTwoFingerFromRightEdgeSwipeGesture -integer 3

    # Setup Mouse
    echo "Setting up the Mouse..."
    defaults write com.apple.AppleMultitouchMouse MouseButtonDivision -integer 55
    defaults write com.apple.AppleMultitouchMouse MouseButtonMode -integer TwoButton
    defaults write com.apple.AppleMultitouchMouse MouseHorizontalScroll -integer 1
    defaults write com.apple.AppleMultitouchMouse MouseMomentumScroll -integer 1
    defaults write com.apple.AppleMultitouchMouse MouseOneFingerDoubleTapGesture -integer 1
    defaults write com.apple.AppleMultitouchMouse MouseTwoFingerDoubleTapGesture -integer 3
    defaults write com.apple.AppleMultitouchMouse MouseTwoFingerHorizSwipeGesture -integer 2
    defaults write com.apple.AppleMultitouchMouse MouseVerticalScroll -integer 1

    # Setup Keyboard
    echo "Setting up the Keyboard..."
    defaults write com.apple.com.apple.touchbar.agent PresentationModeGlobal -string "fullControlStrip"

    # Setup power settings
    echo "Setting up power settings..."
    # All power modes
    echo "$PASSWORD" | sudo pmset -a standbydelaylow 10800
    echo "$PASSWORD" | sudo pmset -a standby 1
    echo "$PASSWORD" | sudo pmset -a halfdim 1
    echo "$PASSWORD" | sudo pmset -a powernap 1
    echo "$PASSWORD" | sudo pmset -a disksleep 10
    echo "$PASSWORD" | sudo pmset -a standbydelayhigh 86400
    echo "$PASSWORD" | sudo pmset -a gpuswitch 2
    echo "$PASSWORD" | sudo pmset -a hibernatemode 3
    echo "$PASSWORD" | sudo pmset -a ttyskeepawake 1
    echo "$PASSWORD" | sudo pmset -a highstandbythreshold 50
    echo "$PASSWORD" | sudo pmset -a acwake 0
    echo "$PASSWORD" | sudo pmset -a lidwake 1

    # Charger power mode
    echo "$PASSWORD" | sudo pmset -c womp 1
    echo "$PASSWORD" | sudo pmset -c proximitywake 1
    echo "$PASSWORD" | sudo pmset -c networkoversleep 0
    echo "$PASSWORD" | sudo pmset -c sleep 0
    echo "$PASSWORD" | sudo pmset -c displaysleep 0

    # Battery power mode
    echo "$PASSWORD" | sudo pmset -b proximitywake 0
    echo "$PASSWORD" | sudo pmset -b sleep 60
    echo "$PASSWORD" | sudo pmset -b displaysleep 60

    # Restart all the things so preferences take effect (must come last)
    killall Dock
    killall Finder
}

install_command_line_tools() {
    # Install Command Line Tools
    echo "Installing Xcode..."
    xcode-select --install
}

install_rosetta() {
    # Installs Rosetta2 on arm64 Macs (eg: M1 chips)
    if [ "$(arch)" = "arm64" ]; then
        echo "arm64 Mac detected, installing Rosetta2..."
        softwareupdate --install-rosetta --agree-to-license
    else
        # i386 (x86_64) Mac
        echo "non-arm64 Mac detected, skipping installation of Rosetta2"
    fi
}

install_homebrew() {
    echo "Installing Homebrew..."
    echo "$PASSWORD" | /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
}

install_git() {
    echo "Installating Git..."
    brew install git
    mkdir -p "$HOME"/git
    mkdir -p "$HOME"/git/personal
}

install_composer() {
    # Install Composer for PHP package management
    echo "Installating Composer globally..."
    curl -sS https://getcomposer.org/installer | php
    echo "$PASSWORD" | sudo -S mv composer.phar composer
    echo "$PASSWORD" | sudo -S mv composer /usr/local/bin/
    echo "$PASSWORD" | sudo -S chmod 755 /usr/local/bin/composer

    # Install Laravel Globally
    composer global require laravel/installer
}

install_dotfiles() {
    git clone https://github.com/Justintime50/dotfiles.git "$HOME/.dotfiles"
    cd "$HOME/.dotfiles" && git submodule init && git submodule update
    echo ". $HOME/.dotfiles/dots/src/dots.sh" >>"$HOME/.zshrc" && . "$HOME/.zshrc"
    DOTFILES_URL="https://github.com/Justintime50/dotfiles.git" dots_sync
}

install_brewfile() {
    # Install packages from Brewfile (generated by Alchemist)
    if [[ "$HOSTNAME" == "MacBook-Pro-Justin" ]]; then
        brew bundle --file "$HOME/.dotfiles/src/personal/Brewfile"
    elif [[ "$HOSTNAME" == *"Server"* ]]; then
        brew bundle --file "$HOME/.dotfiles/src/server/Brewfile"
    elif [[ "$HOSTNAME" == "MacBook-Pro-Justin-EasyPost" ]]; then
        brew bundle --file "$HOME/.dotfiles/src/easypost/Brewfile"
    else
        echo "HOSTNAME doesn't match any config for Brewfile installation."
    fi
}

install_python_tools() {
    # TODO: This is highly inefficient, automate this instead of hard coding tools
    if [[ "$HOSTNAME" == *"Server"* ]]; then
        pip3 install forks-sync
        pip3 install github-archive
        pip3 install pullbug
    fi
}

install_updates() {
    # Download updates, installation happens on a reboot
    echo "Attempting to install updates..."
    echo "$PASSWORD" | sudo -S softwareupdate -i -a
}

generate_ssh_key() {
    # Generates an SSH key and copies it to the clipboard
    # Intended for immediate use by adding to GitHub or wherever it's needed
    # Will require user input for location and password, should be the only part of the script that isn't automated aside from the initial password.
    echo "Generating an SSH key..."
    ssh-keygen -t rsa
    pbcopy <~/.ssh/id_rsa.pub
    echo "Public SSH key copied to clipboard, please paste wherever it's needed."
}

cleanup() {
    # Clean up after the script runs and reboot
    open ~/deploy_script.log # Open the log and have the user check for errors before finishing
    echo -e "Script complete.\nPlease check error log (automatically opened) before restarting.\n\nPress <enter> to restart."
    read -rn 1
    echo "Shutting down..."
    sleep 5
    history -c
    echo "$PASSWORD" | sudo -S shutdown -h now
}

main
