#!/bin/bash
echo "Election Year: "; read; YEAR=$REPLY
echo "State: "; read; STATE=$REPLY; STATE=$(echo $STATE | sed 's/ /_/g')
PT2="_United_States_presidential_election_in_$STATE";
PAGE="https://en.wikipedia.org/wiki/$YEAR$PT2";
wget -nv "$PAGE"; mv $YEAR$PT2 $STATE$YEAR.html

printf '\nInstances of "(Results by )county":\n'
grep -ni "[Results ]*by county" $STATE$YEAR.html | cut -f1 -d:

grep -n "<tbody>" $STATE$YEAR.html | cut -f1 -d: > temp1.tmp
grep -n "</tbody>" $STATE$YEAR.html| cut -f1 -d: > temp2.tmp
paste temp1.tmp temp2.tmp | awk '{print $1, $2, $2-$1+1}' | sort -k3 -nr > tables.tmp
rm temp*.tmp

BIGGEST=$(awk 'NR == 1 {print $3}' tables.tmp)
SECONDBIGGEST=$(awk 'NR == 2 {print $3}' tables.tmp)
RATIO=$((BIGGEST / SECONDBIGGEST))
echo $RATIO

RECORD=1
if [ $RATIO -lt 5 ] 
then
    printf "\nShowing $(head -n 5 tables.tmp | wc -l | awk '{print $1}') of $(wc -l tables.tmp | awk '{print $1}') tables\n"
    awk '{print NR, "Start:", $1, "End:", $2, "Length:", $3}' tables.tmp | head -n 5
    printf "\n"; echo "Select record number: "; read; RECORD=$REPLY
fi

FILE="$STATE$YEAR".dat
sed -n "$(awk -v l=$RECORD 'BEGIN{OFS=","} NR == l {print $1, $2}' tables.tmp)p" $STATE$YEAR.html > $FILE
rm *.tmp $STATE$YEAR.html
# s/^<td[^>]*>$/<td>0.0% 0/g;
sed 's/<[^>]*>//g;/^$/d;s/%//g;s/,//g;s/ /_/g' $FILE > n$FILE
rm $FILE
printf "\n\n"
tail -n 30 n$FILE | cat -n
echo "Columns in table body?"; read; COLS=$(echo $REPLY | sed 's/ /_/g'); 
printf "\n\n"
head -n 30 n$FILE | cat -n
echo "Excess lines in top?"; read; TOPLINES=$(echo $REPLY | sed 's/ /_/g'); 
awk -v toplines=$TOPLINES 'NR > toplines {print $0}' n$FILE > $FILE;
./tabcomp.sh $FILE $COLS
rm n$FILE
sed 's/&.*;//g;' $FILE > n$FILE; rm $FILE; mv n$FILE $FILE

printf "\nOutput (5 of $(wc -l $FILE | awk '{print $1}') lines shown)\n"
head -n 5 $FILE | awk '{print $0}'


