#!/vendor/bin/sh
audbg_mode=`getprop persist.vendor.asus.set.audbg`
#is_factory_mode=`getprop ro.boot.pre-ftm`
build_type=`getprop ro.build.type`

echo "check audio debug mode $audbg_mode" > /dev/kmsg

case "$audbg_mode" in
  "0")
    echo 0 > /proc/driver/audio_debug
    ;;
  "1")
    echo 1 > /proc/driver/audio_debug
    ;;
  "")
    if [ "$build_type" == "userdebug" ]; then
        setprop persist.vendor.asus.set.audbg 2
    else
        setprop persist.vendor.asus.set.audbg 3
    fi
    ;;
esac
