#!/bin/bash

## Get the links to dhall menus
curl "https://www.skidmore.edu/diningservice/menus/" > menus.html
grep -oh "\\/diningservice\/menus\/[Dinner|Lunch].*\.pdf\b" menus.html > links.txt

## Go through each line and download the menu pdfs
input="links.txt"
while IFS= read -r var
do
    curl -O "https://www.skidmore.edu$var"
done < "$input"

## Remove unneeded textfiles
rm menus.html
rm links.txt

# Install needed tools
## sudo apt-get install poppler-utils

for f in *.pdf; do
  pdftotext -enc UTF-8 -layout "$f"
done

# Remove unneeded pdf files
rm *.pdf

file -i *

./ScrapeDhall.pl
