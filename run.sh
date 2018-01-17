#!/bin/sh
OFFSET=$(($(sfdisk -d /os.img | grep img1 | sed -r 's/.*start=\s*([0-9]+).*size.*/\1/') * 512))
#OFFSET=$(($(sfdisk -d /os.img | grep img2 | sed -r 's/.*start=\s*([0-9]+).*size.*/\1/') * 512))
mount -v -o offset=$OFFSET -t vfat /os.img /mnt/img
CMDLINE="earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=PARTUUID=37665771-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait"
#CMDLINE="rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2 init=/bin/bash"
#CMDLINE="earlyprintk loglevel=8 dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=PARTUUID=37665771-02 rootfstype=ext4 elevator=deadline init=/usr/lib/raspi-config/init_resize.sh"
qemu-system-arm -M raspi2 -kernel /mnt/img/kernel7.img -vnc :1 -append "$CMDLINE" -drive file=/os.img,if=sd,format=raw -dtb /mnt/img/bcm2709-rpi-2-b.dtb -serial stdio

#qemu-system-arm -M raspi2 -kernel boot/kernel7.img -drive format=raw,file=2017-11-29-raspbian-stretch-lite.img -append "rw earlyprintk loglevel=8 console=ttyAMA0,115200 dwc_otg.lpm_enable=0 root=/dev/mmcblk0p2" -dtb 2015-11-21-raspbian-boot/bcm2709-rpi-2-b.dtb -serial stdio
#dwc_otg.lpm_enable=0 console=serial0,115200 console=tty1 root=PARTUUID=37665771-02 rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait quiet init=/usr/lib/raspi-config/init_resize.sh
#mv /mnt/img/etc/ld.so.preload /mnt/img/etc/ld.so.preload.disabled
#sed --in-place=".org" "s,/dev/mmcblk0p1,/dev/sda1," /mnt/img/etc/fstab
#sed --in-place=".org" "s,/dev/mmcblk0p2,/dev/sda2," /mnt/img/etc/fstab