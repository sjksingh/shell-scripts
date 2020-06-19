#!/bin/bash
debug=1
function showMsg {
echo "----------------------------------------"
echo "You're at location: $1 in the $0 script."
echo "----------------------------------------"
} # showMsg
#
SID_LIST="dev1 dev2 dev3"
critProc=ora_smon
#
if [[ debug -eq 1 ]]; then
showMsg 1
fi
#
for curSid in $SID_LIST
do
ps -ef | grep -v 'grep' | grep ${critProc}_$curSid
if [ $? -eq 0 ]; then
echo "$curSid is available."
else
echo "$curSid has issues." | mail -s "issue with $curSid" dba@gmail.com
fi
done
#
if [[ debug -eq 1 ]]; then
showMsg 2
fi
#
exit 0
