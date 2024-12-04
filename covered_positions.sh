#!/bin/bash
# Fichiers dentres et de sortie
input_file="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/depth_per_individual/depth_per_position_all_individuals_BAMs_summed.depth"
filtered_output="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/depth_per_position_covered_all_individuals.depth"
count_output="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/countig_percentage_covered_positions.txt"

# Initialisation des fichiers de sortie
echo -e "contig\tpos\t$(head -1 "$input_file" | cut -f3-)" > "$filtered_output"
echo -e "Contig\tPositions_covered\tTotal_positions\tPercentage_covered" > "$count_output"

# Traitement avec awk
awk -v filtered="$filtered_output" -v counts="$count_output" '
BEGIN {
    OFS = "\t";
    current_contig = "";
    contig_count = 0;
    total_positions_per_contig = 0;
    total_filtered_positions = 0;
}
NR == 1 { next } # Ignorer la première igne
{
    contig = $1;
    pos = $2;
    count = 0;
    # Verifier combien dindividus ont une profondeur >= 10
    for (i = 3; i <= NF; i++) {
        if ($i >= 10) count++;
    }
    # Gestion des changements de contig
    if (contig != current_contig) {
        if (current_contig != "") {
            percentage = (contig_count / total_positions_per_contig) * 100;
            print current_contig, contig_count, total_positions_per_contig, percentage >> counts;
        }
        current_contig = contig;
        contig_count = 0;
        total_positions_per_contig = 0;
    }
    # Compter les positions totales et filtrees
    total_positions_per_contig++;
    if (count >= 7) {
        contig_count++;
        total_filtered_positions++;
        print $0 >> filtered;
    }
}
END {
    # ecriture des donnees pour le dernier contig
    if (current_contig != "") {
        percentage = (contig_count / total_positions_per_contig) * 100;
        print current_contig, contig_count, total_positions_per_contig, percentage >> counts;
    }
    print "Total filtered positions: " total_filtered_positions > "/dev/stderr";
}
' "$input_file"
