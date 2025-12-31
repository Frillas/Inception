FROM nginx:alpine3.22

RUN apk update && apk add --no-cache openssl

RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/certificat.sh /certificat.sh

RUN chmod +x certificat.sh

ENTRYPOINT ["/certificat.sh"]
