#!/bin/bash

YEAR=$1;
FILE=$YEAR; FILE+="_United_States_presidential_election";
PAGE="https://en.wikipedia.org/wiki/$FILE";
wget -nv $PAGE;
printf "\nInstances of results by state:\n";
grep -ni "Results by state" $FILE | cut -f1 -d:
grep -n "<tbody>" $FILE | cut -f1 -d: > temp1.tmp
grep -n "</tbody>" $FILE | cut -f1 -d: > temp2.tmp
paste temp1.tmp temp2.tmp | awk '{print $1, $2, $2-$1+1}' | sort -k3 -nr > tables.tmp
printf "\nLongest 4 tables:\n"
awk '{print NR, "Start:", $1, "End:", $2, "Length:", $3}' tables.tmp | head -n4
printf "\n"; echo "Select record number (-1 to abort): "; read;
if [ $REPLY -gt 0 ]
then
    NEWFILE="$YEAR".dat
    sed -n "$(awk -v l=$REPLY 'BEGIN{OFS=","} NR == l {print $1, $2}' tables.tmp)p" $FILE > $NEWFILE
    rm $FILE
    sed 's/ /_/g;s/<[^>]*>//g;/^$/d;s/,//g' $NEWFILE > $FILE

    printf "\nAlabama: "; FIRST=$(grep -ni "Alabama" $FILE | cut -f1 -d:); echo $FIRST;
    printf "Mississippi: "; MS=$(grep -ni "Mississippi" $FILE | cut -f1 -d:); echo $MS;
    printf "Missouri: "; MO=$(grep -ni "Missouri" $FILE | cut -f1 -d:); echo $MO;
    ROWS=$((MO-MS)); echo "Rows: $ROWS"; echo;
    sed -n "$FIRST,$ p" < $FILE > $YEAR.at
    ./tabcomp.sh $YEAR.at $ROWS
fi
rm $FILE $NEWFILE
mv $YEAR.at datafiles
