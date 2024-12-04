#!/bin/bash


awk 'NR==FNR{a[$1]=$3; next} {print $1, "\t", a[$1], "\t", $2, "\t", $3, "\t", $4, "\t", $5, "\t", $6, "\t", $7, "\t", $8, "\t", $9, "\t", $10, "\t", $11}' /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/countig_percentage_covered_positions.txt /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/number_position_per_depth_per_contig_sorted.txt > /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/number_position_per_depth_per_contig_sorted_with_total_positions.txt

