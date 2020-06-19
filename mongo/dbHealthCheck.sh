#!/bin/bash

# Nagios States
CRITICAL_THRESHOLD=1
START_FILE=/data01/mongo/dba/startup.txt
MAIL_LIST=devops@google.com

CONNECTIONS=`/bin/netstat -an | grep mongo | /usr/bin/awk '{print $9}' | /usr/bin/wc -l`

if [ ${CONNECTIONS} -ne ${CRITICAL_THRESHOLD} ]
  then
      mailx -s "CRITICAL: MongoDB-Down@`hostname`" $MAIL_LIST < $START_FILE
      #echo "CRITICAL: Mongo Database is down on `hostname` !!!" | mail -s "MongoDB Alert" devops@google.com
      exit ${STATE_CRITICAL}
fi
