#!/bin/bash

# ------------------ Script: Contig Coverage Analysis ------------------
# This script performs two tasks:
# 1. Identifies contigs with coverage >= 50% and >= 70% from a given input file.
# 2. Counts how many of these contigs are among the best hits in a different file.
# ----------------------------------------------------------------------

# ----------- Configuration Section -----------

# Path to the input file with contig coverage information
# The file should have tab-separated values with at least 4 columns,
# where the 4th column represents the percentage of coverage for each contig.
input_file="path/to/countig_percenatge_covered_positions_4_individuals.txt"

# Output files for contigs with different coverage thresholds
output_file_50="path/to/contigs_covered_50_percent_or_more_4_individuals.txt"
output_file_70="path/to/contigs_covered_70_percent_or_more_4_individuals.txt"

# Paths to other input files for the second analysis
# File with contigs covered >= 70%
file_covered="path/to/contigs_covered_70_percent_or_more_speltoides_TrEx.txt"

# File with best-hit contigs (Reciprocal Best Hits or RBH)
file_best_hits="path/to/RBH_TrEx_TrMo_speltoides_YANG.tab"

# Temporary files for intermediate processing
temp_covered_contigs="covered_contigs.txt"
temp_best_hit_contigs="best_hit_contigs.txt"

# ----------- Step 1: Filter Contigs by Coverage -----------

echo "Step 1: Filtering contigs by coverage thresholds (50% and 70%)."

# Extract contigs with at least 50% coverage
awk '$4 >= 50 {print $1}' "$input_file" > "$output_file_50"

# Extract contigs with at least 70% coverage
awk '$4 >= 70 {print $1}' "$input_file" > "$output_file_70"

# Display a preview of the results
echo "Contigs with at least 50% coverage:"
head "$output_file_50"

echo "Contigs with at least 70% coverage:"
head "$output_file_70"

# ----------- Step 2: Count Matching Contigs in Best Hits -----------

echo "Step 2: Counting matching contigs in the best-hit file."

# Extract the first column (contig names) from the file of covered contigs
awk '{print $1}' "$file_covered" > "$temp_covered_contigs"

# Extract the first column (best-hit contigs) from the RBH file
awk '{print $1}' "$file_best_hits" > "$temp_best_hit_contigs"

# Find the common contigs between the two lists and count matches
matches=$(comm -12 <(sort "$temp_covered_contigs") <(sort "$temp_best_hit_contigs") | wc -l)

# Output the result
echo "Number of matching contigs between covered contigs and best hits: $matches"

# ----------- Cleanup Temporary Files -----------

# Uncomment the line below to remove temporary files after running the script
# rm -f "$temp_covered_contigs" "$temp_best_hit_contigs"

echo "Script completed successfully!"
