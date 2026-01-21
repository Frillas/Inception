#!/bin/sh
set -e

DATADIR="/var/lib/mysql"

if [ ! -d "$DATADIR/mysql" ]; then
    echo "[MariaDB] Initializing database..."
    
    mariadb-install-db \
        --user=mysql \
        --datadir="$DATADIR"

    echo "[MariaDB] Configuring database..."
    /usr/bin/mariadbd --user=mysql --bootstrap --silent-startup << EOF
USE mysql;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;
EOF

    echo "[MariaDB] Database initialized successfully"
else
    echo "[MariaDB] Database already exists, skipping initialization"
fi

chown -R mysql:mysql "$DATADIR" /run/mysqld

echo "[MariaDB] Starting MariaDB server..."
exec /usr/bin/mariadbd --user=mysql --console
