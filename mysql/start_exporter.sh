#!/bin/bash

export MYSQLD_HOME=/usr/local/bin/

#-- Check if process already running.....
count=`ps -ef|grep mysqld_exporter | grep -v 'grep' | wc -l`

if [ $count -gt 0 ]
  then
   echo "Mysqld_exporter is already running....."
   exit 0 
else
  echo "Starting Mysqld_exporter now......"
  $MYSQLD_HOME/mysqld_exporter --config.my-cnf=/etc/mysql_exporter/.my.cnf &
  sleep 5
fi


