#!/bin/bash

if [ ${RFKILL_STATE} = 2 -o ${RFKILL_STATE} = 0 ]; then
    echo "bluetooth stopped" | systemd-cat -p info -t "bluetooth-rfkill.sh"
else
    echo "bluetooth started" | systemd-cat -p info -t "bluetooth-rfkill.sh"
    sleep 1
    if [ "`getprop droid.bt.scanned`" = "true" ]; then
      echo "lescan already done" | systemd-cat -p info -t "bluetooth-rfkill.sh"
      exit 0
    fi
    echo "performing initial lescan" | systemd-cat -p info -t "bluetooth-rfkill.sh"
    hcitool lescan &
    pid=$!
    sleep 1
    kill -INT $pid
    if [ "`getprop droid.bt.scanned`" = "false" ]; then
      setprop droid.bt.scanned true
    else
      setprop droid.bt.scanned false
    fi
    echo "initial lescan done" | systemd-cat -p info -t "bluetooth-rfkill.sh"
fi
