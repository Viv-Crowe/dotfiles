#!/bin/bash

######### COMMON #########

# $1 - filename
function gen_ssh() {
    ssh-keygen -t ed25519 -a 100 -f "$1" -N '' -C '';
};

function configure_new_ssh() {
    ssh_dir="$HOME/.ssh/";
    echo "creating .ssh directory";
    mkdir "$ssh_dir";

    echo "generating an SSH key";
    gen_ssh "$ssh_dir/id_ed25519";

    echo "adding key to users authorized_keys";
    cat "$ssh_dir/id_ed25519.pub" > "$ssh_dir/authorized_keys";

    chmod 0700 "$ssh_dir";
};


# $1 - quokka license key
function install_wallaby_key() {
    echo "$1" >> ".quokka/.qlc";
    echo "$1" >> ".wallaby/key.lic";
}

# $1 - github username
function enable_github_ssh() {
    echo "enabling ssh for GitHub"
    cat sshconfig >> "$HOME/.ssh/config";
    sed -i -e "s/GITHUB_USERNAME/$1/g" "$HOME/.ssh/config";
    echo "make sure $HOME/.ssh/id_ed25519.pub is added to your github account";
}

######### LINUX #########
# Run all commands as Sudoer

function update_apt() {
    sudo apt-get update && sudo apt-get dist-upgrade --allow;
};

function update_nix() {
    sudo nix-channel --update;
    sudo nixos-rebuild switch;
};

# $1 - username
function create_linux_user() {
    echo "creating user with sudoer permission and bash shell";
    sudo useradd -d "/home/$1" -m -G sudo "$1" -s "/bin/bash";

    echo "enter user password:";
    sudo passwd "$1";
};

######### MacOS #########
# Run all commands as a Sudoer

function update_mac() {
    # sudo softwareupdate --list; # List available packages
    # sudo softwareupdate --download; # Download only
    sudo softwareupdate --background --install --all --restart; # --recommended OR --os-only
};

function install_brew() {
    sudo /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
};

function update_brew() {
    brew update;
    brew upgrade;
    brew upgrade --cask;
    brew cleanup;
}

# Must be run in system recovery mode to temporarly bypass system integrity protection (SIP)
function update_bash() {
    brew install bash;
    sudo csrutil disable;
    sudo cp /bin/bash ~/temp_bash;
    sudo rm /bin/bash;
    sudo ln -s /usr/local/bin/bash /bin/bash;
    sudo rm ~/temp_bash;
    sudo csrutil enable;
};


# $1 - username
# $2 - User Name
# $3 - user password
function create_mac_user() {
    echo "creating user with non-admin privileges";
    sudo sysadminctl -addUser "$1" -fullName "$2" -password "$3" -home "/Users/$1"; # [-admin] [-picture <full path to user image>]
    echo "setting bash as default shell";
    sudo chsh /bin/bash "$1";
};

# $1 - new machine name
function configure_mac_security() {
    echo "turn on filevault";
    sudo fdesetup enable;

    echo "turn on firewall";
    sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2;

    echo "install critical updates automatically";
    sudo defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -bool true;

    echo "disable Guest Login";
    sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false;

    echo "set DNS to Quad9";
    sudo networksetup -setdnsservers Wi-Fi 9.9.9.9 149.112.112.112 2620:fe::fe 2620:fe::9;

    echo "changing ComputerName, localhost and NetBIOSName";
    sudo scutil --set ComputerName "$1";
    sudo scutil --set LocalHostName "$1";
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server NetBIOSName -string "$1";
    sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server ServerDescription -string "$1";

    echo "disable Siri";
    sudo defaults write com.apple.assistant.support "Assistant Enabled" -bool false;
    sudo defaults write com.apple.Siri StatusMenuVisible -bool false;

    echo "disable Visual Intelligence"
    sudo defaults write com.apple.visualintelligence sendLocationInfo -bool false;
    sudo defaults write com.apple.visualintelligence sendOCRText -bool false;
    sudo defaults write com.apple.visualintelligence enableScreenshots -bool false;
    sudo defaults write com.apple.visualintelligence enableSafariApp -bool false;
    sudo defaults write com.apple.visualintelligence enableQuickLook -bool false;
    sudo defaults write com.apple.visualintelligence enablePhotosApp -bool false;
    sudo defaults write com.apple.visualintelligence enablePetsDomain -bool false;
    sudo defaults write com.apple.visualintelligence enableNatureDomain -bool false;
    sudo defaults write com.apple.visualintelligence enableLandmarkDomain -bool false;
    sudo defaults write com.apple.visualintelligence enableCoarseClassification -bool false;
    sudo defaults write com.apple.visualintelligence enableBooksDomain -bool false;
    sudo defaults write com.apple.visualintelligence enableArtDomain -bool false;
    sudo defaults write com.apple.visualintelligence enableAlbumsDomain -bool false;

    echo "disable Sharing"

    sudo defaults write com.apple.amp.mediasharingd "home-sharing-enabled" -bool false;
    sudo defaults write com.apple.amp.mediasharingd "photo-sharing-enabled" -bool false;
    sudo defaults write com.apple.amp.mediasharingd "public-sharing-enabled" -bool false;
    sudo defaults write com.apple.amp.mediasharingd "public-sharing-enabled" -bool false;


    echo "disable advertising"
    sudo defaults write com.apple.AdLib allowApplePersonalizedAdvertising -bool false;
    sudo defaults write com.apple.AdLib allowIdentifierForAdvertising -bool false;
    sudo defaults write com.apple.AdLib personalizedAdsMigrated -bool false;
};

function configure_mac_ui() {
    echo "finder: show hidden files by default";
    sudo defaults write com.apple.finder AppleShowAllFiles -bool true;

    echo "finder: dont show harddrive on desktop";
    sudo defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false;

    echo "finder: dont show tags section in sidebar";
    sudo defaults write com.apple.finder SidebarTagsSctionDisclosedState -bool false;

    echo "finder: dont show iCloud section in sidebar";
    sudo defaults write com.apple.finder SidebarShowingiCloudDesktop -bool false;
    sudo defaults write com.apple.finder SidebarShowingSignedIntoiCloud -bool false;

    echo "finder: show devices section in sidebar";
    sudo defaults write com.apple.finder SidebarDevicesSectionDisclosedState -bool true;

    echo "finder: show places section in sidebar";
    sudo defaults write com.apple.finder SidebarPlacesSectionDisclosedState -bool true;

    echo "finder: new window opens to home directory"
    sudo defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/";

    echo "dock: remove everything pinned";
    sudo defaults write com.apple.dock persistent-apps -array;

    echo "dock: disable pinning";
    sudo defaults write com.apple.dock static-only -bool true;

    echo "dock: autohide on";
    sudo defaults write com.apple.dock autohide -bool true;

    echo "dock: setting size to smallish";
    sudo defaults write com.apple.dock tilesize 36;

    sudo killall Dock;
};


function configure_mac_user() {
    echo "configuring ui";
    configure_mac_ui;

    echo "installing VSCode Extensions"
    xargs code --install-extension < extensions.vscode;
}