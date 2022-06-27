#!/bin/bash

cut -f 1 -d '@' ../installed/vscode-extensions | xargs -n 1 code --install-extension;
