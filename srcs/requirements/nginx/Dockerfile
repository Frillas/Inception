FROM nginx:alpine3.22

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/certificat.sh /certificat.sh

RUN chmod +x certificat.sh

ENTRYPOINT ["/certificat.sh"]
