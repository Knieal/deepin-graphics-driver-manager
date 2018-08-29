#!/bin/bash

if [ "$(id -u)" -ne "0" ];then
    echo "Need root privileges."
    exit 1
fi

export DEBIAN_FRONTEND=noninteractive
POSTOS=`cat /proc/mounts | awk '{if ($2 == "/media/root-ro") print $1}'`

systemctl stop lightdm

if [ $1 == "post" ];then
    echo "Sync driver into disk $POSTOS ...... "

    find /media/root-rw/overlay/ -size 0 | xargs rm -rf
    mount -o remount,rw $POSTOS /media/root-ro
    rsync -avz --progress /media/root-rw/overlay/* /media/root-ro/
    sync

    echo "Sync driver into disk ...... done"
else
    apt-get --reinstall -y --allow-downgrades install \
        nvidia-driver \
        xserver-xorg-core \
        xserver-xorg-input-all

    if [[ $? -ne 0 ]]; then
        echo "apt-get execute failed!"
        exit 1
    fi

    echo "Loading kernel modules......"
    modprobe nvidia-drm
    modprobe nvidia-modeset
    modprobe nvidia
fi
