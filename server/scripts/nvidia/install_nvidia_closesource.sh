#!/bin/bash

if [ "$(id -u)" -ne "0" ];then
    echo "Need root privileges."
    exit 1
fi

. /usr/lib/deepin-graphics-driver-manager/common.sh

packages=(
    "nvidia-driver"
    "xserver-xorg-core"
    "xserver-xorg-input-all"
)

package_install "${packages[*]}" "${#packages[*]}"

modinfo intelgpu >/dev/null 2>&1
if [[ $? -eq 0 ]]; then
    echo "blacklist intelgpu" >> /etc/modprobe.d/nvidia-blacklists-nouveau.conf
    update-initramfs -u
fi

exit 0
