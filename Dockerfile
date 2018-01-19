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
CMD /run.sh /os.img

#RUN wget https://downloads.raspberrypi.org/raspbian_lite_latest -qO raspian.img \
#    && mkdir -p /mnt/img
RUN	mkdir -p /mnt/img
ADD ./kernel-qemu-4.4.34-jessie /kernel-qemu-4.4.34-jessie
ADD ./run.sh /run.sh
