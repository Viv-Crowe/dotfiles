#!/bin/bash

######### COMMON #########

# $1 - filename
function gen-ssh() {
    ssh-keygen -t ed25519 -a 100 -f "$1" -N '' -C '';
};

# $1 - username
# $2 - home directory
function configure-user-ssh() {
    ssh_dir="$2/.ssh/";
    echo "creating .ssh directory";
    mkdir "$ssh_dir";

    echo "generating an SSH key";
    gen-ssh "$ssh_dir/id_ed25519";

    echo "adding key to users authorized_keys";
    cat "$ssh_dir/id_ed25519.pub" > "$ssh_dir/authorized_keys";

    chmod 0700 "$ssh_dir";
    chown -R "$1:$1" "$ssh_dir";
};

# $1 - username
# $2 - home directory
# $3 - github username
function configure-user() {
    echo "setting bash as default shell";
    chsh /bin/bash "$1";

    echo "adding .bash_profile";
    cp .bash_profile "$2/.bash_profile";

    echo "adding .gitconfig";
    cp .gitconfig "$2/.gitconfig";

    echo "adding global .gitignore";
    cp .gitignore "$2/.gitignore";

    echo "configuring ssh";
    configure-user-ssh "$1" "$2";

    echo "enabling ssh for GitHub"
    cp .sshconfig "$2/.ssh/config";
    sed -i -e "s/GITHUB_USERNAME/$3/g" "$2/.ssh/config";
    echo "dont forget to add $2/.ssh/id_ed25519.pub to your github account";

    echo "creating a Projects folder in the users home directory";
    mkdir "$2/Projects";

    echo "setting user as owner to everything in the home directory";
    chown -R "$1:$1" "$2";
};


######### LINUX #########
# Run all commands as Sudoer

function update-apt() {
    sudo apt-get update && sudo apt-get dist-upgrade --allow;
};

function update-nix() {
    sudo nix-channel --update;
    sudo nixos-rebuild switch;
};

# $1 - username
# run as root
function create-linux-user() {
    echo "creating user with sudoer permission";
    useradd -d "/home/$1" -m -G sudo "$1";

    echo "enter user password:";
    passwd "$1";
};

######### MacOS #########
# Run all commands as Sudoer

function update-mac() {
    softwareupdate --list; # --background Trigger a background scan and update operation (ROOT only)
    softwareupdate --download; # Download only
    softwareupdate --install --all; # --recommended OR --os-only, --restart
};

function install-brew() {
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
};

function update-brew() {
    brew update;
    brew upgrade;
    brew upgrade --cask;
    brew cleanup;
}

# Must be run in system recovery mode to temporarly bypass system integrity protection (SIP)
function update-bash() {
    brew install bash;
    csrutil disable;
    sudo cp /bin/bash ~/temp_bash;
    sudo rm /bin/bash;
    sudo ln -s /usr/local/bin/bash /bin/bash;
    sudo rm ~/temp_bash;
    csrutil enable;
};


# $1 - username
# $2 - User Name
# $3 password
function create-mac-user() {
    echo "creating user with non-admin privileges";
    sysadminctl -addUser "$1" -fullName "$2" -password "$3" -home "/Users/$1"; # [-admin] [-picture <full path to user image>]
};

# $1 - new machine name
function configure-mac-security() {
    echo "turn on filevault";
    fdesetup enable;

    echo "turn on firewall";
    defaults write /Library/Preferences/com.apple.alf globalstate -int 2;

    echo "install critical updates automatically";
    defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true;

    echo "disable Guest Login";
    defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false;

    echo "set DNS to Quad9";
    networksetup -setdnsservers Wi-Fi 9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9;

    echo "changing ComputerName, localhost and NetBIOSName";
    scutil --set ComputerName "$1";
    scutil --set LocalHostName "$1";
    defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$1";
    defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription -string "$1";

    echo "disable Siri";
    defaults write com.apple.assistant.support "Assistant Enabled" -bool false;
    defaults write com.apple.Siri StatusMenuVisible -bool false;

    echo "disable Visual Intelligence"
    defaults write com.apple.visualintelligence sendLocationInfo -bool false;
    defaults write com.apple.visualintelligence sendOCRText -bool false;
    defaults write com.apple.visualintelligence enableScreenshots -bool false;
    defaults write com.apple.visualintelligence enableSafariApp -bool false;
    defaults write com.apple.visualintelligence enableQuickLook -bool false;
    defaults write com.apple.visualintelligence enablePhotosApp -bool false;
    defaults write com.apple.visualintelligence enablePetsDomain -bool false;
    defaults write com.apple.visualintelligence enableNatureDomain -bool false;
    defaults write com.apple.visualintelligence enableLandmarkDomain -bool false;
    defaults write com.apple.visualintelligence enableCoarseClassification -bool false;
    defaults write com.apple.visualintelligence enableBooksDomain -bool false;
    defaults write com.apple.visualintelligence enableArtDomain -bool false;
    defaults write com.apple.visualintelligence enableAlbumsDomain -bool false;

    echo "disable Sharing"

    defaults write com.apple.amp.mediasharingd "home-sharing-enabled" -bool false;
    defaults write com.apple.amp.mediasharingd "photo-sharing-enabled" -bool false;
    defaults write com.apple.amp.mediasharingd "public-sharing-enabled" -bool false;
    defaults write com.apple.amp.mediasharingd "public-sharing-enabled" -bool false;


    echo "disable advertising"
    defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false;
    defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false;
    defaults write com.apple.AdLib personalizedAdsMigrated -bool false;
};

function configure-mac-ui() {
    echo "finder: show hidden files by default";
    defaults write com.apple.finder AppleShowAllFiles -bool true;

    echo "finder: dont show harddrive on desktop";
    defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false;

    echo "finder: dont show tags section in sidebar";
    defaults write com.apple.finder SidebarTagsSctionDisclosedState -bool false;

    echo "finder: dont show iCloud section in sidebar";
    defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false;
    defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool false;

    echo "finder: show devices section in sidebar";
    defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true;

    echo "finder: show places section in sidebar";
    defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true;

    echo "finder: new window opens to home directory"
    defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/";

    echo "dock: remove everything pinned";
    defaults write com.apple.dock persistent-apps -array;

    echo "dock: disable pinning";
    defaults write com.apple.dock static-only -bool true;

    echo "dock: autohide on";
    defaults write com.apple.dock autohide -bool true;

    echo "dock: setting size to smallish";
    defaults write com.apple.dock tilesize 36;

    killall Dock;
};

# Must be run in system recovery mode to temporarly bypass system integrity protection (SIP)
# $1 - username
# $2 - User Name
# $3 password
function configure-mac() {
    # Close any open System Preferences panes, to prevent them from overriding
    # settings we're about to change
    osascript -e 'tell application "System Preferences" to quit';

    # Ask for the administrator password upfront
    sudo -v;

    # Keep-alive: update existing `sudo` time stamp until `.macos` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    # While applying any changes to SoftwareUpdate defaults, set software update to OFF to avoid any conflict with the defaults system cache. (Also close the System Preferences app)
    sudo softwareupdate --schedule OFF;

    echo "updating macOS and App Store applications. restart may be required";
    update-mac;

    echo "installing XCode command line tools";
    xcode-select --install;

    echo "installing and updating Brew";
    install-brew;
    update-brew;

    echo "upgrading Bash to the latest version";
    upgrade-bash;

    echo "installing Visual Studio Code";
    brew install --cask visual-studio-code;

    echo "installing VSCode Extensions"
    xargs code --install-extension < extensions.vscode;

    echo "installing FireFox";
    brew install --cask firefox;

    echo "creating a user";
    create-mac-user "$1" "$2" "$3";

    echo "configuring current user";
    configure-user whoami ~;

    echo "configuring new user";
    configure-user "$1" "/Users/$1";

    echo "configuring security";
    configure-mac-security "networked-device";

    ## Next Steps
    echo "automated configuration complete!";
    echo "Next steps:";

    echo "## UI";
    echo "- turn on dark mode";
    echo "- turn on night shift";
    echo "- show battery percentage";
    echo "- remove siri from touch bar";
    echo "- set spotlight to show Apps, Calculator, Conversions, Documents, Folders, Other, PDF, Spreadsheets and System Preferences";

    echo "## Security and Privacy";
    echo "- setup VPN";
    echo "- setup firewall";
    echo "- disable location services";
    echo "- set inactivity logout/sleep settings";

    echo "## Configure Firefox";
    echo "- copy user.js to FireFox profile folder: $HOME/Library/Application Support/Firefox/Profiles/xxxxx.default";
    echo "- install extensions listed in extensions.firefox"
    echo "- copy over Bookmarks"
    echo "- set default web browser to Firefox (System Preferences > General)";

    echo "## Misc"
    echo "- install Quokka/Wallaby key"

    sudo softwareupdate --schedule ON;
};