#!/bin/bash

UNTRACKED_FILES=$(./list_untracked_projects.sh);
COUNT=$(echo "$UNTRACKED_FILES" | wc -l);

if [ "$COUNT" -gt 0 ];
then
    echo "$COUNT untracked items found in projects directory:";
    echo "$UNTRACKED_FILES"
fi;
