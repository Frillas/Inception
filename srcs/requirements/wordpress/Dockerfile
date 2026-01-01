FROM alpine:3.22

# Installer PHP, PHP-FPM et extensions requises par WordPress
RUN apk update && apk add --no-cache \
    php82 \
    php82-fpm \
    php82-mysqli \
    php82-json \
    php82-curl \
    php82-dom \
    php82-exif \
    php82-fileinfo \
    php82-mbstring \
    php82-openssl \
    php82-xml \
    php82-zip \
    php82-phar \
    curl \
    mariadb-client

RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php82/php-fpm.d/www.conf

RUN ln -s /usr/bin/php82 /usr/bin/php

COPY conf/php.ini /etc/php82/conf.d/99-memory.ini

# Installer WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

# Créer le dossier WordPress
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Copier le script d'initialisation
COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# PHP-FPM écoute sur le port 9000
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
