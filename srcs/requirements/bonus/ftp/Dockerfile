FROM alpine:3.22

RUN apk update && apk add --no-cache \
    vsftpd \
    shadow

RUN mkdir -p /var/run/vsftpd /home/ftpuser

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf

COPY tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 21 
EXPOSE 21000-21010

ENTRYPOINT ["/entrypoint.sh"]
