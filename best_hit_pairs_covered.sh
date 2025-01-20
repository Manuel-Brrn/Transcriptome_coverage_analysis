#!/bin/bash

# ------------------- Script: Best-Hit Pair Coverage Analysis -------------------
# This script counts the number of best-hit pairs where both contigs are covered 
# by at least 50% in two different species.
# ------------------------------------------------------------------------------

# ----------- Configuration Section -----------

# Path to input files
# File with contigs covered at least 50% for species 1
file_covered_species1="path/to/contigs_covered_50_percent_or_more_speltoides_TrEx.txt"

# File with contigs covered at least 50% for species 2
file_covered_species2="path/to/contigs_covered_50_percent_or_more_TrMo_YANG_2023.txt"

# File containing the list of best-hit pairs (tab-separated format)
file_best_hits="path/to/contigs_speltoides_YANG_overlap_50.txt"

# Temporary files for intermediate processing
temp_covered_species1="covered_species1_contigs.txt"
temp_covered_species2="covered_species2_contigs.txt"
temp_sorted_species1="sorted_covered_species1.txt"
temp_sorted_species2="sorted_covered_species2.txt"
temp_sorted_best_hits="sorted_best_hit_pairs.txt"

# ----------- Step 1: Prepare Input Data -----------

echo "Step 1: Preparing input data for comparison."

# Extract contig names from species 1 file and sort
awk '{print $1}' "$file_covered_species1" > "$temp_covered_species1"
sort "$temp_covered_species1" > "$temp_sorted_species1"

# Extract contig names from species 2 file and sort
awk '{print $1}' "$file_covered_species2" > "$temp_covered_species2"
sort "$temp_covered_species2" > "$temp_sorted_species2"

# Sort the best-hit pairs file
sort "$file_best_hits" > "$temp_sorted_best_hits"

# ----------- Step 2: Count Matching Pairs -----------

echo "Step 2: Counting matching best-hit pairs."

# Initialize the counter for matching pairs
matching_pairs=0

# Loop through the sorted best-hit pairs file
while read -r line; do
    # Extract contigs for species 1 and 2 from the current line
    contig_species1=$(echo "$line" | awk '{print $1}')
    contig_species2=$(echo "$line" | awk '{print $2}')
    
    # Check if both contigs are covered in their respective species
    if grep -Fxq "$contig_species1" "$temp_sorted_species1" && grep -Fxq "$contig_species2" "$temp_sorted_species2"; then
        matching_pairs=$((matching_pairs + 1))
    fi
done < "$temp_sorted_best_hits"

# ----------- Step 3: Display Results -----------

# Print the number of matching best-hit pairs
echo "Number of best-hit pairs covered in both species at 50%: $matching_pairs"

# ----------- Cleanup Temporary Files -----------

# Uncomment the following line to delete temporary files after execution
# rm -f "$temp_covered_species1" "$temp_covered_species2" "$temp_sorted_species1" "$temp_sorted_species2" "$temp_sorted_best_hits"

echo "Script completed successfully!"
