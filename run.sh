#!/bin/bash

# Test if image exists, or extract from zip
if test -f $IMG; then
  echo "$IMG exists, using existing image"
else
  test -f $IMG_DOWN || { echo "$IMG_DOWN not found"; exit 1; }
  unzip $IMG_DOWN -d /data
fi

# sanity checks
type qemu-system-arm &>/dev/null || { echo "QEMU ARM not found"       ; exit 1; }
test -f $IMG && test -f $KERNEL  || { echo "$IMG or $KERNEL not found"; exit 1; }

# prepare the image
SECTOR1=$( fdisk -l $IMG | grep FAT32 | awk '{ print $2 }' )
SECTOR2=$( fdisk -l $IMG | grep Linux | awk '{ print $2 }' )
OFFSET1=$(( SECTOR1 * 512 ))
OFFSET2=$(( SECTOR2 * 512 ))

# make 'boot' vfat partition available locally
mkdir -p tmpmnt
mount $IMG -o offset=$OFFSET1 tmpmnt
touch tmpmnt/ssh   # this enables ssh
umount tmpmnt

# make 'linux' ext4 partition available locally
mount $IMG -o offset=$OFFSET2 tmpmnt
cat > tmpmnt/etc/udev/rules.d/90-qemu.rules <<EOF
KERNEL=="sda", SYMLINK+="mmcblk0"
KERNEL=="sda?", SYMLINK+="mmcblk0p%n"
KERNEL=="sda2", SYMLINK+="root"
EOF

umount -l tmpmnt
rmdir tmpmnt &>/dev/null

PARAMS_KERNEL="root=/dev/sda2 panic=1"

echo "[network]"
  NETWORK="user"
  REDIR=""
  if [ ! -z "$TCP_PORTS" ]; then
    OIFS=$IFS
    IFS=","
    for port in $TCP_PORTS; do
      REDIR+="-redir tcp:${port}::${port} "
    done
    IFS=$OIFS
  fi
  
  if [ ! -z "$UDP_PORTS" ]; then
    OIFS=$IFS
    IFS=","
    for port in $UDP_PORTS; do
      REDIR+="-redir udp:${port}::${port} "
    done
    IFS=$OIFS
  fi
  FLAGS_NETWORK="${REDIR}"

echo "Using ${NETWORK}"
echo "parameter: ${FLAGS_NETWORK}"

echo "[Remote Access]"
  if [ "$VNC" == "tcp" ]; then
    FLAGS_REMOTE_ACCESS="-vnc ${VNC_IP}:${VNC_ID}"
  elif [ "$VNC" == "reverse" ]; then
    FLAGS_REMOTE_ACCESS="-vnc ${VNC_IP}:${VNC_PORT},reverse"
  elif [ "$VNC" == "sock" ]; then
    FLAGS_REMOTE_ACCESS="-vnc unix:${VNC_SOCK}"
  else
    FLAGS_REMOTE_ACCESS="-nographic"
    PARAMS_KERNEL="$PARAMS_KERNEL vga=normal console=ttyAMA0"
  fi
echo "parameter: ${FLAGS_REMOTE_ACCESS}"


# do it
set -x
qemu-system-arm -kernel $KERNEL -cpu arm1176 -m 256 -M versatilepb $FLAGS_NETWORK \
  $FLAGS_REMOTE_ACCESS -no-reboot -drive format=raw,file=$IMG -append "$PARAMS_KERNEL"
