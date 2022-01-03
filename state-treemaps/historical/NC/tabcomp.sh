#!/bin/bash
declare -i fin=$2
fin=fin-1
for i in `seq 1 $fin`;
do awk -v i=$i -v n=$2 'NR % n == i {print $1}' $1 > $i.tmp; done
awk -v n=$2 'NR % n == 0 {print $1}' $1 > $2.tmp
STR=""
for i in `seq 1 $2`; 
do STR=$STR""$i".tmp "; done
paste $STR > new$1
rm *.tmp
rm $1; mv new$1 $1
