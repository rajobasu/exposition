import pandas as pd
import matplotlib.pyplot as plt
import sys
import os
import re

def plot_csv(csv_path):
    if not os.path.exists(csv_path):
        print(f"Error: File {csv_path} not found.")
        return

    # Read CSV, skipping the header lines if they exist (Google Benchmark CSVs usually have some info at the top)
    # Actually, Google Benchmark CSV format is usually straightforward but sometimes has a few lines of system info.
    # However, when redirected to a file with --benchmark_format=csv, it's usually just the CSV.
    try:
        df = pd.read_csv(csv_path)
    except Exception as e:
        print(f"Error reading CSV: {e}")
        return

    if 'name' not in df.columns or 'real_time' not in df.columns:
        print("Error: CSV does not have 'name' or 'real_time' columns.")
        return

    # Extract size from name (e.g., "BM_SimpleLoop_Full/16" -> 16)
    def extract_size(name):
        match = re.search(r'/(\d+)', name)
        if match:
            return int(match.group(1))
        return None

    df['size'] = df['name'].apply(extract_size)
    df = df.dropna(subset=['size'])
    df = df.sort_values('size')

    # Create a base name column for grouping (e.g., "DoWhile_Full/16" -> "DoWhile_Full")
    df['base_name'] = df['name'].apply(lambda x: x.split('/')[0])
    
    plt.figure(figsize=(12, 8))
    
    for base_name, group in df.groupby('base_name'):
        plt.plot(group['size'], group['real_time'], marker='o', linestyle='-', label=base_name)
    
    plt.xscale('log')
    plt.yscale('log')
    plt.xlabel('Input Size (log scale)')
    plt.ylabel('Time (ns) (log scale)')
    plt.title('Loop Comparison Benchmark')
    plt.grid(True, which="both", ls="-", alpha=0.5)
    plt.legend()

    output_plot = csv_path.replace('.csv', '.png')
    plt.savefig(output_plot)
    print(f"Plot saved to {output_plot}")
    
    # Try to show the plot if possible (might not work in all environments)
    # plt.show()

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python plot_benchmarks.py <path_to_csv>")
    else:
        plot_csv(sys.argv[1])
