#!/bin/bash


comm -23 <(ls -1dp "$HOME"/projects/* | sort)  <(./list_tracked_projects.sh | sort) | grep -v "workspace.code-workspace";