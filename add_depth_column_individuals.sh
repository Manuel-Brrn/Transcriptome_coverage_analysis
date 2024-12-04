#!/bin/bash

paste -d '\t' \
     Tr206_GATCAG_L002_tab.depth \
     <(cut -f3 Tr207_TAGCTT_L002_tab.depth) \
     <(cut -f3 Tr232_TTAGGC_L003_tab.depth) \
     <(cut -f3 Tr235_TGACCA_L003_tab.depth) \
     <(cut -f3 Tr245_GATCAG_L003_tab.depth) \
     <(cut -f3 Tr246_TAGCTT_L003_tab.depth) \
     <(cut -f3 Tr304_CTTGTA_L004_tab.depth) \
     <(cut -f3 Tr306_ATCACG_L005_tab.depth) \
     <(cut -f3 Tr307_CGATGT_L005_tab.depth) \
     <(cut -f3 Tr309_TTAGGC_L005_tab.depth) \
     <(cut -f3 Tr312_TGACCA_L005_tab.depth) \
     <(cut -f3 Tr315_ACAGTG_L005_tab.depth) \
     <(cut -f3 Tr317_GCCAAT_L005_tab.depth) \
     <(cut -f3 Tr318_CAGATC_L005_tab.depth) \
     <(cut -f3 Tr347_CGATGT_L006_tab.depth) \
     <(cut -f3 Tr348_TTAGGC_L006_tab.depth) \
     <(cut -f3 Tr349_TGACCA_L006_tab.depth) > merged.depth

