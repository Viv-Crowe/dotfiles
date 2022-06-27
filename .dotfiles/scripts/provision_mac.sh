#!/bin/bash

# This script must be run in system recovery mode to temporarly bypass system integrity protection (SIP)
# $1 - username
# $2 - User Name
# $3 - password

# Ask for the administrator password upfront
sudo -v;

# Keep-alive: update existing `sudo` time stamp until `.macos` has finished
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

echo "updating macOS and App Store applications. restart may be required";
./update_mac.sh;

echo "installing XCode command line tools";
sudo xcode-select --install;

# While applying any changes to SoftwareUpdate defaults, set software update to OFF to avoid any conflict with the defaults system cache. (Also close the System Preferences app)
sudo softwareupdate --schedule OFF;

# Close any open System Preferences panes, to prevent them from overriding
# settings we're about to change
sudo osascript -e 'tell application "System Preferences" to quit';

echo "configuring security";
./configure_mac_security.sh "networked-device";

echo "installing and updating Brew";
./install_brew.sh;
./update_brew.sh;

echo "upgrading Bash to the latest version";
./upgrade_mac_system_bash.sh;

echo "installing Applications with Brew";
./install_brew_applications.sh

echo "configuring admin user";
./configure_mac_user.sh;

echo "creating a non-admin user";
./create_mac_user.sh "$1" "$2" "$3";

echo "initializing dotfile for non-admin user";
sudo -u "$1" -c "$(curl -fsSL https://raw.githubusercontent.com/DragosRotaru/dotfiles/master/.dotfiles/srcipts/install.sh)";

echo "configuring non-admin user";
sudo -u "$1" -c ./configure_mac_user.sh;

sudo softwareupdate --schedule ON;
