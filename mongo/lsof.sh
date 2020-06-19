#!/bin/bash -x
# Prepare report of services/connection to mysql db server
MHOST=$(hostname)
OUTFILE="/tmp/${MHOST}_connected.txt"
> $OUTFILE
#NR>remove last 2 lines- ns will produce hostname with domain. That is needed for lsof to generate clean output
ns=`nslookup $MHOST | awk 'NR>2'| grep $MHOST | awk '{print $2}'`
l=`lsof | grep mongo | grep ESTABLISHED | awk '{print $9}' | sed  's/'$ns':webmin->//g' | sed 's/[:].*$//' | sort | uniq -c > $OUTFILE`

