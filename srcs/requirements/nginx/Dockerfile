FROM nginx:latest

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/certificat.sh /certificat.sh

RUN chmod +x certificat.sh

ENTRYPOINT ["/certificat.sh"]
