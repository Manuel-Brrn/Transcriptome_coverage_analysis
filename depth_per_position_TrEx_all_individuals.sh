#!/bin/bash

# Directory where the output will be saved
output_dir="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx"

# Change to the output directory
cd "$output_dir" || { echo "Failed to change directory to $output_dir"; exit 1; }

# Load required modules
module load bioinfo-cirad
module load samtools/1.14-bin

# Path to the directory containing BAM files
bam_dir="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_Florent_Marchal/02_results/URARTU_TRANS_EX_NIHILO_Tr246_BWA/BAMS"

# File to store the combined depth output
combined_depth_file="${output_dir}/depth_per_position_all_individuals.depth"

# Find all BAM files in the directory and store them in an array
bam_files=("$bam_dir"/*.bam)

# Check if any BAM files were found
if [ ${#bam_files[@]} -eq 0 ]; then
    echo "No BAM files found in directory: $bam_dir"
    exit 1
fi

# Create the header with "contig", "pos", and BAM filenames (without paths)
header="contig\tpos"
for bam_file in "${bam_files[@]}"; do
    header+="\t$(basename "$bam_file")"
done

# Write the header to the combined depth file
echo -e "$header" > "$combined_depth_file"

# Run samtools depth with all BAM files and append the output to the file
samtools depth -aa "${bam_files[@]}" >> "$combined_depth_file"

# Final message
echo "Depth calculation complete. Combined depth file with columns per individual saved to $combined_depth_file."
