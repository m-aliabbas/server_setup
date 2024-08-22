#!/bin/bash

# Function to check the last command's exit status and exit if it failed
check_last_command() {
    if [ $? -ne 0 ]; then
        echo "Error encountered. Exiting."
        exit 1
    fi
}

# Function to force pull the latest version of a repository
force_pull_latest_version() {
    local dir=$1
    if [ -d "$dir" ]; then
        echo "Force pulling the latest version for $dir..."
        cd "$dir"
        git fetch origin
        git reset --hard origin/main
        check_last_command
        cd ..
    else
        echo "Directory $dir does not exist. Skipping..."
    fi
}

# Force pull the latest versions from GitHub
force_pull_latest_version "whisper"
force_pull_latest_version "idrak_fe_nlu"
force_pull_latest_version "bot_nlu"

echo "All repositories have been force-updated to the latest version."
