#!/bin/bash
timestamp=$(date)
server=$(hostname)
>/tmp/mongoservicedown.txt
>/tmp/mongoserviceup.txt
service=`ps -ef | grep mongod.conf | grep -v grep | wc -l | tr -d ' '`
if [ "$service" -ne "1" ];
then
touch /tmp/mongoservicedown.txt
echo "DB DOWN....", >> tmp/mongoservicedown.txt
echo "Mongo Service is Down for $server at $timestamp" >> /tmp/mongoservicedown.txt
mail -s "MongoDB Service is DOWN!!! for $serve

