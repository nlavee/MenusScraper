#!/bin/bash
mkdir resources 
cd "$_"

## Get the links to dhall menus
curl "https://www.skidmore.edu/diningservice/menus/" > menus.html
grep -oh "\\/diningservice\/menus\/[Dinner|Lunch].*\.pdf\b" menus.html > links.txt

## Get the academic calendars to figure out exact week in academic year
## This will inform the Dinner/Lunch cycles
mm=$(date +"%m")
yy=$(date +"%y")
[[ $mm < "07" ]] && yy=$(($yy - 1)) || yy=$yy

curl "https://www.skidmore.edu/registrar/datesdeadlines.php" > calendars.html
grep -oh "\\/registrar/documents/academiccalendar20$yy.*\.pdf\b" calendars.html > dates.txt

## Get dates&deadlines for current year
input="dates.txt"
while IFS= read -r var
do
    curl -O "https://www.skidmore.edu$var"
done < "$input"

## Go through each line and download the menu pdfs
input="links.txt"
while IFS= read -r var
do
    curl -O "https://www.skidmore.edu$var"
done < "$input"

## Remove unneeded files
rm menus.html calendars.html links.txt dates.txt

# Install needed tools
## sudo apt-get install poppler-utils

for f in *.pdf; do
  pdftotext -enc UTF-8 -layout "$f"
done

# Remove unneeded pdf files
rm *.pdf

file -i *

cd .. && ./ScrapeDhall.pl
## rm -r resources