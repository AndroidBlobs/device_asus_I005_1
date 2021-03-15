#!/vendor/bin/sh

#SAVE_LOG_ROOT=/data/media/0/WifiStressTest
#SAVE_LOG_PATH="$SAVE_LOG_ROOT/`date +%Y_%m_%d_%H_%M_%S`"

SAVE_LOG_PATH="`getprop wifi.version.driver.fail`"
#echo "WifiStressTest test"
#echo $SAVE_LOG_PATH

# copy data/logcat_log to data/media
cp -r /data/logcat_log/ $SAVE_LOG_PATH
cp -r /data/vendor/wifi/wlan_logs/ $SAVE_LOG_PATH
sync
chmod -R 777 $SAVE_LOG_PATH
wait_cmd=`tar -czf $SAVE_LOG_PATH.tar.gz . -C $SAVE_LOG_PATH`
sync
chmod -R 777 $SAVE_LOG_PATH.tar.gz
rm -rf $SAVE_LOG_PATH
sync

#echo "cp -r /data/logcat_log $SAVE_LOG_PATH"
