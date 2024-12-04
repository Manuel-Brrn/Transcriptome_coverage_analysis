#!/bin/bash
# Fichiers d'entrée et de sortie
file_counts="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/countig_percentage_covered_positions.txt"
file_depth="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/number_position_per_depth_per_contig_no_duplicates.txt"
output_file="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/number_position_per_depth_per_contig_sorted.txt"
# Extraire les contigs du fichier counts et les mettre dans un tableau
contigs_order=$(awk 'NR > 1 {print $1}' "$file_counts")
# Créer un fichier de sortie en écrivant d'abord l'entête du fichier depth
head -n 1 "$file_depth" > "$output_file"
# Réorganiser les contigs du fichier depth selon l'ordre de counts
for contig in $contigs_order; do
    # Extraire et ajouter la ligne correspondante de file_depth dans le même ordre
    awk -v contig="$contig" '$1 == contig {print $0}' "$file_depth" >> "$output_file"
done
echo "Les contigs ont été réorganisés et enregistrés dans $output_file"
