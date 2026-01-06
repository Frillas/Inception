FROM alpine:3.22

RUN apk update && apk add --no-cache \
    mariadb \
    mariadb-client \
    mariadb-server-utils

RUN mkdir -p /var/lib/mysql /run/mysqld \
    && chown -R mysql:mysql /var/lib/mysql /run/mysqld

COPY conf/my.cnf /etc/my.cnf
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3306

ENTRYPOINT ["/entrypoint.sh"]
