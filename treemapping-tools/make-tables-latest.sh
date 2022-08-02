#!/bin/bash
echo "State: "; read; STATE=$REPLY; STATE=$(echo $STATE | sed 's/ /_/g')
mkdir $STATE; cd $STATE
echo "Enter a range of election years. Start: (must be a multiple of 4) "; read; FIRSTYEAR=$REPLY
echo "End: "; read; LASTYEAR=$REPLY
for YEAR in $(seq $FIRSTYEAR 4 $LASTYEAR); do

PT2="_United_States_presidential_election_in_$STATE";
PAGE="https://en.wikipedia.org/wiki/$YEAR$PT2";
wget -nv "$PAGE"; mv $YEAR$PT2 $STATE$YEAR.html

grep -n "<tbody>" $STATE$YEAR.html | cut -f1 -d: > temp1.tmp
grep -n "</tbody>" $STATE$YEAR.html| cut -f1 -d: > temp2.tmp
paste temp1.tmp temp2.tmp | awk '{print $1, $2, $2-$1+1}' | sort -k3 -nr > tables2.tmp
rm temp*.tmp


if [[ "$(awk '{print $3}' tables2.tmp | sort -n -k1 | head -n1)" -lt "0" ]];
then
    printf "\n\nRunning Intelligent Table Search on $STATE$YEAR.html. This may take a few seconds.\n\n"
    ../intelligent-table-search.sh $STATE$YEAR.html > tables.tmp
    rm tables2.tmp
else
    mv tables2.tmp tables.tmp
fi

BIGGEST=$(awk 'NR == 1 {print $3}' tables.tmp)
SECONDBIGGEST=$(awk 'NR == 2 {print $3}' tables.tmp)
RATIO=$((BIGGEST / SECONDBIGGEST))

RECORD=1
if [ $RATIO -lt 5 ] 
then
    printf '\nInstances of "(Results by )county":\n'
    grep -ni "[Results ]*by county" $STATE$YEAR.html | cut -f1 -d:
    printf "\nShowing $(head -n 5 tables.tmp | wc -l | awk '{print $1}') of $(wc -l tables.tmp | awk '{print $1}') tables\n"
    awk '{print NR, "Start:", $1, "End:", $2, "Length:", $3}' tables.tmp | head -n 5
    printf "\n"; echo "Select record number: (type ABORT to abort) "; read; RECORD=$REPLY
fi

if [ "$RECORD" = "ABORT" ]
then
    rm *.tmp *.html *.dat
else

FILE="$STATE$YEAR".dat
sed -n "$(awk -v l=$RECORD 'BEGIN{OFS=","} NR == l {print $1, $2}' tables.tmp)p" $STATE$YEAR.html > $FILE
FIRSTCOUNTY=$(grep "County," $STATE$YEAR.html | grep "td" | sed 's/<[^>]*>//g;' | head -n1)
#echo $FIRSTCOUNTY
rm *.tmp $STATE$YEAR.html
# s/^<td[^>]*>$/<td>0/g;
sed 's/^<td[^>]*>$/<td>0/g;s/<[^>]*>//g;/^$/d;s/,//g;s/ /_/g' $FILE > n$FILE
rm $FILE

printf "\n"
#tail -n 30 n$FILE
#echo "Columns in table body? (Hint: subtract the line number of one county name from another)"; read; COLS=$REPLY
COLS=$(tail -n 50 n$FILE | cat -n | grep '[A-Z]' | awk '{print $1}' | tr '\n' ' ' | awk '{print $2-$1}')
#printf "Cols: $COLS"

head -n 30 n$FILE | cat -n
SUGGESTION=$(grep -n $FIRSTCOUNTY n$FILE | awk 'BEGIN{FS=":"} {print $1}')
((SUGGESTION-=1))

echo "Excess lines in top? (Suggestion: $SUGGESTION) (Hint: One before the first county name)"; read; TOPLINES=$REPLY
INPNAMES=1;
if [ "$TOPLINES" = "" ]
then
    TOPLINES=$SUGGESTION
fi   
sed 's/%//g;' n$FILE | awk -v toplines=$TOPLINES 'NR > toplines {print $0}' > $FILE;
../tabcomp.sh $FILE $COLS
mv n$FILE o$FILE
sed 's/&.*;//g;' $FILE > n$FILE; rm $FILE; mv n$FILE $FILE

HEADER="County ";
head -n $((TOPLINES)) o$FILE 
echo ""

ORDER="n"
((TOPLINES+=2)) # include the first percentage and pound combo ??
RELEVANT=$(sed -n "${TOPLINES}p" o$FILE)
#echo $RELEVANT
if [[ "$RELEVANT" == *"%"* ]];
then 
    ORDER="y"
fi
((TOPLINES--))

#echo "Does a candidate's percentage come before their number of votes? (y/n)"; read; ORDER=$REPLY

MARGINFIND=$(head -n $((TOPLINES)) o$FILE | grep "Margin" | wc -l | awk '{print $1}')
MARGINSUGGESTION="n"
if [ $MARGINFIND -gt "0" ]
then
    MARGINSUGGESTION="y"
fi


echo "Are there 2 \"Margin\" columns after the listed candidates? (y/n) (Suggestion: $MARGINSUGGESTION)"; read; MARGIN=$REPLY
if [ "$MARGIN" = "" ]
then
    MARGIN=$MARGINSUGGESTION
fi   

ISTOTAL=$(head -n $((TOPLINES)) o$FILE | grep "Total*" | wc -l | awk '{print $1}')
#echo $ISTOTAL
TOTALSUGGESTION="n"
if [ $ISTOTAL -gt "0" ]
then
    TOTALSUGGESTION="y"
fi

echo "Is there a \"Total votes\" column at the end? (y/n) (Suggestion: $TOTALSUGGESTION)"; read; TOTAL=$REPLY
if [ "$TOTAL" = "" ]
then
    TOTAL=$TOTALSUGGESTION
fi   


PARTIES=$((COLS - 1)) # ignores first "County" column
HEADEND=""
if [ "$MARGIN" = "y" ]
then 
    ((PARTIES-=2))
    if [ "$ORDER" = "y" ]
    then
        HEADEND+="Margin_PCT Margin_NUM "
    else
        HEADEND+="Margin_NUM Margin_PCT "
    fi
fi
if [ "$TOTAL" = "y" ]
then 
    ((PARTIES-=1))
    HEADEND+="Total_NUM "
fi
((PARTIES/=2))
#echo "Parties: $PARTIES"

echo ""
sed -n '2,$p' o$FILE | head -n $((PARTIES*2))
printf "\nDemocratic: DEM, Republican: GOP, Populist: POP, Progressive: PRO, Prohibition: PHB, Socialist: SOC, Dixiecrat: DIX\n"
for i in $(seq 1 1 $PARTIES); do 
    echo "Name Party/Group $i of $PARTIES)"; read;
    if [ "$ORDER" = "y" ]
    then
        HEADER+="$REPLY"; HEADER+="_PCT ";
        HEADER+="$REPLY"; HEADER+="_NUM ";
    else 
        HEADER+="$REPLY"; HEADER+="_NUM ";
        HEADER+="$REPLY"; HEADER+="_PCT ";
    fi
done
HEADER+=$HEADEND

sed -i '.tmp' "1s/^/$HEADER\n/g" $FILE; 
rm $FILE.tmp;

rm o$FILE

printf "\nLast line:\n"
tail -n 1 $FILE
DELETELASTSUG="n"
DELETELAST=$(tail -n 1 $FILE | grep "Total*" | wc -l | awk '{print $1}')
if [ $DELETELAST -gt "0" ]
then
    DELETELASTSUG="y"
fi

printf "\nRemove last line? (Suggestion: $DELETELASTSUG) (is it 'Totals' of some sort) (y/n) "; read; REMOVELAST=$REPLY
if [ "$REMOVELAST" = "" ]
then
    REMOVELAST=$DELETELASTSUG
fi   

if [ "$REMOVELAST" = "y" ]
then 
    sed -i '' '$d' $FILE
fi

printf "\nOutput (10 of $(wc -l $FILE | awk '{print $1}') lines shown)\n"
head -n 5 $FILE | awk '{print $0}'
echo "..."
tail -n 5 $FILE | awk '{print $0}'
awk '{OFS=","} {$1=$1;print $0};' $FILE > "$STATE$YEAR".csv
fi
done
mkdir dat; mkdir csv
mv *.dat dat/
mv *.csv csv/

