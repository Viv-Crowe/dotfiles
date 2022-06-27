#!/bin/bash

# $1 - github username
echo "enabling ssh for GitHub"
cat ../configs/ssh >> "$HOME/.ssh/config";
sed -i -e "s/GITHUB_USERNAME/$1/g" "$HOME/.ssh/config";
echo "make sure $HOME/.ssh/id_ed25519.pub is added to your github account";