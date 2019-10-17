#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: monitor memory status

DATE=$(date +'%Y-%m-%d %H:%M:%S')
IPADDR=$(ifconfig | grep inet | awk 'BEGIN{ FS=" " }NR==1{ print $2 }')
MAIL="bavduer@163.com"

TOTAL=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $2 }')
USE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $3 }')
FREE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $4 }')
CACHE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $7 }')
useRate=$(echo "((${USE}+${CACHE})/${TOTAL})*100" | bc -ql)
freeRate=$(echo "(${FREE}/${TOTAL})*100" | bc -ql)

if [[ ${FREE} -le 100 ]];then
  echo "
	Date: ${DATE}
	Host: ${HOSTNAME}: ${IPADDR}
	Problem:
		Memory using rate: ${useRate: 0: 5}%
		Memory free rate: ${freeRate: 0: 5}%
	" | mail -s "CPU Monitor Warnning" ${MAIL}
fi