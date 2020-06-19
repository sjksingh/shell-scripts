#!/bin/sh
##########################################
# Report System Stats
# DBA-Devops Group
#     Sanjeev Singh - updated - July/19/2018
#
#
############################################
clear
echo "HOSTNAME: ${hostname}"
#echo "`nslookup ${HOSTNAME} | awk 'NR==4 {print;exit}'` "
echo ""
echo "Release-`/usr/bin/lsb_release -cd`"

#uname -a
#HOSTFILE=/usr/bin/lsb_release -a > /root/out.txt
echo ""
echo "==== CPU INFO ===="
echo ""
CPUFILE=/proc/cpuinfo
test -f $CPUFILE || exit 1
NUMPHY=`grep "physical id" $CPUFILE | sort -u | wc -l`
NUMLOG=`grep "processor" $CPUFILE | wc -l`
if [ $NUMPHY -eq 1 ]
  then
    echo This system has one physical CPU,
  else
    echo This system has $NUMPHY physical CPUs,
fi
if [ $NUMLOG -gt 1 ]
  then
    echo and $NUMLOG logical CPUs.
    NUMCORE=`grep "core id" $CPUFILE | sort -u | wc -l`
    if [ $NUMCORE -gt 1 ]
      then
        echo For every physical CPU there are $NUMCORE cores.
    fi
  else
    echo and one logical CPU.
fi

echo -n The CPU is a `grep "model name" $CPUFILE | sort -u | cut -d : -f 2-`
echo " with`grep "cache size" $CPUFILE | sort -u | cut -d : -f 2-` cache"

echo ""
echo "==== MEMORY INFO ===="
echo ""

 MEM_TOTAL=`cat /proc/meminfo | grep "MemTotal"`;
 MEM_FREE=`cat /proc/meminfo | grep "MemFree"`;
 SWP_TOTAL=`cat /proc/meminfo | grep "SwapTotal"`;

 echo "$MEM_TOTAL"
 echo "$MEM_FREE"
 echo "$SWP_TOTAL"
