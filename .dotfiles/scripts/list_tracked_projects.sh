#!/bin/bash

# get all directories in projects dir, for each dir check if it is a git repo (or a subdir of a repo) and if true return its absolute path;
ls -1d "$HOME"/projects/*/ | xargs -I {} git -C {} rev-parse {} 2>/dev/null;
