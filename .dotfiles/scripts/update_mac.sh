#!/bin/bash

# sudo softwareupdate --list; # List available packages
# sudo softwareupdate --download; # Download only
sudo softwareupdate --background --install --all --restart; # --recommended OR --os-only