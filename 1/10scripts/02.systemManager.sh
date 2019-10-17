#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: write system manager stencil plate.

User() {
  # shellcheck disable=SC2155
  local number=$(wc -l /etc/passwd | awk 'BEGIN{ FS=" " }{ print $1 }')
  echo "UserNumber: ${number}"
}

Process() {
  # shellcheck disable=SC2155
  local number=$(ps aux | wc -l)
  echo "ProcessNumber: ${number}"
}

Cpu() {
  US=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $13 }')
  SY=$(vmstat | awk 'BEGIN{ FS=" " }NR==3{ print $14 }')
  # shellcheck disable=SC2004
  useTotal=$((${US}+${SY}))
  echo "CPU Load: ${useTotal}"
}

Memory() {
  TOTAL=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $2 }')
  USE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $3 }')
  CACHE=$(free -mw | awk 'BEGIN{ FS=" " }NR==2{ print $7 }')
  useRate=$(echo "((${USE}+${CACHE})/${TOTAL})*100" | bc -ql)
  echo "MemoryRate: ${useRate:0:5}"
}

Disk() {
  useRate=$(df -Th | awk 'BEGIN{ FS=" " }NR==2{ print $6 }')
  echo "DiskRate: ${useRate}"
}


while true; do
  clear
  cat <<-EOF
  +-----------------------------------------------------+
  |              Manager Tools version@1.0              |
  +-----------------------------------------------------+
  |                1.display user number                |
  |                2.display process number             |
  |                3.display cpu load                   |
  |                4.display memory rate                |
  |                5.display disk use rate              |
  +-----------------------------------------------------+
  |  Help: Exit(q) SourceCode:https://github.com/bavdu  |
  +-----------------------------------------------------+
EOF
printf "please input choose: "
read -r choose
case $choose in
  1)
    User
    ;;
  2)
    Process
    ;;
  3)
    Cpu
    ;;
  4)
    Memory
    ;;
  5)
    Disk
    ;;
  *)
    printf "please input choose in (1, 2, 3, 4, 5)\n"
esac
done