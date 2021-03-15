#ReceiverOn=`getprop vendor.asus.sar.audio`
Wifion=`getprop wlan.driver.status`
Country=`getprop vendor.asus.operator.iso-country`
#SKU=`getprop ro.boot.id.prj`
#CustomerID=`getprop ro.config.CID`
#Wigigon=`getprop vendor.wigig.driver.status`
#Softapon=`getprop vendor.wlan.softap.driver.status`
#WlanDbs=`getprop vendor.wlan.dbs`
#Slm=`getprop vendor.sla.enabled`

log -t WifiSARPower enter Wifion=$Wifion Country=$Country

if [ "$Country" == "IC" ]; then
    vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 0 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 0 --END_ATTR --END_ATTR --END_CMD

    log -t WifiSARPower IC
elif  [ "$Country" == "IN" ]; then
    vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 1 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 1 --END_ATTR --END_ATTR --END_CMD

    log -t WifiSARPower IN
elif  [ "$Country" == "AU" ]; then
    vendor_cmd_tool -f /vendor/bin/sar-vendor-cmd.xml -i wlan0 --START_CMD --SAR_SET --ENABLE 7 --NUM_SPECS 2 --SAR_SPEC --NESTED_AUTO --CHAIN 0 --POW_IDX 6 --END_ATTR --NESTED_AUTO --CHAIN 1 --POW_IDX 6 --END_ATTR --END_ATTR --END_CMD

    log -t WifiSARPower AU
else
    log -t WifiSARPower Not tirgger
fi

