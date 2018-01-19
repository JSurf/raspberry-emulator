FROM debian:buster-slim
RUN apt-get update \
    && apt-get -q --no-install-recommends -y install \
          qemu-system-arm \
          ca-certificates \
          wget \
          unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ENV KERNEL=kernel-qemu-4.4.34-jessie \
    TCP_PORTS="22" \
    UDP_PORTS="" \
    VNC="tcp" \
    VNC_IP="" \
    VNC_ID=0 \
    IMG=/data/2017-11-29-raspbian-stretch-lite.img \
    IMG_DOWN=/2017-11-29-raspbian-stretch-lite.zip \
    IMG_URL=http://director.downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-12-01/2017-11-29-raspbian-stretch-lite.zip

RUN wget -q -O $IMG_DOWN http://director.downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2017-12-01/2017-11-29-raspbian-stretch-lite.zip \   
    && mkdir -p /mnt/img \
    && mkdir -p /data 

VOLUME /data

ADD ./kernel-qemu-4.4.34-jessie /kernel-qemu-4.4.34-jessie
ADD ./run.sh /run.sh

CMD /run.sh
