#!/bin/bash

../scripts/update_mac.sh;
../scripts/update_brew.sh;
# TODO force update VS Code extensions and firefox addons
../scripts/update_mac_installed_lists.sh;
../scripts/sync_mac_dotfiles.sh;