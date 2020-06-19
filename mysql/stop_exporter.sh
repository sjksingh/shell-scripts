#!/bin/bash -x
## Script to stop and kill all process on port 9104.
## 9104 is from mysqld_exporter

export MYSQLD_HOME=/usr/local/bin/

#-- Check if process already running.....
count=`ps -ef|grep mysqld_exporter | grep -v 'grep' | wc -l`

if [ $count -gt 0 ]
  then
   echo "Lets stop mysqld_exporter...."
   lsof -i :9104 | tail -n +2 | awk '{print $2}' | while read output;
    do
       kill -9 $output
    done  
  sleep 5
fi

#count=`ps -ef|grep mysqld_exporter | grep -v 'grep' | wc -l`

