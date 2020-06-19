#!/bin/bash

export FILEBEAT_HOME=/opt/filebeat-6.4.1-linux-x86_64

#-- Check if process already running.....
count=$( ps -ef | grep -v 'grep' | grep -v 'SCREEN' | grep -ic "filebeat" )

if [ $count -lt 1 ]
  then
  echo "Starting FileBeat now......"
  $FILEBEAT_HOME/filebeat -e -c $FILEBEAT_HOME/filebeat.yml & 
fi

