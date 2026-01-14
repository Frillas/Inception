FROM alpine:3.22

RUN apk update && apk add --no-cache \
    nginx \
    openssl

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY conf/conf.d/server.conf /etc/nginx/conf.d/server.conf
COPY tools/certificat.sh /certificat.sh

RUN chmod +x certificat.sh

ENTRYPOINT ["/certificat.sh"]
