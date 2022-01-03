#!/bin/bash

echo "1. Electoral Votes"
echo "2. Votes Cast"
echo "3. EV per 100,000 votes"
echo "4. EV/10^5 votes (fraction of national average)"
printf "Select an option: "; read; OPTION=$((REPLY+2));
cp rows.dat out.dat
for i in $(seq 1872 4 1960); do
    awk -v o=$OPTION '{print $o}' $i.dat > m.tmp
    paste out.dat m.tmp > mout.dat
    rm m.tmp out.dat
    mv mout.dat out.dat
done
cat top.dat out.dat > nout.dat
rm out.dat; mv nout.dat out.dat
