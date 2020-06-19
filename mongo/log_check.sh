#!/bin/bash -x
##########################################
# Monitor Mongo database log
# DBA-Devops Group
#     Sanjeev Singh - updated - July/19/2016
#
#
############################################
source /data01/mongo/.profile

MAIL_LIST="devops@google.com"
LOG_DIR=/data01/mongo/ROADRUNNER/mongo_logs
DBA_DIR=/data01/mongo/dba/logs

logfile=`mktemp`

ERROR_LOG_FILE="$LOG_DIR/mongo_server.log"

POINTER_FILE="$DBA_DIR/error_log_pointer.log"
ERROR_LOG_TMP="$DBA_DIR/error_log_tmp.log"

NEWPOINTER=`wc -l $ERROR_LOG_FILE | sed -e 's/^ +//' | awk '{print $1}'`

if [ -f $POINTER_FILE ]; then
    OLDPOINTER=`cat $POINTER_FILE`
else
    OLDPOINTER=0
fi
if [ "$NEWPOINTER" = "$OLDPOINTER" ]; then
  exit
fi

if [ "$NEWPOINTER" -lt "$OLDPOINTER" ]; then
    echo "LOG ROTATED"
    OLDPOINTER=0
fi

if [ -f "$ERROR_LOG_FILE" ]; then
    tail -n +$OLDPOINTER $ERROR_LOG_FILE | egrep '(is now in state SECONDARY|replSet info voting yea|is now in state PRIMARY)' > $ERROR_LOG_TMP
else
    echo "ERRORLOG $ERROR_LOG_FILE not found!"
fi

echo $NEWPOINTER > $POINTER_FILE

if [ -s "$ERROR_LOG_TMP" ]; then
    mailx -s "Error ALERT mongo@`hostname`" $MAIL_LIST < $ERROR_LOG_TMP
fi
