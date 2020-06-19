#!/bin/bash
export GG_HOME=/apps/gg
$GG_HOME/ggsci <<EOF
dblogin userid gg02, password gg02
lag replicat rep1
exit
EOF
