#!/bin/bash
#ps -e -o pcpu,pid,user,tty,args|grep -i oracle|sort -n -k 1 -r|head
sqlplus -s << EOF
SELECT
'USERNAME : ' || s.username || CHR(10) ||
'SCHEMA : ' || s.schemaname || CHR(10) ||
'OSUSER : ' || s.osuser || CHR(10) ||
'MODUEL : ' || s.program || CHR(10) ||
'ACTION : ' || s.schemaname || CHR(10) ||
'CLIENT_INFO : ' || s.osuser || CHR(10) ||
'PROGRAM : ' || s.program || CHR(10) ||
'SPID : ' || p.spid || CHR(10) ||
'SID : ' || s.sid || CHR(10) ||
'SERIAL# : ' || s.serial# || CHR(10) ||
'KILL STRING : ' || '''' || s.sid || ',' || s.serial# || '''' || CHR(10) ||
'MACHINE : ' || s.machine || CHR(10) ||
'TYPE : ' || s.type || CHR(10) ||
'TERMINAL : ' || s.terminal || CHR(10) ||
'SQL ID : ' || q.sql_id || CHR(10) ||
'CHILD_NUM : ' || q.child_number || CHR(10) ||
'SQL TEXT : ' || q.sql_text
FROM v$session s
,v$process p
,v$sql q
WHERE s.paddr = p.addr
AND p.spid = '&PID_FROM_OS'
AND s.sql_id = q.sql_id(+)
AND s.status = 'ACTIVE'
;
EOF
