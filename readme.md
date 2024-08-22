# Server Setup

This repository contains a set of scripts designed to automate the setup, execution, and updating of tmux sessions and related repositories. These scripts streamline the management of tmux sessions, Conda environments, and GitHub repositories, ensuring a consistent and efficient workflow.

## Repository Structure

```bash
.
├── runner.sh                       # Script to run tmux sessions for various services
├── setup_and_run_with_checks.sh    # Script to set up environments, install dependencies, and start tmux sessions with error checking
└── updater.sh                      # Script to close tmux sessions and force pull the latest changes from GitHub repositories

1. runner.sh

    Purpose: This script is responsible for starting tmux sessions for your services (rasa, whisper, and nlu) and running the necessary commands within each session.
    Usage: Run this script after setting up your environment with setup_and_run_with_checks.sh to start your tmux sessions.

2. setup_and_run_with_checks.sh

    Purpose: This script automates the setup process, including:
        Installing necessary packages (libsndfile1 and nvtop) if they are not already installed.
        Setting up Conda environments.
        Starting tmux sessions and running specified commands with error handling.
    Usage: Run this script first to ensure that all dependencies are installed and tmux sessions are set up correctly.

3. updater.sh

    Purpose: This script closes any running tmux sessions related to your services, then force-pulls the latest changes from GitHub repositories. It ensures that your local repositories are up-to-date with the remote branches.