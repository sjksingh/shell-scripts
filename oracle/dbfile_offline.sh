#!/bin/bash
nf=$(sqlplus -s << EOF
/ as sysdba
set head off
select count(*)
from v\$datafile
where status='OFFLINE';
EOF)
echo "offline count: $nf" | mailx -s "# files offline" prod@supp.com
