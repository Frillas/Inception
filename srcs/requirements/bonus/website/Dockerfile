FROM alpine:3.22

RUN apk update && apk add --no-cache nginx

RUN mkdir -p /run/nginx /var/www/html

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY html/ /var/www/html/

RUN chown -R nginx:nginx /var/www/html /run/nginx

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
