#!/bin/bash
echo "set foreign_key_checks=0;"
for i in $1/*.txt
do
    echo "LOAD DATA INFILE '/home/andrew/automatons/$i' INTO TABLE $(basename $i .txt) IGNORE 1 LINES;"
done
