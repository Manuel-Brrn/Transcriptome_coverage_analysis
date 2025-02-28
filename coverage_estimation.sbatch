#!/bin/bash
#SBATCH --job-name=coverage_bams_no_soft_clipped_reads
#SBATCH --output=/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/BAM_cleaned/Bams_no_soft_clipped_reads/log_%j_%x_out.txt
#SBATCH --error=/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/BAM_cleaned/Bams_no_soft_clipped_reads/log_%j_%x_err.txt
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --mem=9G
#SBATCH --time=8:00:00
#SBATCH --partition=agap_normal

# Define input and output paths
BAM_DIR="/home/barrientosm/projects/GE2POP/2024_TRANS_CWR/2024_MANUEL_BARRIENTOS/02_results/BAM_cleaned/Bams_no_soft_clipped_reads"
OUTPUT="coverage_per_sample.txt"
REF_FASTA="/home/barrientosm/scratch/GeCKO/Refs/urartu/urartu_transcriptome.fasta"
READ_LENGTH=125

module load bioinfo-cirad
module load seqkit/2.8.1

# Get the total reference length (sum of all contig lengths)
REF_LENGTH=$(seqkit stats $REF_FASTA | awk 'NR==2 {print $5}' | tr -d ',')  # Extracts total length and removes commas

# Check if reference length was retrieved successfully
if [[ -z "$REF_LENGTH" ]]; then
    echo "Error: Could not retrieve reference length."
    exit 1
fi

echo "Total Reference Length: $REF_LENGTH"

# Write header to output file
echo -e "Sample\tReads_mapped\tAverage_Coverage" > $OUTPUT

# Loop through each BAM file in the directory
for BAM in $BAM_DIR/*.bam; do
    # Extract sample name from BAM file name
    SAMPLE=$(basename $BAM .bam)

    # Count mapped reads using samtools
    READS=$(samtools view -c -F 4 $BAM)  # -F 4 excludes unmapped reads

    # If no reads are mapped, set READS to 0
    if [[ -z "$READS" ]]; then
        READS=0
    fi

    # Calculate average coverage: (reads * read length) / reference length
    COV=$(awk -v reads=$READS -v rlen=$READ_LENGTH -v len=$REF_LENGTH 'BEGIN {printf "%.4f", (reads * rlen) / len}')

    # Print sample statistics to the console
    echo "Sample: $SAMPLE, Reads Mapped: $READS, Read Length: $READ_LENGTH, Reference Length: $REF_LENGTH, Coverage: $COV"

    # Append sample statistics to the output file
    echo -e "$SAMPLE\t$READS\t$COV" >> $OUTPUT
done

# Print completion message
echo "Coverage calculation complete. Results saved in $OUTPUT."
