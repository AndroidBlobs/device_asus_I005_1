#!/vendor/bin/sh

echo "boot_vibrator" > /dev/kmsg

boot_vibrator_next_disable=`cat /asdf/boot_vibrator_next_disable`
echo 0 > /asdf/boot_vibrator_next_disable
if [ "$boot_vibrator_next_disable" == "1" ]; then
	exit 0
fi
setprop vendor.vibrator.boot "1"

