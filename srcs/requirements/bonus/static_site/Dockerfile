FROM nginx:alpine3.22

RUN apk update && apk add --no-cache nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY html/ /var/www/html/

RUN adduser -D -g 'www' www \
    && mkdir -p /var/cache/nginx /var/run /var/log/nginx \
    && chown -R www:www \
        /var/www/html \
        /var/cache/nginx \
        /var/run \
        /var/log/nginx

EXPOSE 8080

USER www

CMD ["nginx", "-g", "daemon off;"]
