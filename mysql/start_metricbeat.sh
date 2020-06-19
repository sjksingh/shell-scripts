#!/bin/bash

export FILEBEAT_HOME=/opt/metricbeat-6.4.2-linux-x86_64

#-- Check if process already running.....
count=$( ps -ef | grep -v 'grep' | grep -v 'SCREEN' | grep -ic "metricbeat" )

if [ $count -lt 1 ]
  then
  echo "Starting Metricbeat now......"
  $FILEBEAT_HOME/metricbeat -e -c $FILEBEAT_HOME/metricbeat.yml & 
fi
