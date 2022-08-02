#!/bin/bash
touch table.tmp

FILE=$1

find_closing () {
  local i=$1; local start=$1
  while [[ $(sed "${i}q;d" $FILE) != *"</tbody"* ]];
  do 
    ((++i))
  done
  echo $start $i $((i - start)) >> table.tmp
}

NUM=0
while read -r line;
do
  ((++NUM))
  if [[ $line == *"<tbody"* ]]
  then 
    find_closing $NUM
  fi
done < $1

sort -k3 -nr table.tmp 
rm table.tmp