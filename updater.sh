#!/bin/bash

# Function to check the last command's exit status and exit if it failed
check_last_command() {
    if [ $? -ne 0 ]; then
        echo "Error encountered. Exiting."
        exit 1
    fi
}

# Function to kill an existing tmux session if it exists
kill_tmux_session_if_exists() {
    local session_name=$1
    if tmux has-session -t $session_name 2>/dev/null; then
        echo "Killing existing tmux session: $session_name"
        tmux kill-session -t $session_name
        check_last_command
    else
        echo "Tmux session $session_name does not exist. Skipping..."
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

# Kill tmux sessions related to the repositories
kill_tmux_session_if_exists "rasa"
kill_tmux_session_if_exists "whisper"
kill_tmux_session_if_exists "nlu"

# Force pull the latest versions from GitHub
force_pull_latest_version "whisper"
force_pull_latest_version "idrak_fe_nlu"
force_pull_latest_version "bot_nlu"

echo "All tmux sessions have been killed and repositories force-updated to the latest version."
