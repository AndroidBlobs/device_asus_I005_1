#!/system/bin/sh
uts=`getprop persist.vendor.asus.uts`
am broadcast -a $uts -n com.asus.loguploader/.logtool.LogtoolReceiver
