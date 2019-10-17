#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: nginx log opera


Accesslog() {
  local APATH="/var/log/nginx/access.log"
  local UV=$(awk '{ ips[$1]++ }END{ for(ip in ips){ print ip, ips[ip] }}' ${APATH}|sort -k2 -rn|wc -l)
  local PV=$(wc -l ${APATH}|awk '{ print $1 }')
  echo "PV number: ${PV}"
  echo "UV number: ${UV}"
}

Errorlog() {
  local EPATH="/var/log/nginx/error_log"
  # shellcheck disable=SC2196
  local error40x=$(egrep 40[0-9] ${EPATH}|wc -l)
  # shellcheck disable=SC2196
  local error50x=$(egrep 50[0-9] ${EPATH}|wc -l)
  echo "Errorlog 40x: ${error40x}"
  echo "Errorlog 50x: ${error50x}"
}

Accesslog
Errorlog
