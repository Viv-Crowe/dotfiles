#!/bin/bash

ssh_dir="$HOME/.ssh/";
echo "creating .ssh directory";
mkdir "$ssh_dir";

echo "generating an SSH key";
./ssh_gen.sh "$ssh_dir/id_ed25519";

echo "adding key to users authorized_keys";
cat "$ssh_dir/id_ed25519.pub" > "$ssh_dir/authorized_keys";

chmod 0700 "$ssh_dir";
