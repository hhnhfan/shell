#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: monitor netmask of online server


netip="192.168.161"
for hostip in $(seq 2 254); do
{
	ping -c1 -s0.5 ${netip}."${hostip}" &>/dev/null
	if [ $? -eq 0 ];then
		echo ${netip}."${hostip}" >>onlineComputer.txt
	else
		echo ${netip}."${hostip}" >>offlineComputer.txt
	fi
}&
done
wait
echo "complete! ^_-"