#!/bin/bash
process=`grep 'processor' /proc/cpuinfo | sort -u | wc -l` # cpu process
#server_id=`/sbin/ifconfig eth4 | awk '/inet / {print $2}' | awk -F"." '{printf "%s%s", $3,$4 }'`
server_id=100

echo "-----Check DBA group-----"
if [[ `cat /etc/group | egrep dba` =~ "dba" ]];then
        echo " DBA group has been Exist"
else
        echo " DBA group was not Exist!Now create DBA group............"
        `groupadd dba`
fi

echo "-----Check MySQL Account-----"

if [[ `cat /etc/passwd | grep mysql` =~ "mysql" ]];then
        echo " MySQL Account has been Exist"
else
        echo " MySQL Account was not Exist! Now create MySQL Account ..........."
        `useradd -g dba -m mysql`
fi
echo "-----Check MySQL basedir-----"
if [[ -d "/home/mysql/mysql" ]];then
        echo "MySQL basedir was found"
else
        echo "MySQL basedir was not found!Create MySQL basedir......"
        mkdir /home/mysql/mysql
        echo "-----Install package-----"
##      apt-get -y install gcc gcc-multilib cmake gnutls-dev build-essential libncurses5-dev  ncurses-devel bison libxml2-devel boost libevent-devel boost-devel Judy Judy-devel openssl-devel
        echo "-----Downloading Mariadb & Install Mariadb-----"
        wget https://downloads.mariadb.org/interstitial/mariadb-10.3.12/source/mariadb-10.3.12.tar.gz/from/http%3A//mirror.rackspace.com/mariadb/ -O /home/mysql/mysql.tar.gz
        echo "-----decompression------"
        cd /home/mysql/
        tar zxvf /home/mysql/mysql.tar.gz
        echo "-----Install-----"
        cd /home/mysql/mariadb-10.3.12
        cmake . -DCMAKE_INSTALL_PREFIX=/home/mysql/mysql -DEXTRA_CHARSETS=all
        make -j $process
        make install
fi
echo "-----Check MySQL datadir-----"
echo "Please enter your mysql port"
read port
if echo $port |egrep -q "^[0-9]+$";then

if [  -d "/home/mysql/my$port" ];then
        echo "mysql datadir was found"
        exit 0
else
        echo "mysql datadir was not found!Create MySQL datadir......."
fi
fi
read -p "your mysql port is $port (y/n)" yn
if [ "$yn" == "y" ] || [ "$yn" == "Y" ];then
        mkdir -p /home/mysql/my$port/data /home/mysql/my$port/log/iblog /home/mysql/my$port/run /home/mysql/my$port/tmp

elif [ "$yn" == "n" ] || [ "$yn" == "N" ];then
        echo "please make sure your mysql port....."
        exit 0

else
        echo "please make sure your mysql port....."
        exit 0
fi
echo "Check and Change owner dir to mysql....."
if [[ `ls -l /home/mysql/my$port | grep mysql | grep -v grep | awk '{print $3,$4}'` =~ "mysql dba" ]];then
        echo "/home/mysql/my$port owner is mysql:dba"
else chown -R mysql:dba /home/mysql/my$port
fi
echo "-----Config and start up Mariadb-----"
echo "-----Create MySQL config file -----"
cat > /home/mysql/my$port.cnf << EOF
[mysqld_safe]
pid-file=/home/mysql/my$port/run/mysqld.pid

[mysql]
port=$port
prompt=\\u@\\d \\r:\\m:\\s>
default-character-set=utf8

[client]
port=$port
socket=/home/mysql/my$port/run/mysql.sock

[mysqld]
#####dir#####
basedir=/home/mysql/mysql
datadir=/home/mysql/my$port/data
tmpdir=/home/mysql/my$port/tmp
lc_messages_dir=/home/mysql/mysql/share
log-error=/home/mysql/my$port/log/alert.log
slow_query_log_file=/home/mysql/my$port/log/slow.log
socket=/home/mysql/my$port/run/mysql.sock

#####innodb#####
innodb_data_home_dir=/home/mysql/my$port/data
innodb_log_group_home_dir=/home/mysql/my$port/log/iblog
innodb_buffer_pool_size=25G
innodb_log_files_in_group=4
innodb_log_file_size=2G
innodb_log_buffer_size=256M
innodb_flush_log_at_trx_commit=2
innodb_io_capacity=10000
innodb_read_io_threads=8
innodb_write_io_threads=8
innodb_file_per_table=1
innodb_flush_method=O_DIRECT
innodb_page_size=8k
transaction-isolation=READ-COMMITTED


######replication#####
master-info-file=/home/mysql/my$port/log/master.info
relay-log=/home/mysql/my$port/log/relaylog
relay_log_info_file=/home/mysql/my$port/log/relay-log.info
skip-slave-start

#####binlog#####
log-bin=/home/mysql/my$port/log/binlog
server_id=$server_id
binlog_cache_size=32K
max_binlog_cache_size=2G
max_binlog_size=500M
binlog-format=ROW
sync_binlog=0
log-slave-updates
expire_logs_days=7

#####MyISAM Specific options#####
key_buffer_size = 8M
read_buffer_size = 1M
read_rnd_buffer_size = 4M
bulk_insert_buffer_size = 8M
myisam_sort_buffer_size = 8M
myisam_max_sort_file_size = 10G
myisam_repair_threads = 1
myisam_recover

#####not innodb options (fixed)#####
back_log = 50
max_connections = 400
table_cache = 2048
max_allowed_packet = 16M
max_heap_table_size = 64M
sort_buffer_size = 4M
join_buffer_size = 4M
thread_cache_size = 400
query_cache_size = 0
query_cache_type = 0
tmp_table_size = 64M
gdb

#####Maria-5.5#####
thread_handling=pool-of-threads
thread_pool_size=16

#####server######
default-storage-engine=INNODB
lower_case_table_names=1
performance_schema=0
long_query_time=1
slow_query_log=1
port=$port
skip-name-resolve
skip-ssl
max_user_connections=8000
max_connect_errors=65535
EOF

echo '----- MySQL install db -----'
/home/mysql/mysql/scripts/mysql_install_db --defaults-file=/home/mysql/my$port.cnf --basedir=/home/mysql/mysql --datadir=/home/mysql/my$port/data --user=mysql --force

echo '-----Start MySQL -----'
/home/mysql/mysql/bin/mysqld_safe --defaults-file=/home/mysql/my$port.cnf --user=mysql > /tmp/mysql_star.log 2>&1 &

echo "-----MySQL has been install & start up ! please check error log in /home/mysql/my$port/log/alert.log -----"

exit 0
