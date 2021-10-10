#!/bin/bash

# shellcheck disable=SC1091

## DEPLOY PERSONAL MAC
## Can be used for MacBook or Server

main() {
    echo "This script is almost completely automated! It will prompt for an initial password, initial computer name, and eventually copy your SSH key to the clipboard to be pasted into GitHub. Finally, you'll press enter to restart the device and install updates."
    
    { # Wrap script in error logging
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
    } 2> ~/deploy_script.log # End error logging wrapper

    cleanup
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
    # echo "$PASSWORD" | sudo trim force enable
    
    # Change shell to ZSH
    echo "Changing default shell..."
    echo "$PASSWORD" | chsh -s /bin/zsh

    # Turn on Firewall
    echo "Turning on firewall..."
    echo "$PASSWORD" | sudo -S defaults write /Library/Preferences/com.apple.alf globalstate -int 1

    # Enable Remote Management (will require additional configuration through System Preferences for Mojave 10.14 and higher)
    echo "Turning on remote management & login..."
    echo "$PASSWORD" | sudo -S systemsetup -setremotelogin on
    echo "$PASSWORD" | sudo -S /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -activate -configure -access -on -users admin -privs -all -restart -agent -menu

}

install_command_line_tools() {
    # Install Command Line Tools
    echo "Installing Xcode..."
    xcode-select --install
}

install_rosetta() {
    # Installs Rosetta2 on arm64 Macs (eg: M1 chips)
    if [ "$(arch)" = "arm64" ] ; then
        echo "arm64 Mac detected, installing Rosetta2..."
        /usr/sbin/softwareupdate --install-rosetta --agree-to-license
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
    echo ". $HOME/.dotfiles/dots/src/dots.sh" >> "$HOME/.zshrc" && . "$HOME/.zshrc"
    DOTFILES_URL="https://github.com/Justintime50/dotfiles.git" dots_sync
}

install_brewfile() {
    # Install packages from Brewfile (generated by Alchemist)
    if [[ "$HOSTNAME" == "MacBook-Pro-Justin" ]] ; then
        brew bundle --file "$HOME/.dotfiles/src/personal/Brewfile"
    elif [[ "$HOSTNAME" == *"Server"* ]] ; then
        brew bundle --file "$HOME/.dotfiles/src/server/Brewfile"
    elif [[ "$HOSTNAME" == "MacBook-Pro-Justin-EasyPost" ]] ; then
        brew bundle --file "$HOME/.dotfiles/src/easypost/Brewfile"
    else
        echo "HOSTNAME doesn't match any config for Brewfile installation."
    fi
}

install_python_tools() {
    # TODO: This is highly inefficient, automate this instead of hard coding tools
    if [[ "$HOSTNAME" == *"Server"* ]] ; then
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
    pbcopy < ~/.ssh/id_rsa.pub
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
