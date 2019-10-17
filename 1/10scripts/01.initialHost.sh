#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: initial webserver or databaseserver or development enviroment.


# check current user if root.
if [ $(whoami) == "root" ];then
  echo "current user is: $(whoami)"
else
  echo "please change user to root."
  exit 2
fi

# setting selinux and firewall is off.
systemctl stop firewalld && systemctl disable firewalld
sed -ri s/SELINUX=enforcing/SELINUX=disabled/g /etc/selinux/config

# setting system's time sync of internet.
echo "* * */7 * *   bash /tasks/ntpSync.sh" >>/var/spool/cron/$(whoami)
cat <<-EOF >/tasks/ntpSync.sh
#!/usr/bin/env bash
#
# author: bavdu
# date: @2019/07/22
# usage: sync system time.

if [ ! -f /usr/bin/ntpdate ];then
    yum -y install ntpdate
    ntpdate -b ntp1.aliyun.com &
else
    ntpdate -b ntp1.aliyun.com &
fi
EOF

# setting command history display time point.
echo "export HISTSIZE=10000" >>/etc/profile
echo "export HISTTIMEFORMAT=\"%Y-%m-%d %H:%M:%S - \"" >>/etc/profile

# setting importen file of system locked.
chattr +ai /etc/passwd /etc/shadow /etc/group

# install system's import packages.
yum -y install vim bash-completion net-tools
if [ $? -eq 0 ];then
  yum -y groupinstall "Development Tools"
fi

# end.
echo "Complete ^_~"
init 6