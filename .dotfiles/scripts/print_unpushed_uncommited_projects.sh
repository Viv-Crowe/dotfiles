#!/bin/bash

PROJECT_FOLDERS=$(./list_tracked_projects.sh);

# count number of unpushed commits
UNPUSHED_COMMITS=$(echo "$PROJECT_FOLDERS" | xargs -I {} git -C {} log --branches --not --remotes --oneline | wc -l);

# count number of uncommited changes
UNCOMMITED=$(echo "$PROJECT_FOLDERS" | xargs -I {} git -C {} diff --numstat --summary);
UNCOMMITED_INSERTS=$(echo "$UNCOMMITED" | cut -d $'\t' -f1 | awk '{s+=$1} END {print s}');
UNCOMMITED_DELETIONS=$(echo "$UNCOMMITED" | cut -d $'\t' -f2 | awk '{s+=$1} END {print s}');
UNCOMMITED_CHANGES=$((UNCOMMITED_INSERTS + UNCOMMITED_DELETIONS));

echo "$UNPUSHED_COMMITS unpushed commits and $UNCOMMITED_CHANGES uncommited changes found";