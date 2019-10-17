#!/usr/bin/env bash
#
# author: bavdu
# date: 2019/07/28
# usage: auto install mysql bin package


MPATH="/usr/local/mysqld"

# setting owner and group of mysql install directory.
id mysql &>/dev/null
if [ $? -ne 0 ];then
	useradd -M -s /sbin/nologin mysql
fi
chown -R mysql:mysql /usr/local/mysqld

# setting new configure file of mysql service.
if [ -f /etc/my.cnf ];then
	mv /etc/my.cnf{,.bak}
fi
cp ${MPATH}/mysql/mysql-test/include/default_my.cnf /etc/my.cnf

# setting mysql's command is system level.
echo "export PATH=$PATH:/usr/local/mysqld/mysql/bin" >>/etc/profile

# setting auto run and control mysql status command.
if [ ! -f /etc/init.d/mysqld ];then
	cp ${MPATH}/mysql/support-files/mysql.server /etc/init.d/mysqld
	chkconfig --add mysqld && chkconfig mysqld on
	ln -s ${MPATH}/mysql/support-files/mysql.server /usr/bin/mysqlctl
fi

# begin mysql process product socket, setting socket file location.
ps aux | grep mysql &>/dev/null
if [ $? -eq 0 ];then
	mysqlctl start
	ln -s ${MPATH}/tmp/mysql.sock /tmp/mysql.sock
fi

# get initial password.
word=$(grep "temporary password" ${MPATH}/log/mysql_error.log)
passwd=${word##*" "}

# print installed information.
cat <<-EOF
Thank for you using bavduer's tools

    Author Information:
      - Email: bavduer@163.com
      - Github: https://github.com/bavdu

    Information:
      - User: root
      - Password: ${passwd}

    # First run command: "source /etc/profile"
    # Second run sql syntax: "alter user root@localhost identified by '__PASSWORD__';"

Complete ^_~
EOF