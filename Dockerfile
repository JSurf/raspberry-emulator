FROM debian:buster-slim
RUN apt-get update \
    && apt-get -q --no-install-recommends -y install \
          qemu-system-arm \
          ca-certificates \
          wget \
          procps \
          iproute2 \
          kmod \
          unzip \
          uml-utilities \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
CMD /run.sh

#RUN wget https://downloads.raspberrypi.org/raspbian_lite_latest -qO raspian.img \
#    && mkdir -p /mnt/img
RUN	mkdir -p /mnt/img
ADD ./run.sh /run.sh
#ADD 2017-11-29-raspbian-stretch-lite.img /tmp

#sfdisk -d os.img | grep img2 | sed -r 's/.*start=\s*([0-9]+).*size.*/\1/'
# $(($(sfdisk -d os.img | grep img2 | sed -r 's/.*start=\s*([0-9]+).*size.*/\1/') * 512))
# qemu-system-arm -M raspi2
# 	      sfdisk \	  
#mount -v -o offset=48234496 -t ext4 /os.img /mnt/img