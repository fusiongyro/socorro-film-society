#!/bin/bash

sed 's/\\\N/null/g;s/"/\\\"/g' title.basics.tsv | awk -F "\t" '{ print("title(" $1 "," $2 ",\"" $3 "\",\"" $4 "\"," $5 "," $6 "," $7 "," $8 ",[" tolower($9) "]).") }' > titles.pl
