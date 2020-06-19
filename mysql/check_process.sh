#!/bin/bash -x
# Script to see down status of 3 process.
# 1. Mysql Database
# 2. mysql_exported - for promethus & Grafana
# 3. filebeat - for slowquery log to ElastricSearch

#check Database
mcount=$( ps -ef|grep -i mysqld_safe | grep -v 'grep' | wc -l )
#check mysqld_exporter
ecount=$( ps -ef|grep -i mysqld_exporter | grep -v 'grep' | wc -l )
#check filebeat
fcount=$( ps -ef|grep -i filebeat | grep -v 'grep' | wc -l )

if [ $mcount -eq 0 ]
  then
   echo "Database DOWN!" | mail -s "$(hostname)" dba@google.com
  elif [ $ecount -eq 0 ]
  then
   echo "Mysqld_exporter Down! Please use start_exporter.sh to start it up" | mail -s "$(hostname)" dba@google.com
  elif [ $fcount -eq 0 ]
  then
   echo "filebeat Down! Please use start_filebeat.sh to start it up" | mail -s "$(hostname)" dba@google.com
fi
