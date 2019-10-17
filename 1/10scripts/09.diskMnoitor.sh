#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: monitor memory status

DATE=$(date +'%Y-%m-%d %H:%M:%S')
IPADDR=$(ifconfig | grep inet | awk 'BEGIN{ FS=" " }NR==1{ print $2 }')
MAIL="bavduer@163.com"

useRate=$(df -Th | awk 'BEGIN{ FS=" " }NR==2{ print $6 }')

if [[ ${useRate: 0: 2} -ge 90 ]];then
	echo "
	Date: ${DATE}
	Host: ${HOSTNAME}: ${IPADDR}
	Problem:
		Memory using rate: up ${useRate: 0: 2}
	" | mail -s "CPU Monitor Warnning" ${MAIL}
fi