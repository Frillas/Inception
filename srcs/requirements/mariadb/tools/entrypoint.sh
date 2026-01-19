#!/bin/sh
set -e

DATADIR="/var/lib/mysql"
SOCKETDIR=$(dirname /var/lib/mysql/mysql.sock)

mkdir -p "$SOCKETDIR"
chown -R mysql:mysql "$SOCKETDIR"

if [ ! -d "$DATADIR/mysql" ]; then
    echo "[MariaDB] Initializing database..."
    
    mariadb-install-db \
        --user=mysql \
        --datadir="$DATADIR" \
        --skip-test-db \
        --rpm

    echo "[MariaDB] Configuring database..."
    /usr/bin/mariadbd --user=mysql --bootstrap --silent-startup << EOF
USE mysql;
FLUSH PRIVILEGES;

CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

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

chown -R mysql:mysql "$DATADIR"
chown -R mysql:mysql /run/mysqld

echo "[MariaDB] Starting MariaDB server..."
exec /usr/bin/mariadbd --user=mysql --console
