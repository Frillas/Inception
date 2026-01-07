#!/bin/sh
set -e

# Attendre que MariaDB soit disponible AVEC authentification
until /usr/bin/mariadb-admin ping \
    -h"$MYSQL_HOST" \
    -u"$MYSQL_USER" \
    -p"$MYSQL_PASSWORD" \
    --silent; do
    echo "Waiting for MariaDB"
    sleep 2
done

# Installer WordPress si pas déjà fait
if [ ! -f wp-config.php ]; then
    echo "Installing WordPress"

    wp core download --allow-root

    wp config create \
        --dbname="$MYSQL_DATABASE" \
        --dbuser="$MYSQL_USER" \
        --dbpass="$MYSQL_PASSWORD" \
        --dbhost="$MYSQL_HOST" \
        --allow-root

    wp core install \
        --url="$WP_URL" \
        --title="Inception" \
        --admin_user="$WP_ADMIN_USER" \
        --admin_password="$WP_ADMIN_PASSWORD" \
        --admin_email="$WP_ADMIN_EMAIL" \
        --skip-email \
        --allow-root

    wp user create \
        "$WP_USER" \
        "$WP_USER_EMAIL" \
        --user_pass="$WP_USER_PASSWORD" \
        --allow-root
fi

# Installer le plugin Redis dans WordPress
wp plugin install redis-cache --activate --allow-root

# redis est sur le reseau docker, sous le nom redis
wp config set WP_REDIS_HOST redis --allow-root
wp config set WP_REDIS_PORT 6379 --allow-root

wp redis enable --allow-root

exec php-fpm82 -F
