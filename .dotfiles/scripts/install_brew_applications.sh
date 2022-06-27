#!/bin/bash

cut -f 1 -d ' ' ../installed/brew-applications | xargs -n 1 brew install;
