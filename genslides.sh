#1/bin/bash

COUNTER=$1
RANGE=$2
END=$(($COUNTER+$RANGE))
while [  $COUNTER -lt $END ]; do
    name=$(printf "slides/%04d.md" $COUNTER)
    echo $name
    touch $name
    let COUNTER=COUNTER+1 
done