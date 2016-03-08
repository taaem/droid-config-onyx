#!/bin/sh

# Maximum number of attempts to enable hcismd to try to get
# hci0 to come online.  Writing to sysfs too early seems to
# not work, so we loop.
MAXTRIES=15

seq 1 $MAXTRIES | while read i ; do
    echo 1 > /sys/module/hci_smd/parameters/hcismd_set
    if [ -e /sys/class/bluetooth/hci0 ] ; then

        # Unblock bluetooth if killed before
        rfkill unblock bluetooth

        # power on hci0
        hciconfig hci0 up

        # Run a scan for bluetooth le devices in bg 
        # for some strange reason needed otherwise normal scan won't work
        hcitool lescan &

        # kill bluetooth le scan so the UI can start normal scans
        pid=$!
        sleep 5
        kill -INT $pid

        # found hci0, exit successfully
        exit 0
    fi
    sleep 1
    if [ $i == $MAXTRIES ] ; then
        # must have gotten through all our retries, fail
        exit 1
    fi
done
