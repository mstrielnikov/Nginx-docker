from alpine:latest
run set -x \
  && addgroup --system --gid 101 nginx \
  && adduser -DH --system --ingroup nginx --uid 101 nginx \ 
  && apk add --no-cache --update nginx \
  && mkdir -p /run/nginx /www \
  && chown -R nginx:nginx /etc/nginx/nginx.conf /etc/nginx/conf.d /run/nginx /var/log/nginx /var/lib/nginx/logs /www
copy ./index.html /www/index.html
copy ./nginx.conf /etc/nginx/nginx.conf
run nginx -t && chown -Rh nginx:nginx /www
entrypoint ["nginx", "-g", "daemon off;"] 
expose 8080:80
