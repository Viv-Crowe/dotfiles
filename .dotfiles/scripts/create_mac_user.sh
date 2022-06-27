#!/bin/bash
# $1 - username
# $2 - User Name
# $3 - user password
echo "creating user with non-admin privileges";
sudo sysadminctl -addUser "$1" -fullName "$2" -password "$3" -home "/Users/$1"; # [-admin] [-picture <full path to user image>]
echo "setting bash as default shell";
sudo chsh /bin/bash "$1";
