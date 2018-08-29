#!/bin/bash

# exit 0 ------ no driver,use default glamor
# exit 1 ------ use open nouveau driver
# exit 2 ------ use private nvidia driver
nouveau_mod=`lsmod | grep nouveau`
nvidia_mod=`lsmod | grep nvidia`
bumblebee_exist=`dpkg -l | grep bumblebee`
prime_exist=`dpkg -l | grep deepin-nvidia-prime`
BATTERY=`qdbus com.deepin.daemon.InputDevices /com/deepin/daemon/Power com.deepin.daemon.Power.LidIsPresent`

if [ x"$BATTERY" == x"true" ]; then
    echo "Support bumblebee"
    if [ -n "$nouveau_mod" ]; then
        if [ -f /usr/lib/xorg/modules/drivers/nouveau_drv.so ];then
            echo "Nouveau Mode"
            exit 1
        else
            echo "Default Mode"
            exit 0
        fi
    else
        if [ -n "$bumblebee_exist" ]; then
            echo "Bumblebee Mode"
            exit 3
        elif [ -n "$prime_exist" ]; then
            echo "Prime Mode"
            exit 4
        else
            echo "Can not find bumblebee or prime conf"
            echo 0
        fi
    fi
else
    echo "Unsupport bumblebee"
    if [ -n "$nouveau_mod" ]; then
        if [ -f /usr/lib/xorg/modules/drivers/nouveau_drv.so ];then
            echo "Nouveau Mode"
            exit 1
        else
            echo "Default Mode"
            exit 0
        fi
    elif [ -n "$nvidia_mod" ]; then
            echo "Private Mode"
            exit 2
    else
        echo "can not find any nvidia modules"
        exit 0
    fi
fi
