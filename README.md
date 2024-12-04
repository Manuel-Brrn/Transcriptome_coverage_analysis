# Script 1
## Obtenir la depth par position

### depth_per_position_TrEx.sh
Give the depth per position per individual, one file per individual

### depth_per_position_TrEx_all_individuals.sh
Give the depth per position on each position for all individuals, create one file

# Script 2
## Traitement des individus ayant plusieurs fichiers
### sum_individuals_01_00.sh
sum the two bams corresponding to one individual

## Formattage pour obtenir une table avec tous les individus 
### add_tab.sh
Rajoute une tab entre chaque colonne

### add_depth_column_individuals
Colle la colonne depth de tous les individus dans un même fichier

covered_positions.sh
retain all position where at least 7 individuals have 10 reads
and create a table with number of position covered per contig and the % it represent

mean_depth_per_position_covered.sh
create a table with the mean depth per position covered

percentage_coverage.sh
create a table with the number of contigs covered by 10 to 100% (step of 10%) of positon with at least 10 reads for 7 individuals

calcul_nbr_positions_covered_per_contigs_per_depth.sh
create a table with the number of position covered per depth treshold for each contigs

add_non_covered_contigs.sh
add the contigs without any positions covered

delete_duplicates.sh
delete contigs duplicated added with precedent script

order_contigs.sh
sort the contigs in the same order than initially

add_column_total_position.sh
add the column of the total number of position per contig

table_number_contigs_per_depth_coverage.sh
create a table giving the number of contigs covered by x% of position with at least 10 reads on 7 individuals, at x depth

