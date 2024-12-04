#!/bin/bash

for file in *.depth; do
    awk '{$1=$1; print}' OFS='\t' "$file" > "${file%.depth}_tab.depth"
done
