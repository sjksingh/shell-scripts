#!/bin/sh
df -H | grep -vE '^Filesystem|tmpfs|cdrom|udev|boot' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 75 ]; then
    #### Lets purge older ping logs
    /home/mysql/dba/sanjeev/purge_bin_log.sh  
    echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
     mail -s "Alert: Almost out of disk space $usep%" dba@google.com
  fi
done
