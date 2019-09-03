FROM alpine:latest

ENV TZ Asia/Shanghai
ENV NGINX_VER 1.15.3
ENV FASTDFS_VER V5.11
ENV LIBFASTCOMMON_VER V1.0.39
ENV BUILD_ROOT /opt
ENV STORAGE_DATA /data/storage
ENV TRACKER_DATA /data/tracker

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \
   && apk add --no-cache --virtual .build-deps gcc libc-dev make openssl-dev pcre-dev zlib-dev linux-headers libxslt-dev gd-dev geoip-dev perl-dev libedit-dev mercurial bash alpine-sdk findutils git \
   && cd $BUILD_ROOT \
   && git clone --branch $LIBFASTCOMMON_VER --depth 1 https://github.com/happyfish100/libfastcommon.git ${BUILD_ROOT}/libfastcommon \
   && cd ${BUILD_ROOT}/libfastcommon && ./make.sh && ./make.sh install \
   && cd ${BUILD_ROOT} \
   && git clone --branch $FASTDFS_VER --depth 1 https://github.com/happyfish100/fastdfs.git ${BUILD_ROOT}/fastdfs \
   && cd ${BUILD_ROOT}/fastdfs && ./make.sh && ./make.sh install \
   && cd ${BUILD_ROOT}/fastdfs/conf/ \
   && cp http.conf mime.types anti-steal.jpg /etc/fdfs/ \
   && cd ${BUILD_ROOT} \
   && cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf \
   && cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf \
   && cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf \
   && cd ${BUILD_ROOT} \
   && wget http://nginx.org/download/nginx-${NGINX_VER}.tar.gz \  
   && tar xf nginx-${NGINX_VER}.tar.gz \
   && git clone https://github.com/happyfish100/fastdfs-nginx-module.git \
   && chmod +x ${BUILD_ROOT}/fastdfs-nginx-module/src/config \
   && cd ${BUILD_ROOT}/nginx-${NGINX_VER} \
   && export C_INCLUDE_PATH=/usr/include/fastcommon \
   && ./configure --add-module=${BUILD_ROOT}/fastdfs-nginx-module/src \
   && make && make install \
   && cp ${BUILD_ROOT}/fastdfs-nginx-module/src/mod_fastdfs.conf /etc/fdfs/ \
   && cd ${BUILD_ROOT} \
   && rm -rf ${BUILD_ROOT}/* \
   && apk del .build-deps \
   && apk add --no-cache bash pcre

COPY start.sh /usr/bin/start.sh
COPY nginx.conf /usr/local/nginx/conf/nginx.conf

RUN chmod +x /usr/bin/start.sh

EXPOSE 22122 23000 8888 80

CMD ["/usr/bin/start.sh"]
