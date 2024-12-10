#!/bin/bash
#SBATCH --job-name=Best_hit
#SBATCH --output=./log_%j_%x_out.txt
#SBATCH --error=./log_%j_%x_err.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=2G
#SBATCH --time=4:00:00
#SBATCH --partition=agap_long

cd /home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/Blast/urartu_speltoides

# Load required modules
module load bioinfo-cirad
module load python/packages/3.9.13

# path
path_input="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/Blast/urartu_speltoides"
output_dir="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/Blast/urartu_speltoides"

python reciprocal_best_hits.py $path_input/species1_vs_species2.tab $path_input/species2_vs_species1.tab 1 2 11 $output_dir/low RBH.tab
