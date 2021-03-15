#!/vendor/bin/sh

#waiting sepolicy
sleep 5

rm -f /mnt/vendor/persist/aw_cali.bin
rm -f /mnt/vendor/persist/aw_rtp_cali.bin

echo 1 > /sys/class/leds/vibrator/cali
sleep 1
echo 1 > /sys/class/leds/vibrator/osc_cali
sleep 1

cali_r=`cat /sys/class/leds/vibrator/load_cali`
#echo 1:$cali_r
len1=`expr ${#cali_r}`
#echo len1:$len

r=`echo $cali_r |grep fail`
#echo 2:$r
len2=`expr ${#r}`
#echo len2:$len

if [ $len2 -eq 0 ] && [ $len1 -ne 0 ]; then
  echo PASS
  setprop vendor.vibrator.cali "PASS"
elif [ $len1 -eq 0 ]; then
  echo Fail. Permission denied
  setprop vendor.vibrator.cali "Fail"
else
  echo $cali_r
  setprop vendor.vibrator.cali "Other"
fi
