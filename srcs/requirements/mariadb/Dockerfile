FROM alpine3.22

# Installer mariaDB
RUN apk add --no-cache mariadb mariadb-client

# Créer le répertoire de données et le répertoire pour le script d'initialisation
RUN mkdir -p /run/mysqld && \
    mkdir -p /docker-entrypoint-initdb.d

# Initialisation de la base
RUN mariadb-install-db --user=mysql --datadir=/var/lib/mysql

# Copier le script et autoriser l'éxecution
COPY tools/init.sh /docker-entrypoint-initdb.d/init.sh
RUN chmod +x tools/init.sh

# Script pour démarrer mariadb
COPY tools/start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/start.sh"]
