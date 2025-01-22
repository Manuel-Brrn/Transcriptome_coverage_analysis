#!/bin/bash
#SBATCH --job-name=Blast_Tr_speltoides_LI  # Job name
#SBATCH --output=./log_%j_%x_out.txt       # Standard output log
#SBATCH --error=./log_%j_%x_err.txt        # Standard error log
#SBATCH --nodes=1                          # Number of nodes
#SBATCH --ntasks-per-node=1                # Tasks per node
#SBATCH --mem=12G                          # Memory allocation
#SBATCH --time=20:00:00                    # Maximum runtime (HH:MM:SS)
#SBATCH --partition=agap_long              # Partition to use

# Load required modules
module load bioinfo-cirad
module load seqkit/2.8.1
module load seqtk/1.3-r106

# Define file paths
RBH_FILE="RBH_TrEx_TrMo_speltoides.tab"  # Reciprocal best hits file
TRANSCRIPTOME_A="/path/to/Transcriptome_A.fasta"  # Transcriptome A file
TRANSCRIPTOME_B="/path/to/Transcriptome_B.fasta"  # Transcriptome B file
OUTPUT_DIR="/path/to/output_directory"            # Directory to store outputs
OUTPUT_TABLE="$OUTPUT_DIR/overlap_results_table.txt"  # Summary output file

# Create the output directory if it doesn't exist
mkdir -p $OUTPUT_DIR

# Initialize the output table with headers
echo -e "Pair_Name\tRatio_A\tRatio_B\tPositive_A\tPositive_B\tLength_A\tLength_B" > "$OUTPUT_TABLE"

# Function to process each pair of sequences
perform_blast() {
    A_id=$1  # ID for sequence from Transcriptome A
    B_id=$2  # ID for sequence from Transcriptome B

    # Sanitize sequence IDs for file naming
    A_id_safe=$(echo "$A_id" | sed 's/|/_/g')
    B_id_safe=$(echo "$B_id" | sed 's/|/_/g')

    # Extract sequences for A and B
    A_seq=$(seqtk subseq "$TRANSCRIPTOME_A" <(echo "$A_id"))
    B_seq=$(seqtk subseq "$TRANSCRIPTOME_B" <(echo "$B_id"))

    # Check if sequences were successfully extracted
    if [[ -n "$A_seq" && -n "$B_seq" ]]; then
        # Define file paths for temporary sequence files
        output_file_A="$OUTPUT_DIR/pair_${A_id_safe}.fasta"
        output_file_B="$OUTPUT_DIR/pair_${B_id_safe}.fasta"

        # Write sequences to files
        echo "$A_seq" > "$output_file_A"
        echo "$B_seq" > "$output_file_B"

        # Calculate sequence lengths using seqkit
        A_length=$(seqkit stats "$output_file_A" | awk 'NR==2 {print $5}' | tr -d ',')
        B_length=$(seqkit stats "$output_file_B" | awk 'NR==2 {print $5}' | tr -d ',')

        # Activate Conda environment for BLAST
        source /path/to/conda.sh
        conda activate blast_env

        # Perform BLASTn for A vs B
        blastn -query "$output_file_A" -subject "$output_file_B" -evalue 1e-50 \
            -out "$OUTPUT_DIR/blast_pair_${A_id_safe}_${B_id_safe}.tab" \
            -outfmt "7 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore positive" \
            -num_threads 8 &

        # Perform BLASTn for B vs A
        blastn -query "$output_file_B" -subject "$output_file_A" -evalue 1e-50 \
            -out "$OUTPUT_DIR/blast_pair_${B_id_safe}_${A_id_safe}.tab" \
            -outfmt "7 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore positive" \
            -num_threads 8 &

        # Wait for BLAST to complete
        wait

        # Extract the "positive" alignment counts from BLAST results
        positive_A=$(awk '!/^#/ {print $13; exit}' "$OUTPUT_DIR/blast_pair_${A_id_safe}_${B_id_safe}.tab")
        positive_B=$(awk '!/^#/ {print $13; exit}' "$OUTPUT_DIR/blast_pair_${B_id_safe}_${A_id_safe}.tab")

        # Calculate ratios of positive alignments to sequence length
        if [[ -n "$positive_A" && -n "$positive_B" ]]; then
            positive_A_ratio=$(echo "scale=6; $positive_A / $A_length" | bc)
            positive_B_ratio=$(echo "scale=6; $positive_B / $B_length" | bc)

            # Append results to the output table
            echo -e "${A_id_safe}_${B_id_safe}\t$positive_A_ratio\t$positive_B_ratio\t$positive_A\t$positive_B\t$A_length\t$B_length" >> "$OUTPUT_TABLE"
        fi

        # Clean up temporary files
        rm -f "$output_file_A" "$output_file_B"
        rm -f "$OUTPUT_DIR/blast_pair_${A_id_safe}_${B_id_safe}.tab" "$OUTPUT_DIR/blast_pair_${B_id_safe}_${A_id_safe}.tab"
    else
        echo "Missing sequence for pair: A_id=$A_id, B_id=$B_id"
    fi
}

# Read and process each pair from the RBH file, skipping the header
tail -n +2 "$RBH_FILE" | while read -r line; do
    A_id=$(echo "$line" | awk '{print $1}')
    B_id=$(echo "$line" | awk '{print $2}')

    # Run the perform_blast function for each pair
    perform_blast "$A_id" "$B_id" &
done

# Wait for all background processes to complete
wait

echo "All BLAST analyses are complete. Results are saved in $OUTPUT_TABLE."
