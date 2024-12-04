#!/bin/bash
# Chemin vers le répertoire contenant les fichiers de profondeur
depth_dir="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/depth_TrEx/depth_per_individual"
# Boucle sur chaque fichier *_00.depth dans le répertoire
for depth_file in "$depth_dir"/*_00.depth; do
    # Extraire le nom de base du fichier sans le suffixe '_00.depth' (ex : Tr245_GATCAG_L003 -> Tr245_GATCAG_L003)
    base_name=$(basename "$depth_file" "_00.depth")

    # Vérifier si le fichier correspondant *_01.depth existe
    file_01="$depth_dir/${base_name}_01.depth"
    if [ -f "$file_01" ]; then
        # Créer le fichier de sortie
        output_file="$depth_dir/${base_name}.depth"

        # Utilisation de paste et awk pour traiter les deux fichiers simultanément
        paste "$depth_file" "$file_01" | awk '{sum = $3 + $6; print $1, $2, sum}' > "$output_file"

        # Afficher un message indiquant que le fichier de profondeur sommée a été créé
        echo "Summed depth for $base_name saved to $output_file"
    fi
done
# Message indiquant que le processus de sommation est terminé
echo "Summing complete. Results saved to $depth_dir."
