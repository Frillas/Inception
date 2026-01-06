#!/bin/sh

set -e

DATADIR="/var/lib/mysql"
SOCKETDIR=$(dirname /var/lib/mysql/mysql.sock)

# Création du dossier du socket si nécessaire
mkdir -p "$SOCKETDIR"
chown -R mysql:mysql "$SOCKETDIR"

# Initialisation de la base si elle n'existe pas
if [ ! -d "$DATADIR/mysql" ]; then
    echo "[MariaDB] Initializing database..."
    
    mysql_install_db \
        --user=mysql \
        --datadir="$DATADIR" \
        --skip-test-db \
        --rpm

    # Démarrage temporaire du serveur
    echo "[MariaDB] Configuring database..."
    mysqld --user=mysql --bootstrap --silent-startup << EOF
USE mysql;
FLUSH PRIVILEGES;

-- Création de la base de données
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Création de l'utilisateur WordPress
CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';

-- Configuration du root (localhost + remote)
ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
CREATE USER IF NOT EXISTS 'root'@'%' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' WITH GRANT OPTION;

-- Sécurité : suppression des utilisateurs par défaut
DELETE FROM mysql.user WHERE User='' OR User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1', '%');
DROP DATABASE IF EXISTS test;

FLUSH PRIVILEGES;
EOF

    echo "[MariaDB] Database initialized successfully"
else
    echo "[MariaDB] Database already exists, skipping initialization"
fi

# Fix des permissions (important après initialisation)
chown -R mysql:mysql "$DATADIR"
chown -R mysql:mysql /run/mysqld

echo "[MariaDB] Starting MariaDB server..."
exec mysqld --user=mysql --console
