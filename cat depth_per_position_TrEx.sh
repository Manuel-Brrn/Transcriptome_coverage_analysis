#!/bin/bash
# Path to the directory containing BAM files
bam_dir="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_Florent_Marchal/02_results/URARTU_TRANS_EX_NIHILO_Tr246_BWA/BAMS"
# Directory to store the depth files
depth_dir="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/depth_per_individual"
# Load required modules
module load bioinfo-cirad
module load samtools/1.14-bin
# Check if the BAM directory exists
if [ ! -d "$bam_dir" ]; then
    echo "BAM directory not found: $bam_dir"
    exit 1
fi
# Loop over each BAM file in the directory
for bam_file in "$bam_dir"/*.bam; do
    if [ -f "$bam_file" ]; then
        # Calculate the depth using samtools depth and store the result in a file, run in background
        samtools depth -aa "$bam_file" > "$depth_dir/$(basename "$bam_file" .bam).depth"
        # Print message indicating the file has been processed
        echo "Depth calculated for $bam_file"
    fi
done
# Wait for all background processes to complete
# Final message after all files are processed
echo "Depth calculation complete. Depth files saved to $depth_dir."
