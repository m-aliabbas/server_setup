#!/bin/bash

# Function to check the last command's exit status and exit if it failed
check_last_command() {
    if [ $? -ne 0 ]; then
        echo "Error encountered. Exiting."
        exit 1
    fi
}

# Source Conda environment setup script
source $(conda info --base)/etc/profile.d/conda.sh

# Start the tmux session for Rasa
echo "Starting tmux session for Rasa..."
tmux new-session -d -s rasa
check_last_command
tmux send-keys -t rasa "cd $(pwd)/idrak_fe_nlu && conda activate rasa_env && rasa run -m models/nlu-20240229-181007-intense-javanese.tar.gz --enable-api --port 9097" C-m
tmux detach -s rasa

# Start the tmux session for Whisper
echo "Starting tmux session for Whisper..."
tmux new-session -d -s whisper
check_last_command
tmux send-keys -t whisper "cd $(pwd)/whisper/WTranscriptor && conda activate whisper_env && gunicorn server:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:9004" C-m
tmux detach -s whisper

# Start the tmux session for NLU
echo "Starting tmux session for NLU..."
tmux new-session -d -s nlu
check_last_command
tmux send-keys -t nlu "cd $(pwd)/bot_nlu && conda activate whisper_env && python server.py" C-m
tmux detach -s nlu

echo "Tmux sessions started and detached successfully."
