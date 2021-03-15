#/vendor/bin/sh


echo 1 > /sys/fs/selinux/log
echo "cscSecdisplay test" > /proc/asusevtlog
powerOnOff=`getprop sys.pmoled.power`
/vendor/bin/PMOLED_Power $powerOnOff       
echo 255 > /sys/class/spi_master/spi0/spi0.0/Backlight
cat /sys/class/spi_master/spi0/spi0.0/Backlight
echo 0 > /sys/fs/selinux/log

