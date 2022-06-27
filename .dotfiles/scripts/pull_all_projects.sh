#!/bin/bash

# attempt to pull all project repos
./list_tracked_projects.sh | xargs -I {} git -C {} pull;