#!/bin/bash
systemctl stop lightdm

. /usr/lib/deepin-graphics-driver-manager/common.sh


# write to tty
journalctl -f -u dgradvrmgr-test-installer.service | sed 's/$/\r/g' > /dev/tty1 2>&1 &


#remove/install drivers
$REMOVE_OLD_G || error_reboot "test remove old driver failed!"
$INSTALL_NEW_G || error_reboot "test install new driver failed!"

/usr/sbin/overlayroot-chroot touch /usr/lib/deepin-graphics-driver-manager/working-dir/dgradvrmgr_gltest_flag

reboot
