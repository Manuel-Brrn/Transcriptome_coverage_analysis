# Reciprocal BLAST Pipeline for Contig Correspondence

Pipeline to identify corresponding contigs between two species using reciprocal BLAST (Reciprocal Best Hits, RBH).
It align and compare contigs from different species and determine the best matches based on sequence similarity and alignment statistics.

## Features

    Perform BLASTN between two species’ contigs.
    Identify reciprocal best hits (RBH) for robust contig correspondence.
    Flexible input parameters for e-value thresholds and output formats.
    Compatible with large datasets of contigs in FASTA format.
    Automated post-processing for cleaner and more interpretable results.

## Requirements

   ### Software:
        BLAST+ (v2.9.0 or later)
        Python (v3.6 or later) for the reciprocal_best_hits.py script
  ### Input:
        Two FASTA files containing contigs from the two species to compare.

## Pipeline Workflow
## 1. Prepare Input Data

    Place the contig sequences for each species in separate FASTA files:
        species1.fasta (e.g., Species A)
        species2.fasta (e.g., Species B)

## 2. Perform BLASTN

Run BLASTN in both directions to compare contigs from the two species:

        blastn -query species1.fasta -subject species2.fasta -evalue 1e-50 -out species1_vs_species2.tab -outfmt 6 -num_threads 8
        blastn -query species2.fasta -subject species1.fasta -evalue 1e-50 -out species2_vs_species1.tab -outfmt 6 -num_threads 8

Output:

    species1_vs_species2.tab : Alignements de contigs de l'espèce 1 contre l'espèce 2.
    species2_vs_species1.tab : Alignements de contigs de l'espèce 2 contre l'espèce 1.

## 3. Identify Reciprocal Best Hits (RBH)

Use the provided Python script to find the best reciprocal matches:

        python reciprocal_best_hits.py species1_vs_species2.tab species2_vs_species1.tab 1 2 11 low RBH.tab

    Inputs:
        species1_vs_species2.tab: BLAST results for Species A vs. Species B.
        species2_vs_species1.tab: BLAST results for Species B vs. Species A.

    Outputs:
        RBH.tab: List of reciprocal best hits between the two species.
Tab-delimited file containing pairs of contigs with the strongest reciprocal alignments.
    Example output columns:
        Query contig ID
        Subject contig ID
        Percentage identity
        Alignment length
        E-value
        Bit score
