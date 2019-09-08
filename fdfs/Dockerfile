FROM alpine:3.10

ENV TZ Asia/Shanghai
ENV NGINX_VER 1.14.2
ENV TRACKER_DATA /data/tracker
ENV STORAGE_DATA /data/storage
ENV BUILD_DIR /usr/src
ENV SOFT_URL http://kaifa.hc-yun.com:30027/base/software

WORKDIR	$BUILD_DIR

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
  && apk add --no-cache bash tzdata \
  && apk add --no-cache --virtual .build-deps \
         git \
         gcc \
         make \
         libc-dev \
         pcre-dev \
         openssl-dev \
         zlib-dev \
         linux-headers \
         libxslt-dev \
         gd-dev \
         geoip-dev \
         gnupg1 \
         perl \
  && cp /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && date \
  && addgroup -g 1000 -S nginx \
  && adduser -u 1000 -D -S -h /var/cache/nginx -s /sbin/nologin -G nginx nginx \
  && git clone https://github.com/happyfish100/libfastcommon.git --depth 1 \
  && git clone https://github.com/happyfish100/fastdfs.git --depth 1 \
  && git clone https://github.com/happyfish100/fastdfs-nginx-module.git --depth 1 \
  && wget -O - ${SOFT_URL}/nginx-${NGINX_VER}.tar.gz | tar xzf - -C $BUILD_DIR \
  && cd ${BUILD_DIR}/libfastcommon \
  && ./make.sh && ./make.sh install \
  && cd ${BUILD_DIR}/fastdfs \
  && ./make.sh && ./make.sh install \
  && cp ${BUILD_DIR}/fastdfs/conf/* /etc/fdfs \
  && cp ${BUILD_DIR}/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs \
  && cd ${BUILD_DIR}/nginx-${NGINX_VER} \
  && export C_INCLUDE_PATH=/usr/include/fastcommon \
  && ./configure \
       --prefix=/etc/nginx \
       --sbin-path=/usr/sbin/nginx \
       --modules-path=/usr/lib/nginx/modules \
       --conf-path=/etc/nginx/nginx.conf \
       --error-log-path=/var/log/nginx/error.log \
       --http-log-path=/var/log/nginx/access.log \
       --pid-path=/var/run/nginx.pid \
       --lock-path=/var/run/nginx.lock \
       --http-client-body-temp-path=/var/cache/nginx/client_temp \
       --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
       --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
       --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
       --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
       --user=nginx \
       --group=nginx \
       --with-http_ssl_module \
       --with-http_realip_module \
       --with-http_addition_module \
       --with-http_sub_module \
       --with-http_dav_module \
       --with-http_flv_module \
       --with-http_mp4_module \
       --with-http_gunzip_module \
       --with-http_gzip_static_module \
       --with-http_random_index_module \
       --with-http_secure_link_module \
       --with-http_stub_status_module \
       --with-http_auth_request_module \
       --with-http_xslt_module=dynamic \
       --with-http_image_filter_module=dynamic \
       --with-http_geoip_module=dynamic \
       --with-threads \
       --with-stream \
       --with-stream_ssl_module \
       --with-stream_ssl_preread_module \
       --with-stream_realip_module \
       --with-stream_geoip_module=dynamic \
       --with-http_slice_module \
       --with-mail \
       --with-mail_ssl_module \
       --with-compat \
       --with-file-aio \
       --with-http_v2_module \
       --add-module=${BUILD_DIR}/fastdfs-nginx-module/src \
       --with-debug \
  && make -j$(getconf _NPROCESSORS_ONLN) \
  && make install \
  && rm -rf /etc/nginx/html/ \
  && mkdir /etc/nginx/conf.d/ \
  && mkdir -p /usr/share/nginx/html/ \
  && install -m644 html/index.html /usr/share/nginx/html/ \
  && install -m644 html/50x.html /usr/share/nginx/html/ \
  && ln -s /usr/lib/nginx/modules /etc/nginx/modules \
  && strip /usr/sbin/nginx* \
  && strip /usr/lib/nginx/modules/*.so \
  && cd ${BUILD_DIR} \
  && rm -rf ${BUILD_DIR}/* \
  && apk add --no-cache --virtual .gettext gettext \
  && mv /usr/bin/envsubst /tmp/ \
  && runDeps="$(scanelf --needed --nobanner --format '%n#p' /usr/sbin/nginx /usr/lib/nginx/modules/*.so /tmp/envsubst | tr ',' '\n' | sort -u | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' | egrep -v 'fdfs|fast')" \
  && apk add --no-cache --virtual .nginx-rundeps $runDeps \
  && apk del .build-deps \
  && apk del .gettext \
  && mv /tmp/envsubst /usr/local/bin/ \
  && ln -sf /dev/stdout /var/log/nginx/access.log \
  && ln -sf /dev/stderr /var/log/nginx/error.log \
  && mkdir /data \
  && chown nginx:nginx -Rf /etc/nginx /etc/fdfs /data /usr/share/nginx/html/index.html

COPY run.sh /usr/bin/run.sh
COPY fdfsOK.sh /usr/bin/fdfsOK.sh
COPY nginx.conf /etc/nginx/nginx.conf

RUN chown nginx:nginx -Rf /etc/nginx/nginx.conf

EXPOSE 22122 23000 8888

STOPSIGNAL SIGTERM

# CMD ["nginx", "-g", "daemon off;"]  
