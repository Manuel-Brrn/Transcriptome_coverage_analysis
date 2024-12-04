
#!/bin/bash
# Count the total number of lines in the 2nd file (excluding the header)
total_positions=$(($(wc -l < /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/depth_per_position_all_individuals.depth) - 1))
# Count the number of lines in the 1st file (excluding the header)
covered_positions=$(($(wc -l < /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/depth_per_position_covered_all_individuals.depth) - 1))
# Calculate the percentage of covered positions
percentage_covered=$(echo "scale=2; (${covered_positions}/${total_positions})*100" | bc)
# Generate a table with the results
output_file="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/number_covered_position.txt"
echo -e "total_positions\tcovered_positions\tpercentage_covered" > "${output_file}"
echo -e "${total_positions}\t${covered_positions}\t${percentage_covered}" >> "${output_file}"
