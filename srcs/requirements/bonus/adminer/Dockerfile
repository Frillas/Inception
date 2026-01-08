FROM alpine:3.22

RUN apk update && apk add --no-cache \
	php82 \
	php82-mysqli \
	php82-pdo \
	php82-pdo_mysql \
	php82-session \
	curl

WORKDIR /var/www/html

RUN curl -L https://github.com/vrana/adminer/releases/download/v5.4.1/adminer-5.4.1.php \
	-o adminer.php

EXPOSE 8080

CMD ["php82", "-S", "0.0.0.0:8080", "adminer.php"]
