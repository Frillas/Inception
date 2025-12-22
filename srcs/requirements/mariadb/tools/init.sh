#!/bin/sh

if [ ! -d "/var/lib/mysql" ]; then
	echo "initializing MariaDB"

	mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql
	
	mysqld_safe &
	
	sleep 5
	
	mysql -u root << EOF
CREATE DATABASE IF NOT EXISTES $MYSQL_DATABASE;
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';
FLUSH PRIVILEGES;
EOF

	mysqladmin shutdown
fi

exec mysqld_safe
