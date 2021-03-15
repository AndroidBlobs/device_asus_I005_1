#!/vendor/bin/sh
echo 1 > /sys/devices/platform/soc/990000.i2c/i2c-2/2-0038/fts_hw_reset
sleep 1.5
TP1_VER_PACK=`cat /sys/devices/platform/soc/990000.i2c/i2c-2/2-0038/fts_fw_version`

setprop vendor.touch.version.driver "$((16#$TP1_VER_PACK))"

