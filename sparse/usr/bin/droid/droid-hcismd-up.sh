#!/bin/sh

# transport is smd
setprop ro.qualcomm.bt.hci_transport smd

# initialise chip and board-address with correct mac
BLUETOOTH_MAC=`/system/bin/btnvtool -p 2>&1| sed -n 's/ //g;s/.*://;s/\./\:/g;y/abcdef/ABCDEF/;1p'`
echo Setting bluetooth address to $BLUETOOTH_MAC | systemd-cat -p info -t "droid-hcismd-up.sh"

echo $BLUETOOTH_MAC > /var/lib/bluetooth/board-address
/system/bin/hci_qcomm_init -d /dev/ttysmd3 -s 3000000 -i 115200 -r 32000000 -p 0 -P 1 -b $BLUETOOTH_MAC

# Maximum number of attempts to enable hcismd to try to get
# hci0 to come online.  Writing to sysfs too early seems to
# not work, so we loop.
MAXTRIES=15

seq 1 $MAXTRIES | while read i ; do
    echo 1 > /sys/module/hci_smd/parameters/hcismd_set
    if [ -e /sys/class/bluetooth/hci0 ] ; then
        # found hci0, exit successfully
        exit 0
    fi
    sleep 1
    if [ $i == $MAXTRIES ] ; then
        # must have gotten through all our retries, fail
        exit 1
    fi
done
