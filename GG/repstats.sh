#!/bin/bash
export GG_HOME=/data-stg2/oracle/gg
$GG_HOME/ggsci <<EOF
dblogin userid gg02, password gg02
stats replicat rep1
exit
EOF
