wifi_mac=`sed -n '1 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf0MacAddress=/ }
setprop ro.vendor.wifimac $wifi_mac
wifi_mac=`sed -n '2 p' /vendor/factory/wlan_mac.bin`
wifi_mac=${wifi_mac//Intf1MacAddress=/ }
setprop ro.vendor.wifimac_2 $wifi_mac

#wigig_mac=`cat /vendor/factory/wigig_mac.bin`
#setprop ro.wigigmac $wigig_mac

setprop vendor.wifi.version.driver WLAN.HSP.1.1-01722-QCAHSPSWPL_V1_V2_SILICONZ-1
#setprop wigig.version.driver 5.3.0.72
#setprop wigig.dock.version.driver v0.0.0.10
