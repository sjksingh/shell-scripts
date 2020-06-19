#===================================================================================
# This script will check free space on attach volumes
# Contact: dba@deem.com
#===================================================================================
#!/bin/sh
# Slack Incoming Web hook for deem_db_infra channel
slack_url=https://hooks.slack.com/services/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
hostname="$(uname -a | awk '{print $2}')"

df -H | grep -vE '^Filesystem|tmpfs|cdrom|udev|boot|snap|docker|backup' | awk '{ print $5 " " $1 }' | while read output;
do
  echo $output
  usep=$(echo $output | awk '{ print $1}' | cut -d'%' -f1  )
  partition=$(echo $output | awk '{ print $2 }' )
  if [ $usep -ge 75 ]; then
  #### Lets purge older ping logs
   # echo "Running out of space \"$partition ($usep%)\" on $(hostname) as on $(date)" |
           curl -X POST -H 'Content-type: application/json' --data '{"text":"'"Running out of space $partition ($usep%) on $(hostname)"'"}' $slack_url
   # mail -s "Alert: Almost out of disk space $usep%" dba@google.com
 fi
done
