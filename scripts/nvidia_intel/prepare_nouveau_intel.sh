#!/bin/bash

COMMANDS=(
    "apt-get update"
    "apt-get install  --fix-missing"
    "apt-get install -d --reinstall -y --allow-downgrades \
        xserver-xorg-video-nouveau \
        xserver-xorg-core \
        xserver-xorg-input-all \
        libegl-mesa0 \
        libegl-mesa0:i386 \
        libgbm1 \
        libgbm1:i386 \
        libgl1-mesa-glx \
        libgl1-mesa-glx:i386 \
        glx-alternative-nvidia:i386 \
        libnvidia-legacy-390xx-cfg1 \
        nvidia-legacy-390xx-alternative"

)

for cmd in "${COMMANDS[@]}"
do
    command ${cmd};

    if [ $? != 0 ]; then
        echo "### Failed in command '${cmd}'"
        exit 1;
    fi
done

# to avoid rmmod or modprobe failed so blacklists modules about nvidia before reboot to overlay
echo "blacklists modules about nvidia now!"
echo -e "blacklist nouveau\nblacklist nvidia-drm\nblacklist nvidia-modeset\nblacklist nvidia\nblacklist nvidiafb" > /etc/modprobe.d/deepin-blacklists-nvidia.conf
update-initramfs -u -t
