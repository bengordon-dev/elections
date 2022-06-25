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
rm *.tmp $STATE$YEAR.html
# s/^<td[^>]*>$/<td>0/g;
sed 's/^<td[^>]*>$/<td>0/g;s/<[^>]*>//g;/^$/d;s/,//g;s/ /_/g' $FILE > n$FILE
rm $FILE
printf "\n\n"
tail -n 30 n$FILE | cat -n
echo "Columns in table body? (Hint: subtract the line number of one county name from another)"; read; COLS=$REPLY
printf "\n"
head -n 30 n$FILE | cat -n
echo "Excess lines in top? (Hint: One before the first county name)"; read; TOPLINES=$REPLY
echo "Type 0 for no column names, type 1 for naming assistance, or type 2 to name columns manually"; read; INPNAMES=$REPLY;

sed 's/%//g;' n$FILE | awk -v toplines=$TOPLINES 'NR > toplines {print $0}' > $FILE;
../tabcomp.sh $FILE $COLS
mv n$FILE o$FILE
sed 's/&.*;//g;' $FILE > n$FILE; rm $FILE; mv n$FILE $FILE

HEADER=""
if [ $INPNAMES -eq 1 ] 
then
    HEADER+="County ";
    head -n $((TOPLINES + COLS)) o$FILE 
    echo ""
    echo "Does a candidate's percentage come before their number of votes? (y/n)"; read; ORDER=$REPLY
    echo 'Are there 2 "Margin" columns after the listed candidates? (y/n)'; read; MARGIN=$REPLY
    echo 'Is there a "Total votes" column at the end? (y/n)'; read; TOTAL=$REPLY
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
    
    echo ""
    head -n $((PARTIES * 2)) o$FILE
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
elif [ $INPNAMES -eq 2 ]
then
    echo "Common titles include [County/Name], [DEM/GOP/POP/PRO/PHB]_[PCT/NUM], and [Margin/MRG]_[PCT/NUM]"
    for i in $(seq 1 1 $COLS); do 
        echo "Name column $i of $COLS"; read;
        HEADER+="$REPLY ";
    done
    sed -i '.tmp' "1s/^/$HEADER\n/g" $FILE; 
    rm $FILE.tmp;
else
    echo "No labels... how sad."
fi
rm o$FILE
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

