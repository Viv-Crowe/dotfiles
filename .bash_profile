#!/bin/bash

# Supress MacOS Warning
export BASH_SILENCE_DEPRECATION_WARNING=1

# Set Default Editor

if command -v code &> /dev/null
then
    EDITOR='code'
elif command -v nano &> /dev/null
then
    EDITOR='nano'
else
    EDITOR='vi'
fi

export EDITOR

# Shortcuts

## Favourite Directories
alias p="cd ~/Projects"

## Git
alias s="git status"
alias ss="git add --all"
alias sss="git commit -m 'changes' && git push"

## Reset Terminal
alias reload='source ~/.bash_profile'
alias c="clear && clear"

# Colors
export force_color_prompt=yes
