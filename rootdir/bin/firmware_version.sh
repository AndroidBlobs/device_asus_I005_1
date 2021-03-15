#!/vendor/bin/sh

BATTERY=`cat /sys/class/asuslib/asus_get_fw_version`
setprop vendor.battery.version.driver "$BATTERY"
