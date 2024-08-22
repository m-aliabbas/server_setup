#!/bin/bash

# Function to check the last command's exit status and exit if it failed
check_last_command() {
    if [ $? -ne 0 ]; then
        echo "Error encountered. Exiting."
        exit 1
    fi
}

# Prompt the user for the GitHub token
read -sp "Enter your GitHub Personal Access Token: " GITHUB_TOKEN
echo ""

# Export GitHub token for private repository access
export GIT_ASKPASS=$(mktemp)

cat <<EOF >$GIT_ASKPASS
#!/bin/bash
echo \$GITHUB_TOKEN
EOF

chmod +x $GIT_ASKPASS

# Clone the private repositories
echo "Cloning repositories..."
git clone https://m-aliabbas:${GITHUB_TOKEN}@github.com/m-aliabbas/whisper.git
check_last_command

git clone https://m-aliabbas:${GITHUB_TOKEN}@github.com/m-aliabbas/idrak_fe_nlu.git
check_last_command

git clone https://m-aliabbas:${GITHUB_TOKEN}@github.com/m-aliabbas/bot_nlu.git
check_last_command

# Clean up
unset GITHUB_TOKEN
rm $GIT_ASKPASS

# Create Conda environments
echo "Creating Conda environments..."
conda create -n whisper_env python=3.10 -y
check_last_command

conda create -n rasa_env python=3.10 -y
check_last_command

# Activate and install requirements for whisper_env
echo "Installing requirements for whisper_env..."
source $(conda info --base)/etc/profile.d/conda.sh
conda activate whisper_env
pip install -r whisper/requirements.txt
check_last_command
conda deactivate

# Activate and install rasa for rasa_env
echo "Installing Rasa for rasa_env..."
conda activate rasa_env
pip install rasa
check_last_command
conda deactivate

# Create and run tmux sessions with the specified commands
# Rasa tmux session
echo "Starting tmux sessions..."
tmux new-session -d -s rasa -c "idrak_fe_nlu" "conda activate rasa_env && rasa run -m models/nlu-20240229-181007-intense-javanese.tar.gz --enable-api --port 9097"
check_last_command

# Whisper tmux session
tmux new-session -d -s whisper -c "whisper" "conda activate whisper_env && gunicorn server:app --workers 4 --worker-class uvicorn.workers.UvicornWorker --bind 0.0.0.0:9004"
check_last_command

# NLU tmux session
tmux new-session -d -s nlu -c "bot_nlu" "conda activate whisper_env && python server.py"
check_last_command

echo "Repositories cloned, Conda environments created, tmux sessions started, and commands executed successfully."
