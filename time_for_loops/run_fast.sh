#!/bin/bash

# Exit on error
set -e

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_ROOT="$( dirname "$SCRIPT_DIR" )"
ENV_NAME="prog_perf_env"

# Check if ready file exists
if [ ! -f "$SCRIPT_DIR/ready" ]; then
    echo "Environment not ready. Running setup..."
    "$PROJECT_ROOT/common_setup/setup_ut.sh"
fi

# Build
mkdir -p "$SCRIPT_DIR/build"
cd "$SCRIPT_DIR/build"

echo "--- System Information ---"
uname -a
if command -v lscpu &> /dev/null; then
    lscpu | grep -E "Model name|CPU\(s\)|Thread\(s\) per core|Core\(s\) per socket"
fi
echo "--------------------------"

echo "Configuring and building..."
"$PROJECT_ROOT/common_setup/run_in_env.sh" cmake ..
"$PROJECT_ROOT/common_setup/run_in_env.sh" make -j$(nproc)

# Run benchmarks
echo "Running fast benchmarks..."
"$PROJECT_ROOT/common_setup/run_in_env.sh" ./loop_benchmarks --benchmark_filter=".*_Fast" --benchmark_color=true
