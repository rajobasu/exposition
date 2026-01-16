#!/bin/bash

# Exit on error
set -e

# Check if conda is installed
if ! command -v conda &> /dev/null; then
    echo "Conda not found. Please install Miniconda or Anaconda."
    exit 1
fi

echo "Conda found. Setting up environment..."

# Directory of this script
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$SCRIPT_DIR" )"
TIME_FOR_LOOPS_DIR="$PROJECT_ROOT/time_for_loops"
ENV_NAME="prog_perf_env"

# Create or update conda environment
if conda env list | grep -q "$ENV_NAME"; then
    echo "Environment $ENV_NAME already exists. Updating..."
    conda install -n "$ENV_NAME" -y -c conda-forge --file "$TIME_FOR_LOOPS_DIR/requirements.txt"
else
    echo "Creating environment $ENV_NAME..."
    conda create -n "$ENV_NAME" -y -c conda-forge --file "$TIME_FOR_LOOPS_DIR/requirements.txt"
fi

# Create the ready file
touch "$TIME_FOR_LOOPS_DIR/ready"

echo "Setup complete. Environment '$ENV_NAME' is ready."
echo "To activate: conda activate $ENV_NAME"
