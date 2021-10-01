#!/bin/bash
for i in $(seq 1876 4 1952); do YEAR=$i;
FILE=$YEAR; FILE+="_United_States_presidential_election";
PAGE="https://en.wikipedia.org/wiki/$FILE";
wget -nv $PAGE;
grep -n "<tbody>" $FILE | cut -f1 -d: > temp1.tmp
grep -n "</tbody>" $FILE | cut -f1 -d: > temp2.tmp
paste temp1.tmp temp2.tmp | awk '{print $1, $2, $2-$1+1}' | sort -k3 -nr > tables.tmp
    NEWFILE="$YEAR".dat
    sed -n "$(awk -v l=1 'BEGIN{OFS=","} NR == l {print $1, $2}' tables.tmp)p" $FILE > $NEWFILE
    rm $FILE
    sed 's/ /_/g;s/<[^>]*>//g;/^$/d;s/,//g' $NEWFILE > $FILE

    FIRST=$(grep -ni "Alabama" $FILE | cut -f1 -d:);
    MS=$(grep -ni "Mississippi" $FILE | cut -f1 -d:); 
    MO=$(grep -ni "Missouri" $FILE | cut -f1 -d:);
    ROWS=$((MO-MS));
    sed -n "$FIRST,$ p" < $FILE > $YEAR.at
    ./tabcomp.sh $YEAR.at $ROWS
rm $FILE $NEWFILE
mv $YEAR.at fastdata
cp 1916/table.dat fastdata/1916.at
done
