#!/bin/bash
echo "State: "; read; STATE=$REPLY; PT2=$(echo $STATE | sed 's/ /_/g')
echo "County name: "; read; COUNTY=$(echo $REPLY | sed 's/ /_/g'); PT1="$COUNTY"; PT1+="_County,_"
PAGE="https://en.wikipedia.org/wiki/$PT1$PT2";
wget -nv "$PAGE" .; mv $PT1$PT2 $COUNTY.dat

grep -n "<tbody>" $COUNTY.dat | cut -f1 -d: > temp1.tmp
grep -n "</tbody>" $COUNTY.dat| cut -f1 -d: > temp2.tmp
paste temp1.tmp temp2.tmp | awk '{print $1, $2, $2-$1+1}' | sort -k3 -nr > tables.tmp
rm temp*.tmp

FILE="$COUNTY".html
sed -n "$(awk 'BEGIN{OFS=","} NR == 1 {print $1, $2}' tables.tmp)p" $COUNTY.dat > $FILE
rm *.tmp $COUNTY.dat

sed 's/^<td[^>]*>$/<td>0.0% 0/g;s/<[^>]*>//g;/^$/d;s/%//g;s/,//g' $FILE > n$FILE
rm $FILE; echo "Year" > $FILE; echo "GOP_PCT" >> $FILE; echo "GOP_VOTES" >> $FILE; echo "DEM_PCT" >> $FILE; echo "DEM_VOTES" >> $FILE; echo "OTHER_PCT" >> $FILE; echo "OTHER_VOTES" >> $FILE;
awk 'NR > 4 {print $0}' n$FILE >> $FILE;
rm n$FILE
cat $FILE | tr " " "\n" > n$FILE; rm $FILE; mv n$FILE $FILE

./tabcomp.sh $FILE 7
./graph.py $FILE $STATE
rm $FILE
