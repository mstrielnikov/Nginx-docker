#!/usr/bin/sh

#$PACKAGE_VERSION=""
$ETC_APTH="/etc/nginx"
$SBIN_PATH="/usr/sbin/nginx"
$MODULES_PATH="/usr/lib64/nginx/modules"
$CONF_PATH="/etc/nginx/nginx.conf" 
$ERROR_LOG_PATH="/var/log/nginx/error.log"
$PID_PATH="/var/run/nginx.pid"
$CACHE_PATH="/var/cache/nginx/client_temp"
$USER="nginx"
$GROUP="nginx"
$BUILD="CentOS"
$BUILDDIR="nginx"


yum install pcre openssl zlib wget
wget "https://nginx.org/download/nginx-${PACKAGE_VERSION}.tar.gz && tar zxvf nginx-${PACKAGE_VERSION}.tar.gz"

#wget https://ftp.pcre.org/pub/pcre/pcre-8.40.tar.gz && tar xzvf pcre-8.40.tar.gz
#wget https://www.zlib.net/zlib-1.2.11.tar.gz && tar xzvf zlib-1.2.11.tar.gz
#wget https://www.openssl.org/source/openssl-1.1.0f.tar.gz && tar xzvf openssl-1.1.0f.tar.gz


cat >> /usr/lib/systemd/system/nginx.service << EOF
[Unit]
Description=nginx - high performance web server
Documentation=https://nginx.org/en/docs/
After=network-online.target remote-fs.target nss-lookup.target
Wants=network-online.target
[Service]
Type=forking
PIDFile=/var/run/nginx.pid
ExecStartPre=/usr/sbin/nginx -t -c $CONF_PATH
ExecStart=/usr/sbin/nginx -c $CONF_PATH
ExecReload=/bin/kill -s HUP $MAINPID
ExecStop=/bin/kill -s TERM $MAINPID
[Install]
WantedBy=multi-user.target
EOF


firewall-cmd --zone=public --permanent --add-service=http
firewall-cmd --zone=public --permanent --add-service=https
firewall-cmd --reload

make .
make install

if [[ ${BUILD}=="CentOS" ]]
then
  ln -s /usr/lib64/nginx/modules /etc/nginx/modules
fi

./configure --prefix=/etc/nginx \
--sbin-path=/usr/sbin/nginx \
--modules-path=/usr/lib64/nginx/modules \
--conf-path=/etc/nginx/nginx.conf \
--error-log-path=/var/log/nginx/error.log \
--pid-path=/var/run/nginx.pid  \
--lock-path=/var/run/nginx.lock  \
--user=n_admin \
--group=nginx \
--build=CentOS \
--builddir=nginx-1.13.2 \
--with-select_module \
--with-poll_module \
--with-threads \
--with-file-aio \
--with-http_ssl_module \
--with-http_v2_module \
--with-http_realip_module \
--with-http_addition_module \
--with-http_xslt_module=dynamic \
--with-http_image_filter_module=dynamic \
--with-http_sub_module \
--with-http_dav_module \
--with-http_flv_module \
--with-http_mp4_module \
--with-http_gunzip_module \
--with-http_gzip_static_module \
--with-http_auth_request_module \
--with-http_random_index_module \
--with-http_secure_link_module \
--with-http_degradation_module \
--with-http_slice_module \
--with-http_stub_status_module \
--http-log-path=/var/log/nginx/access.log \
--http-client-body-temp-path=/var/cache/nginx/client_temp \
--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
--with-mail=dynamic \
--with-mail_ssl_module \
--with-stream=dynamic \
--with-stream_ssl_module \
--with-stream_realip_module \
--with-stream_ssl_preread_module \
--with-compat \
--with-pcre-jit \
--with-http_xslt_module \
--with-zlib=../zlib-1.2.11 \
--with-http_image_filter_module \
--with-openssl=../openssl-1.1.0f \
--with-openssl-opt=no-nextprotoneg \
--without-http_autoindex_module \
--without-http_ssi_module \
--without-http_charset_module \
--without-http_rewrite_module \
--with-zlib=../zlib-1.2.11 \
--with-mail \
--with-stream \
--with-openssl-opt=no-weak-ssl-ciphers \
--with-openssl-opt=no-ssl3 \
--with-cc-opt='-g -O2 -fPIE -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2'

systemctl start nginx.service && systemctl enable nginx.service && systemctl status nginx.service && systemctl is-enabled nginx.service

ps aux | grep nginx

curl -I 127.0.0.1

[[ ! -d "${CACHE_PATH}" ]] && mkdir -p "${CACHE_PATH}"

exit 0;
