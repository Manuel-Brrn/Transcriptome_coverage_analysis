README for BLAST Analysis Script
Script Name:

Blast_Tr_speltoides_LI.sh
Description:

This script performs reciprocal BLAST analysis for transcriptome data. It compares transcript sequences between two datasets to identify overlaps and calculate sequence similarity statistics. The results are saved in a formatted table for further analysis.
Usage
Prerequisites:

    SLURM Workload Manager: The script is designed to run on a SLURM-managed cluster.
    Modules Required:
        bioinfo-cirad
        seqkit (version 2.8.1)
        seqtk (version 1.3-r106)
    BLAST+: Ensure BLAST+ tools are installed in a conda environment (blast_env).
    Input Files:
        A Reciprocal Best Hit (RBH) file containing two columns (A_id and B_id) for sequence IDs from transcriptomes A and B.
        Fasta files of transcriptomes A and B.

Input File Details:

    RBH File: Tab-delimited file (RBH_TrEx_TrMo_speltoides.tab) with the following structure:

    A_id    B_id
    seqA1   seqB1
    seqA2   seqB2
    ...

    Transcriptomes: Fasta files for transcriptomes A and B with the sequences referenced in the RBH file.

Outputs:

    A directory containing BLAST results and temporary files for each sequence pair.
    A summary table with sequence statistics:

    Pair_Name   Ratio_A    Ratio_B    Positive_A    Positive_B    Length_A    Length_B

Running the Script
1. Submit the Script Using SLURM

Run the script on a SLURM-based cluster by submitting it as a batch job:

sbatch Blast_Tr_speltoides_LI.sh

2. Script Parameters

Ensure the following parameters in the script are correctly set before running:

    RBH_FILE: Path to the RBH file.
    TRANSCRIPTOME_A: Path to the transcriptome A fasta file.
    TRANSCRIPTOME_B: Path to the transcriptome B fasta file.
    OUTPUT_DIR: Directory where results will be saved.
    OUTPUT_TABLE: Path to the final summary table.

Script Workflow

    Initialize Environment:
        Load required modules.
        Prepare output directories and initialize the results table with headers.

    Extract Sequences:
        For each pair of IDs in the RBH file, retrieve sequences from transcriptome A and B using seqtk.

    Sequence Statistics:
        Calculate sequence lengths using seqkit.

    BLAST Execution:
        Perform BLASTn on both pairs (A vs B and B vs A) with an e-value threshold of 1e-50.
        Extract the number of positive matches for each BLAST for the best hsp.

    Ratio Calculation:
        Compute the ratio of positive matches to the sequence length for both A and B.

    Save Results:
        Append pair statistics to the results table.

    Cleanup:
        Remove temporary files after processing each pair.

Expected Output
Directory Structure:

/path/to/OUTPUT_DIR/
├── blast_pair_<A_id>_<B_id>.tab    # BLAST results for A vs B
├── blast_pair_<B_id>_<A_id>.tab    # BLAST results for B vs A
├── pair_<A_id>.fasta               # Sequence file for A
├── pair_<B_id>.fasta               # Sequence file for B
└── overlap_results_table_LI_2022.txt  # Summary table

Summary Table Format:

Pair_Name   Ratio_A    Ratio_B    Positive_A    Positive_B    Length_A    Length_B
seqA1_seqB1 0.85       0.90       170          180           200         200
...
