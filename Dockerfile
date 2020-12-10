from alpine:latest
run apk add --no-cache --update nginx \
  &&  mkdir -p /run/nginx \
  &&  nginx -t
entrypoint ["nginx", "-g", "daemon off;"] 
expose 8080:80
