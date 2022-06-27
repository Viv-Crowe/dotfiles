# Dotfiles

This repository automates all provisioning, configuration, backup and versioning tasks
related to all linux or macOS systems under my control. It provides many features:

- full configuration of a brand new MacOS system (see `scripts/*mac*.sh`)
- tracking of every application or package on every machine.
- backup and sync of all dotfiles, config, addons and extensions on every system.
- automated backup and updates

## Forking

Before running the installation instructions, I recommend forking this repo and changing the url below to point to your own repo. Another url to change is in the `provision_mac.sh` script.

## Installation

1. Make sure you have git installed. On MacOS, run: `sudo xcode-select --install;`
2. run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/DragosRotaru/dotfiles/master/.dotfiles/install.sh)"`
3. run `provision_mac.sh <username> <User Name> <password>`

## Next Steps

These are things I have not automated yet or cannot automate:

### Security and Privacy

- setup VPN
- setup firewall (Lulu, Little Snitch, etc)
- set inactivity logout/sleep settings
- make sure location services are disabled
- double check settings to make sure they applied to both users

### UI

- turn on dark mode
- turn on night shift
- show battery percentage
- remove siri from touch bar
- limit spotlight search results

### Misc

Configure Firefox:

- copy user.js to FireFox profile folder: $HOME/Library/Application Support/Firefox/Profiles/xxxxx.default
- install extensions listed in .dotfiles/extensions.firefox
- set default web browser to Firefox (System Preferences > General)
- import your Bookmarks

Other software:

- install Quokka/Wallaby key: `install_wallaby_key <your_key>` (utilities.sh)
- install desired applications (see .dotfiles/applications.md)