MIN=$(awk '{print NF}' $1 | sort -n | head -1)
MAX=$(awk '{print NF}' $1 | sort -nr | head -1)
echo Difference: $((MAX-MIN))
