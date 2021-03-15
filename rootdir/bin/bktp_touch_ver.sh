#!/vendor/bin/sh
echo 1 > /sys/devices/platform/soc/a8c000.i2c/i2c-5/5-0038/bktp_mute
sleep 15

echo 1 > /sys/devices/platform/soc/a8c000.i2c/i2c-5/5-0038/fts_hw_reset
sleep 1.5
TP2_VER_PACK=`cat /sys/devices/platform/soc/a8c000.i2c/i2c-5/5-0038/fts_fw_version`

setprop vendor.touch.version.driver2 "$((16#$TP2_VER_PACK))"

TP2_SUPPORT=`cat /sys/devices/platform/soc/a8c000.i2c/i2c-5/5-0038/touch_status`
if [ "$TP2_SUPPORT" == "1" ]; then
    setprop vendor.backtouch.support "1"
else
    setprop vendor.backtouch.support "0"
fi

echo 0 > /sys/devices/platform/soc/a8c000.i2c/i2c-5/5-0038/bktp_activate