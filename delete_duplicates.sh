 cat delete_duplicates.sh
#!/bin/bash

awk '!seen[$1]++' /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/number_position_per_depth_per_contig_all.txt > /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/number_position_per_depth_per_contig_no_duplicates.txt

