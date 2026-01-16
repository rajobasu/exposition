#!/bin/bash

# Exit on error
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$SCRIPT_DIR" )"

if [ -z "$1" ]; then
    echo "Usage: ./plot_results.sh <csv_file>"
    exit 1
fi

CSV_FILE="$1"

if [ ! -f "$CSV_FILE" ]; then
    echo "Error: File $CSV_FILE not found."
    exit 1
fi

echo "Generating plot for $CSV_FILE..."
"$PROJECT_ROOT/common_setup/run_in_env.sh" python "$PROJECT_ROOT/common_setup/plot_benchmarks.py" "$CSV_FILE"
