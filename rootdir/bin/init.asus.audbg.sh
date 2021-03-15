#!/vendor/bin/sh
audbg_mode=`getprop persist.vendor.asus.set.audbg`
echo "audio debug mode $audbg_mode" > /dev/kmsg
echo "$audbg_mode" > /proc/driver/audio_debug
