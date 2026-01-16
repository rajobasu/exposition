#!/bin/bash

# This script runs a command inside the specified conda environment.
# Usage: ./run_in_env.sh <command> [args...]

ENV_NAME="prog_perf_env"

# Check if conda is available
if ! command -v conda &> /dev/null; then
    echo "Error: conda not found."
    exit 1
fi

# Run the command using conda run
# --no-capture-output ensures that stdout/stderr are connected to the terminal (preserving color)
conda run --no-capture-output -n "$ENV_NAME" "$@"
