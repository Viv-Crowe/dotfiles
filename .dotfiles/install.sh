#! /bin/bash

# Download the dotfiles repo

git clone --bare https://github.com/DragosRotaru/dotfiles.git "$HOME/.cfg";

echo ".cfg" >> .gitignore;

git --git-dir="$HOME/.cfg/" --work-tree="$HOME" checkout;

# shellcheck disable=SC1091
source .bash_profile;

dotfiles config --local status.showUntrackedFiles no;