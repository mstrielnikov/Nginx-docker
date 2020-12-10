from alpine:latest
run set -x \
#  && mkdir -p /run/nginx \
  && addgroup --system --gid 101 nginx \
  && adduser -DH --system --ingroup nginx --uid 101 nginx \ 
  && apk add --no-cache --update nginx \
  && mkdir -p /run/nginx \
  && chown -R nginx:nginx /etc/nginx/nginx.conf /etc/nginx/conf.d /run/nginx /var/log/nginx /var/lib/nginx/logs \
  && nginx -t
entrypoint ["nginx", "-g", "daemon off;"] 
expose 8080:80
