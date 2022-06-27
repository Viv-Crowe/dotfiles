#!/bin/bash

# Manage Downloads Folder
# count number of files in Downloads folder
DOWNLOADS_FOLDER_SIZE=$(ls -1dp "$HOME"/downloads/*  2>/dev/null | wc -l);
echo "$DOWNLOADS_FOLDER_SIZE files found in downloads folder";