#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: monitor cpu status

DATE=$(date +'%Y-%m-%d %H:%M:%S')
IPADDR=$(ifconfig | grep inet | awk 'BEGIN{ FS=" " }NR==1{ print $2 }')
MAIL="bavduer@163.com"

# 检测vmstat命令是否存在
# shellcheck disable=SC2230
if ! which vmstat &>/dev/null; then
	yum -y install procps-ng &>/dev/null
	if [ $? -eq 0 ];then
		echo "vmstat already installed"
	fi
fi

US=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $13 }')
SY=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $14 }')
ID=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $15 }')
WA=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $16 }')
ST=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $17 }')

useTotal=$((${US}+${SY}))
if [[ ${useTotal} -ge 70 ]];then
	echo "
	Date: ${DATE}
	Host: ${HOSTNAME}: ${IPADDR}
	Problem: CPU using rate: ${useTotal}%
	" | mail -s "CPU Monitor Warnning" ${MAIL}
fi