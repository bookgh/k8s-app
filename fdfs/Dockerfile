FROM alpine:latest

ENV USER fdfs
ENV WEB_PORT 8888
ENV FDFS_PORT 22122
ENV TRACKER_DIR /data/tracker
ENV STORAGE_DIR /data/storage

RUN addgroup -g 1000 -S $USER \
  && adduser -u 1000 -D -S -G $USER $USER \
  && sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories \ 
  && apk add --no-cache git gcc libc-dev bash make automake autoconf libtool linux-headers 

RUN cd /opt \
  && git clone https://github.com/happyfish100/libfastcommon.git --depth 1 \
  && cd /opt/libfastcommon \
  && ./make.sh && ./make.sh install \
  && cd /opt \
  && rm -rf /opt/libfastcommon

RUN cd /opt \
  && git clone https://github.com/happyfish100/fastdfs.git --depth 1 \
  && cd /opt/fastdfs \
  && ./make.sh && ./make.sh install \
  && cd /opt \
  && rm -rf /opt/fastdfs
      
RUN cp /etc/fdfs/tracker.conf.sample /etc/fdfs/tracker.conf \
  && cp /etc/fdfs/client.conf.sample /etc/fdfs/client.conf \
  && cp /etc/fdfs/storage.conf.sample /etc/fdfs/storage.conf \
  && sed -i "s|/home/yuqing/fastdfs|$STORAGE_DIR|g" /etc/fdfs/client.conf  \
  && sed -i "s|/home/yuqing/fastdfs|$STORAGE_DIR|g" /etc/fdfs/storage.conf  \
  && sed -i "s|/home/yuqing/fastdfs|$TRACKER_DIR|g" /etc/fdfs/tracker.conf \
  && chown $USER:$USER -Rf /etc/fdfs

# 启动脚本
COPY start.sh /start.sh
COPY fdfsOK.sh /usr/bin/fdfsOK.sh

EXPOSE 22122 23000 8888

# ENTRYPOINT ["/start.sh"]
