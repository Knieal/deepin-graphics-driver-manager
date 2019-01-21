#!/bin/bash

systemctl stop lightdm

. /usr/lib/deepin-graphics-driver-manager/common.sh

POSTOS=`cat /proc/mounts | awk '{if ($2 == "/media/root-ro") print $1}'`

#dialog --timeout 8 --title "Deepin Graphics Driver Manager - Installer" --yesno "\nSure to start install driver?" 6 50

# remount devices
mount -o remount,rw $POSTOS /media/root-ro

# write to local drive
journalctl -f -u driver-installer.service >> /media/root-ro/var/log/dgradvrmgr.log 2>&1 &

# write to tty
journalctl -f -u driver-installer.service | sed 's/$/\r/g' > /dev/tty1 2>&1 &

# all nvidia modules will be disable when prepare for nvidia about solutions
# so we need restore here
if [[ -e "/etc/modprobe.d/deepin-blacklists-nvidia.conf" ]]; then
    echo "remove modules about nvidia from blacklist!"
    overlayroot-chroot rm -rf /etc/modprobe.d/deepin-blacklists-nvidia.conf
    overlayroot-chroot update-initramfs -u -t
fi

# test remove/install drivers
$REMOVE_OLD_G || error_reboot "test remove old driver failed!"
$INSTALL_NEW_G || error_reboot "test install new driver failed!"

# file "/tmp/deepin-prime-gltest" is generated by install prime script 
# cause prime needs some special ENV to work so here to start the special script for gltest
# otherwise start gltest directly
if [[ -e "/tmp/deepin-prime-gltest" ]]; then
    /usr/bin/xinit /tmp/deepin-prime-gltest
else
    /usr/bin/xinit /usr/lib/deepin-graphics-driver-manager/gltest
fi

killall Xorg

sleep 1

reboot
