#!/bin/bash
#SBATCH --job-name=Blast_sp
#SBATCH --output=./log_%j_%x_out.txt
#SBATCH --error=./log_%j_%x_err.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=2G
#SBATCH --time=4:00:00
#SBATCH --partition=agap_long


# Load required modules
module load bioinfo-cirad
module load blast/marmadais

# Define input FASTA file paths
path_species="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/data_RNAseq/Reference_individuals_fasta"

species_1="$path_species/New_T_urartu_Tr246_URA09.fasta"
species_2="$path_species/New_Ae_speltoides_Tr290_SPE10.fasta"
output_dir="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/Blast/urartu_speltoides"

species_1="$path_species/New_T_urartu_Tr246_URA09.fasta"
species_2="$path_species/New_Ae_speltoides_Tr290_SPE10.fasta"

# Run BLASTn for reciprocal alignments
blastn -query $species_1 -subject $species_2 -evalue 1e-50 -out $output_dir/species1_vs_species2.tab -outfmt 6 -num_threads 8
blastn -query $species_2 -subject $species_1 -evalue 1e-50 -out $output_dir/species2_vs_species1.tab -outfmt 6 -num_threads 8


# output blastn:
# 1.     qseqid          query (e.g., gene) sequence id
# 2.     sseqid          subject (e.g., reference genome) sequence id
# 3.     pident          percentage of identical matches
# 4.     length          alignment length
# 5.     mismatch        number of mismatches
# 6.     gapopen         number of gap openings
# 7.     qstart          start of alignment in query
# 8.     qend    end of alignment in query
# 9.     sstart          start of alignment in subject
# 10.    send    end of alignment in subject
# 11.    evalue          expect value
# 12.    bitscore        bit score
