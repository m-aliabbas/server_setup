#!/bin/bash

# Function to check the last command's exit status and exit if it failed
check_last_command() {
    if [ $? -ne 0 ]; then
        echo "Error encountered. Exiting."
        exit 1
    fi
}

# Function to check and install a package if not already installed
install_package_if_missing() {
    local package=$1
    if ! dpkg -l | grep -q "^ii  $package "; then
        echo "$package is not installed. Installing..."
        sudo apt-get install -y $package
        check_last_command
    else
        echo "$package is already installed."
    fi
}

# Update package list
echo "Updating package list..."
sudo apt-get update
check_last_command

# Install necessary packages
install_package_if_missing "libsndfile1"
install_package_if_missing "nvtop"

# Source Conda environment setup script
source $(conda info --base)/etc/profile.d/conda.sh

# Function to kill an existing tmux session if it exists
kill_tmux_session_if_exists() {
    local session_name=$1
    if tmux has-session -t $session_name 2>/dev/null; then
        echo "Killing existing tmux session: $session_name"
        tmux kill-session -t $session_name
        check_last_command
    fi
}

# Start the tmux session for Rasa
kill_tmux_session_if_exists "rasa"
echo "Starting tmux session for Rasa..."
tmux new-session -d -s rasa
check_last_command
tmux send-keys -t rasa "cd $(pwd)/idrak_fe_nlu && conda activate rasa_env && rasa run -m models/nlu-20240229-181007-intense-javanese.tar.gz --enable-api --port 9097" C-m
tmux detach -s rasa

# Start the tmux session for Whisper
kill_tmux_session_if_exists "whisper"
echo "Starting tmux session for Whisper..."
tmux new-session -d -s whisper
check_last_command
tmux send-keys -t whisper "cd $(pwd)/whisper/WTranscriptor && conda activate whisper_env && gunicorn server:app --workers 12 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:9004" C-m
tmux detach -s whisper

# Start the tmux session for NLU
kill_tmux_session_if_exists "nlu"
echo "Starting tmux session for NLU..."
tmux new-session -d -s nlu
check_last_command
tmux send-keys -t nlu "cd $(pwd)/bot_nlu && conda activate whisper_env && python server.py" C-m
tmux detach -s nlu

echo "Tmux sessions started and detached successfully."
