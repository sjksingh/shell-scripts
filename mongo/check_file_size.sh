#!/bin/bash -x
## Script to check if file size if greater than 10G
## check variable will be used if file is in Gig.
## size variable will remove G from number value

slack_url=https://hooks.slack.com/services/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
NOTIFY=devops@google.com

check=`ls -lh /data01/mongo/ROADRUNNER/mongo_logs/mongo_server.log | awk '{print $5}' | grep G`
result=$?
size=`ls -lh /data01/mongo/ROADRUNNER/mongo_logs/mongo_server.log | awk '{print $5}' | tr -d G`

 if [[ $result -eq 0 ]] && [[ $size -gt 10 ]]; then
     echo "Log file too large $size[G] on $(hostname) as on $(date) , Please run cat /dev/null > /data01/mongo/ROADRUNNER/mongo_logs/mongo_server.log" |
     mail -s "Alert: Log file too large" $NOTIFY
#  curl -X POST -H 'Content-type: application/json' --data '{"text":"'"File mongo_server.log is at $size "'"}' $slack_url
 fi
