#!/bin/bash
SID_LIST="dev1 dev2 dev3"
critProc=ora_smon
for curSid in $SID_LIST
do
ps -ef | grep -v 'grep' | grep ${critProc}_$curSid
if [ $? -eq 0 ]; then
echo "$curSid is available."
else
echo "$curSid has issues." | mail -s "issue with $curSid" dba@gmail.com
fi
done
exit 0
