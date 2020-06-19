#!/bin/bash
crit_var=$(ps -ef | grep sqlplus | wc -l)
if [ $crit_var -lt 300 ]; then
echo $crit_var
echo "processes running normal"
else
echo "too many processes"
echo $crit_var | mailx -s "too many sqlplus procs" dba@gmail.com
fi
exit 0
