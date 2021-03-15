Airplaneon=`getprop persist.vendor.radio.airplane_mode_on`
Wifion=`getprop wlan.driver.status`
#Bton=`getprop vendor.bluetooth.status`
Bton=`getprop vendor.btonoff.status`

log -t WifiAntenna enter Airplaneon=$Airplaneon Wifion=$Wifion Bton=$Bton

if [ "$Airplaneon" == "1" ] ; then
    if [ "$Wifion" == "unloaded" ] && [ "$Bton" == "off" ] ; then
        echo 0 > /sys/devices/platform/soc/b0000000.qcom,cnss-qca6490/do_wifi_antenna_switch
        log -t WifiAntenna disable_antenna switch
    else
        echo 1 > /sys/devices/platform/soc/b0000000.qcom,cnss-qca6490/do_wifi_antenna_switch
        log -t WifiAntenna enable_antenna switch
    fi
else
    echo 1 > /sys/devices/platform/soc/b0000000.qcom,cnss-qca6490/do_wifi_antenna_switch
    log -t WifiAntenna enable_antenna switch
fi

