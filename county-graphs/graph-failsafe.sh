#!/bin/bash
echo "State: "; read; STATE=$REPLY; PT2=$(echo $STATE | sed 's/ /_/g')
echo "County name: "; read; COUNTY=$(echo $REPLY | sed 's/ /_/g'); PT1="$COUNTY"; PT1+="_County,_"
PAGE="https://en.wikipedia.org/wiki/$PT1$PT2";
wget -nv "$PAGE" .; mv $PT1$PT2 $COUNTY.dat

printf '\nInstances of "Presidential election(s) results":\n'
grep -ni "Presidential election[s]* results" $COUNTY.dat | cut -f1 -d:

grep -n "<tbody>" $COUNTY.dat | cut -f1 -d: > temp1.tmp
grep -n "</tbody>" $COUNTY.dat| cut -f1 -d: > temp2.tmp
paste temp1.tmp temp2.tmp | awk '{print $1, $2, $2-$1+1}' | sort -k3 -nr > tables.tmp
rm temp*.tmp

printf "\nShowing $(head tables.tmp | wc -l | awk '{print $1}') of $(wc -l tables.tmp | awk '{print $1}') tables\n"
awk '{print NR, "Start:", $1, "End:", $2, "Length:", $3}' tables.tmp | head
printf "\n"; echo "Select record number: "; read;

FILE="$COUNTY".html
sed -n "$(awk -v l=$REPLY 'BEGIN{OFS=","} NR == l {print $1, $2}' tables.tmp)p" $COUNTY.dat > $FILE
rm *.tmp $COUNTY.dat

sed 's/^<td[^>]*>$/<td>0.0% 0/g;s/<[^>]*>//g;/^$/d;s/%//g;s/,//g' $FILE > n$FILE
rm $FILE; echo "Year" > $FILE; echo "GOP_PCT" >> $FILE; echo "GOP_VOTES" >> $FILE; echo "DEM_PCT" >> $FILE; echo "DEM_VOTES" >> $FILE; echo "OTHER_PCT" >> $FILE; echo "OTHER_VOTES" >> $FILE;
awk 'NR > 4 {print $0}' n$FILE >> $FILE;
rm n$FILE
cat $FILE | tr " " "\n" > n$FILE; rm $FILE; mv n$FILE $FILE
./tabcomp.sh $FILE 7
./graph.py $FILE $STATE
rm $FILE
