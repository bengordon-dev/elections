#!/bin/bash
while read STATE; do    
FILE=$(echo $STATE | sed 's/ /_/g')
awk 'BEGIN{FS=","} NR == 1 {print $3, $6, $10}' 2020.csv > $FILE
awk -v state="$STATE" 'BEGIN{FS = ","; OFS=","}; $1 == state {print $3, $6, $10}' 2020.csv | sed 's/ County//g;s/ /_/g;s/,/ /g' | sort -k2 -nr >> $FILE
./treemap.py $FILE
rm $FILE
done <states.txt
