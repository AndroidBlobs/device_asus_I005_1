#!/vendor/bin/sh

# savelog

echo 1 > /sys/fs/selinux/log
sleep 5
echo 1 > /sys/fs/selinux/log
primary_storage=`getprop vold.primary_storage`
startlog_flag=`getprop persist.vendor.asus.startlog`
SAVE_LOG_ROOT=/data/media/0/save_log
BUGREPORT_PATH=/data/user_de/0/com.android.shell/files/bugreports
BUSYBOX=busybox

PATH=$PATH:/system/bin/
if [ ".$primary_storage" == ".sdcard" ]; then
	SAVE_LOG_ROOT="/mnt/expand/`getprop vold.microsd.uuid`/media/0/save_log"
fi

# check mount file
	umask 0;
	sync
############################################################################################	
	# create savelog folder (UTC)
	SAVE_LOG_PATH="$SAVE_LOG_ROOT/`date +%Y_%m_%d_%H_%M_%S`"
	mkdir -p $SAVE_LOG_PATH
	setprop vendor.asus.savelogmtp.folder $SAVE_LOG_PATH
	chmod -R 777 $SAVE_LOG_PATH
	chmod -R 777 $SAVE_LOG_ROOT
	echo "mkdir -p $SAVE_LOG_PATH"
	echo "[savelogmtp]"`date` > $SAVE_LOG_PATH/captureLogTime.txt
###########################################################################################
	am broadcast -a com.asus.DumpSettingsValues -p com.android.settings
############################################################################################
    # save systrace
    echo 20960 > /sys/kernel/debug/tracing/buffer_size_kb
#	atrace --async_start -z -b 20000 -t 5 gfx input audio view webview wm am hal app res dalvik rs bionic  sched freq  load sync workq memreclaim 
#	sleep 5
#	atrace --async_dump -z -b 20000 gfx input audio view webview wm am hal app res dalvik rs bionic  sched freq  load sync workq memreclaim  > $SAVE_LOG_PATH/atrace.out
############################################################################################
	# save property
	getprop > $SAVE_LOG_PATH/getprop.txt
	echo "getprop > $SAVE_LOG_PATH/getprop.txt"
	echo "[savelogmtp] getprop "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################
	# dump audio codec register
	echo dump >/proc/driver/audio_debug
	echo "echo dump >/proc/driver/audio_debug"
	echo "[savelogmtp] audio_debug:"`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################
# mount logfs
#	chmod 777 /dev/block/bootdevice/by-name/logfs
	chmod 777 /vendor/logfs
#	log "wei +++++"
    	mount -t vfat /dev/block/bootdevice/by-name/logfs /vendor/logfs  
#	log "wei -----" 

###########################################################################################
	#add to stop and then capture modem log problem
############################################################################################
	# save cmdline
	cat /proc/cmdline > $SAVE_LOG_PATH/cmdline.txt
	echo "cat /proc/cmdline > $SAVE_LOG_PATH/cmdline.txt"	
	echo "[savelogmtp] cat /proc/cmdline:"`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################
	cat /sys/kernel/dload/dload_mode > $SAVE_LOG_PATH/dload_mode.txt
	cat /sys/module/msm_poweroff/parameters/download_mode > $SAVE_LOG_PATH/download_mode.txt
############################################################################################
	cat /d/wakeup_sources  > $SAVE_LOG_PATH/wakeup_sources.txt
###########################################################################################
	# save mount table
	cat /proc/mounts > $SAVE_LOG_PATH/mounts.txt
	echo "cat /proc/mounts > $SAVE_LOG_PATH/mounts.txt"
	echo "[savelogmtp] cat /proc/mounts "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################
	# save space used status
	df > $SAVE_LOG_PATH/df.txt
	echo "df > $SAVE_LOG_PATH/df.txt"
############################################################################################
	# save network info
	cat /proc/net/route > $SAVE_LOG_PATH/route.txt
	echo "route -n > $SAVE_LOG_PATH/route.txt"
	ifconfig -a > $SAVE_LOG_PATH/ifconfig.txt
	echo "ifconfig -a > $SAVE_LOG_PATH/ifconfig.txt"
	echo "[savelogmtp] cat /proc/net/route "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################
	# save software version
	echo "AP_VER: `getprop ro.build.display.id`" > $SAVE_LOG_PATH/version.txt
	echo "CP_VER: `getprop gsm.version.baseband`" >> $SAVE_LOG_PATH/version.txt
	echo "BT_VER: `getprop bt.version.driver`" >> $SAVE_LOG_PATH/version.txt
	echo "WIFI_VER: `getprop wifi.version.driver`" >> $SAVE_LOG_PATH/version.txt
	echo "WIFI_VER: `getprop wigig.version.driver`" >> $SAVE_LOG_PATH/version.txt
	echo "WIFI_VER: `getprop wigig.dock.version.driver`" >> $SAVE_LOG_PATH/version.txt
	echo "GPS_VER: `getprop gps.version.driver`" >> $SAVE_LOG_PATH/version.txt
	echo "BUILD_DATE: `getprop ro.build.date`" >> $SAVE_LOG_PATH/version.txt
############################################################################################
	# save load kernel modules
	lsmod > $SAVE_LOG_PATH/lsmod.txt
	echo "lsmod > $SAVE_LOG_PATH/lsmod.txt"
############################################################################################
	# save process now
	ps > $SAVE_LOG_PATH/ps.txt
	echo "ps > $SAVE_LOG_PATH/ps.txt"
	ps -t -p > $SAVE_LOG_PATH/ps_thread.txt
	echo "ps > $SAVE_LOG_PATH/ps_thread.txt"
############################################################################################
	# save kernel message
	dmesg > $SAVE_LOG_PATH/dmesg.txt
	echo "dmesg > $SAVE_LOG_PATH/dmesg.txt"
############################################################################################
	# copy data/log to data/media
	ls -R -l /data/log/ > $SAVE_LOG_PATH/ls_data_log.txt
	mkdir $SAVE_LOG_PATH/log
	#mv /data/log/* $SAVE_LOG_PATH/log/
	cp -r /data/log/* $SAVE_LOG_PATH/log/
	rm -r /data/log/* 

	echo "cp /data/log $SAVE_LOG_PATH"
	echo "[savelogmtp] cp /data/log/ "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################
	# copy data/tombstones to data/media
	ls -R -l /data/tombstones/ > $SAVE_LOG_PATH/ls_data_tombstones.txt
	mkdir $SAVE_LOG_PATH/tombstones
#	mv /data/tombstones/* $SAVE_LOG_PATH/tombstones/
	cp -r /data/tombstones/* $SAVE_LOG_PATH/tombstones/
	rm  -r /data/tombstones/* 
	echo "cp /data/tombstones $SAVE_LOG_PATH"	

############################################################################################
	mkdir $SAVE_LOG_PATH/FotaNetInfo
	cp -r /sdcard/FotaNetInfo/* $SAVE_LOG_PATH/FotaNetInfo/
	rm  -r /sdcard/FotaNetInfo/* 
############################################################################################
        ls -R -l /asdf > $SAVE_LOG_PATH/ls_asdf.txt
############################################################################################
	mkdir $SAVE_LOG_PATH/gpu
	cp -r /data/vendor/gpu/* $SAVE_LOG_PATH/gpu
	rm -r /data/vendor/gpu/* 
        ls -R -l /data/vendor/gpu > $SAVE_LOG_PATH/ls_vendor_gpu.txt
############################################################################################

	# copy data/tombstones to data/media
	#busybox ls -R -l /tombstones/mdm > $SAVE_LOG_PATH/ls_tombstones_mdm.txt
	mkdir -p /data/tombstones/dsps
	mkdir -p /data/tombstones/lpass
	mkdir -p /data/tombstones/mdm
	mkdir -p /data/tombstones/modem
	mkdir -p /data/tombstones/wcnss
	chown system.system /data/tombstones/*
	chmod 771 /data/tombstones/*
############################################################################################
	# copy Debug Ion information to data/media
	mkdir $SAVE_LOG_PATH/ION_Debug
	cp /d/ion/* $SAVE_LOG_PATH/ION_Debug/
############################################################################################
	# copy data/logcat_log to data/media
	ls -R -l /data/logcat_log/ > $SAVE_LOG_PATH/ls_data_logcat_log.txt
	cp -r /data/logcat_log $SAVE_LOG_PATH
	echo "cp -r /data/logcat_log $SAVE_LOG_PATH"
############################################################################################
	# copy /data/misc/bluetooth/logs/ to data/media
	ls -R -l /data/misc/bluetooth/logs/ > $SAVE_LOG_PATH/ls_data_btsnoop.txt
	cp -r /data/misc/bluetooth/logs/ $SAVE_LOG_PATH/logcat_log/btsnoop/
	echo "cp -r /data/misc/bluetooth/logs/ $SAVE_LOG_PATH/logcat_log/btsnoop/"
	cp -r /data/vendor/ssrdump/ $SAVE_LOG_PATH/logcat_log/btsnoop/
	echo "cp -r /data/vendor/ssrdump/ $SAVE_LOG_PATH/logcat_log/btsnoop/"
	rm -r /data/misc/bluetooth/logs/*.*
	rm -r /data/vendor/ssrdump/*.*
############################################################################################
	# copy recovery log to data/media
	if [ -d "/cache/recovery/" ]; then
		ls -R -l /cache/recovery > $SAVE_LOG_PATH/ls_cache_recovery.txt
		mkdir $SAVE_LOG_PATH/cache_recovery
		cp -r /cache/recovery/* $SAVE_LOG_PATH/cache_recovery/
		echo "cp -r /cache/recovery/ $SAVE_LOG_PATH"/cache_recovery/
	fi	
############################################################################################
	# copy /asdf/ASUSEvtlog.txt to ASDF
	cp -r /asdf $SAVE_LOG_PATH 
	cp -r /sdcard/asus_log/ASUSEvtlog.txt $SAVE_LOG_PATH #backward compatible
	cp -r /sdcard/asus_log/ASUSEvtlog_old.txt $SAVE_LOG_PATH #backward compatible
	cp -r /asdf/ASUSEvtlog.txt $SAVE_LOG_PATH
	cp -r /asdf/ASUSEvtlog_old.txt $SAVE_LOG_PATH
	cp -r /data/media/0/asus_log/tcpdump/ $SAVE_LOG_PATH
	cp -r /asdf/ASDF $SAVE_LOG_PATH && rm -r /asdf/ASDF/ASDF.*
	cp -r /asdf/dumpsys_meminfo $SAVE_LOG_PATH && rm -r /asdf/dumpsys_meminfo
	# copy dumpsys sensnorservice log for power issue
        cp -r /asdf/sensor/dumpsys_sensorservice.txt $SAVE_LOG_PATH && rm -r /asdf/sensor/dumpsys_sensorservice.txt
	echo "cp -r /asdf/ASUSEvtlog.txt $SAVE_LOG_PATH"
############################################################################################
	# capture cnss ipc logs
	cat /sys/kernel/debug/ipc_logging/pcie0-long/log > $SAVE_LOG_PATH/pcie0-long_host.txt
	cat /sys/kernel/debug/ipc_logging/pcie0-short/log > $SAVE_LOG_PATH/pcie0-short_host.txt
	cat /sys/kernel/debug/ipc_logging/pcie0-dump/log > $SAVE_LOG_PATH/pcie0-dump_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss/log > $SAVE_LOG_PATH/cnss_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-mhi/log > $SAVE_LOG_PATH/cnss_mhi_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-mhi-cntrl/log > $SAVE_LOG_PATH/cnss_mhi_host.txt
	cat /sys/kernel/debug/ipc_logging/cnss-long/log > $SAVE_LOG_PATH/cnss_long_host.txt
	echo "[savelogmtp] cat  ipc_logging  "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
	# capture cnss ipc logs
############################################################################################
	# capture wlan logs
	ls -R -l /data/vendor/wifi > $SAVE_LOG_PATH/ls_wifi_asus_log.txt

	cp -r /data/vendor/wifi/wpa/wpa_supplicant.conf $SAVE_LOG_PATH
	echo "cp -r /data/vendor/wifi/wpa/wpa_supplicant.conf $SAVE_LOG_PATH"

	cp -r /data/vendor/wifi/wpa/p2p_supplicant.conf $SAVE_LOG_PATH
	echo "cp -r /data/vendor/wifi/wpa/p2p_supplicant.conf $SAVE_LOG_PATH"

	# copy wlan configstore
	cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStore.xml $SAVE_LOG_PATH
	echo "cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStore.xml $SAVE_LOG_PATH"

	# copy softap configstore
	cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStoreSoftAp.xml $SAVE_LOG_PATH
	echo "cp -r /data/misc/apexdata/com.android.wifi/WifiConfigStoreSoftAp.xml $SAVE_LOG_PATH"

	# copy wlan configstore
	cp -r /data/misc/wifi/WifiViceConfigStore.xml $SAVE_LOG_PATH
	echo "cp -r /data/misc/wifi/WifiViceConfigStore.xml $SAVE_LOG_PATH"

	if [ -f "/data/vendor/wifi/hostapd/hostapd_wlan1.conf" ]; then
		cp -r /data/vendor/wifi/hostapd/hostapd_wlan1.conf $SAVE_LOG_PATH
		echo "cp -r /data/vendor/wifi/hostapd/hostapd_wlan1.conf $SAVE_LOG_PATH"
	fi

	if [ -f "/data/vendor/wifi/hostapd/hostapd_wlan2.conf" ]; then
		cp -r /data/vendor/wifi/hostapd/hostapd_wlan2.conf $SAVE_LOG_PATH
		echo "cp -r /data/vendor/wifi/hostapd/hostapd_wlan2.conf $SAVE_LOG_PATH"
	fi
	# copy wlan fw logs
	cp -r /data/vendor/wifi/wlan_logs $SAVE_LOG_PATH
	echo "cp -r /data/vendor/wifi/wlan_logs $SAVE_LOG_PATH"

############################################################################################
	# mv /data/anr to data/media
	ls -R -l /data/anr > $SAVE_LOG_PATH/ls_data_anr.txt
	mkdir $SAVE_LOG_PATH/anr
	#mv /data/anr/* $SAVE_LOG_PATH/anr/
	cp -r /data/anr/* $SAVE_LOG_PATH/anr/
	rm -r /data/anr/* 
	echo "cp /data/anr $SAVE_LOG_PATH"
############################################################################################
	# copy asusdbg(reset debug message) to /data/media
#	$BUSYBOX mkdir -p $SAVE_LOG_PATH/resetdbg
#	dd if=/dev/block/platform/msm_sdcc.1/by-name/ramdump of=$SAVE_LOG_PATH/resetdbg/kernelmessage.txt count=512
#	echo "copy asusdbg(reset debug message) to $SAVE_LOG_PATH/resetdbg"
############################################################################################
#is_ramdump_exist=`busybox cat /proc/cmdline | busybox grep RAMDUMP`
#if busybox test "$is_ramdump_exist"; then
#	dd if=/dev/block/platform/msm_sdcc.1/by-name/ramdump of=$SAVE_LOG_PATH/IMEM_C.BIN count=8 skip=512
#	dd if=/dev/block/platform/msm_sdcc.1/by-name/ramdump of=$SAVE_LOG_PATH/EBICS0.BIN count=2097152 skip=2048
#	echo "copy RAMDUMP.bin to $SAVE_LOG_PATH"
#fi	
############################################################################################
	# mv /data/media/ap_ramdump  to data/media
	ls -R -l /data/media/ap_ramdump > $SAVE_LOG_PATH/ls_data_media_ap_ramdump.txt
	mkdir $SAVE_LOG_PATH/ap_ramdump
	#mv /data/media/ap_ramdump/* $SAVE_LOG_PATH/ap_ramdump/
	cp -r /data/media/ap_ramdump/* $SAVE_LOG_PATH/ap_ramdump/
	rm -r /data/media/ap_ramdump/* 
	echo "cp /data/media/ap_ramdump $SAVE_LOG_PATH"
############################################################################################
	# save system information
	dumpsys SurfaceFlinger > $SAVE_LOG_PATH/surfaceflinger.dump.txt
	echo "dumpsys SurfaceFlinger > $SAVE_LOG_PATH/surfaceflinger.dump.txt"
	dumpsys window > $SAVE_LOG_PATH/window.dump.txt
	echo "dumpsys window > $SAVE_LOG_PATH/window.dump.txt"
	dumpsys activity > $SAVE_LOG_PATH/activity.dump.txt
	echo "dumpsys activity > $SAVE_LOG_PATH/activity.dump.txt"
	dumpsys power > $SAVE_LOG_PATH/power.dump.txt
	echo "dumpsys power > $SAVE_LOG_PATH/power.dump.txt"
	dumpsys input_method > $SAVE_LOG_PATH/input_method.dump.txt
	echo "dumpsys input_method > $SAVE_LOG_PATH/input_method.dump.txt"
	dumpsys meminfo > $SAVE_LOG_PATH/meminfo.dump.txt
	date > $SAVE_LOG_PATH/date.txt
	echo "date > $SAVE_LOG_PATH/date.txt"
	echo "[savelogmtp] dumpsys surfaceflinger "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################	
       # copy usb_debug
       mkdir $SAVE_LOG_PATH/usb_debug/
       cat /d/ipc_logging/a600000.dwc3/log > $SAVE_LOG_PATH/usb_debug/log_dwc3_usb1.txt
       cat /d/ipc_logging/a800000.dwc3/log > $SAVE_LOG_PATH/usb_debug/log_dwc3_usb2.txt
       cat /d/ipc_logging/ucsi/log > $SAVE_LOG_PATH/usb_debug/ucsi.txt
######################################################################################
	# save charger information
	mkdir $SAVE_LOG_PATH/charger_debug/
	echo 256 > /d/regmap/spmi0-03/count
	echo 0x2600 > /d/regmap/spmi0-03/address
	cat /d/regmap/spmi0-03/data > $SAVE_LOG_PATH/charger_debug/pm8350b_reg.txt
	echo 0x2700 > /d/regmap/spmi0-03/address
	cat /d/regmap/spmi0-03/data >> $SAVE_LOG_PATH/charger_debug/pm8350b_reg.txt
	echo 0x2800 > /d/regmap/spmi0-03/address
	cat /d/regmap/spmi0-03/data >> $SAVE_LOG_PATH/charger_debug/pm8350b_reg.txt
	echo 0x2900 > /d/regmap/spmi0-03/address
	cat /d/regmap/spmi0-03/data >> $SAVE_LOG_PATH/charger_debug/pm8350b_reg.txt
	echo 0x2B00 > /d/regmap/spmi0-03/address
	cat /d/regmap/spmi0-03/data >> $SAVE_LOG_PATH/charger_debug/pm8350b_reg.txt
	echo 0x2C00 > /d/regmap/spmi0-03/address
	cat /d/regmap/spmi0-03/data >> $SAVE_LOG_PATH/charger_debug/pm8350b_reg.txt
        echo 0x3C00 > /d/regmap/spmi0-03/address
	cat /d/regmap/spmi0-03/data >> $SAVE_LOG_PATH/charger_debug/pm8350b_reg.txt
        #cat /d/regmap/spmi0-03/registers >> $SAVE_LOG_PATH/charger_debug/pm8350b_reg_2.txt

	echo 2560 > /d/regmap/spmi3-0b/count
	echo 0x2600 > /d/regmap/spmi3-0b/address
	cat /d/regmap/spmi3-0b/data > $SAVE_LOG_PATH/charger_debug/sbm1396_reg.txt
        #cat /d/regmap/spmi2-0b/registers > $SAVE_LOG_PATH/charger_debug/sbm1396_2_reg.txt
	cat /sys/class/power_supply/*/uevent > $SAVE_LOG_PATH/charger_debug/uevent.txt
	cat /sys/class/asuslib/get_ChgPD_FW_Ver > $SAVE_LOG_PATH/charger_debug/ChgPD_Ver.txt

	# save charger information for user
	cat /proc/driver/pm8350b_reg_dump > $SAVE_LOG_PATH/charger_debug/pm8350b_reg_user.txt
	cat /proc/driver/smb1396_reg_dump > $SAVE_LOG_PATH/charger_debug/smb1396_reg_user.txt
	echo "[savelogmtp] cat proc/driver/pm8350b "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
############################################################################################
	# save sleep information
	cat /sys/power/rpmh_stats/master_stats > $SAVE_LOG_PATH/charger_debug/master_stats.txt
	cat /sys/power/system_sleep/stats > $SAVE_LOG_PATH/charger_debug/system_sleep.txt
############################################################################################
	# save debug report
	dumpsys -t 30 > $SAVE_LOG_PATH/bugreport.txt
	echo "dumpsys > $SAVE_LOG_PATH/bugreport.txt"
############################################################################################
        for fname in /asdf/ASUSSlowg*
        do
                if [ -e $fname ]; then
                        echo "$fname found!" >/dev/kmsg
                        rm $fname
                fi
        done
############################################################################################

	# copy modem logs
	# copy subsystem ramdumps
	cp -r /data/media/0/diag_logs/QXDM_logs/ $SAVE_LOG_PATH
	rm -r /data/media/0/diag_logs/QXDM_logs/ 
	ls -R -l /data/vendor/ramdump/ssr_ramdump > $SAVE_LOG_PATH/ls_ssr_ramdump.txt
	cp -r /data/vendor/ramdump/ssr_ramdump/ $SAVE_LOG_PATH
	rm -r  /data/vendor/ramdump/ssr_ramdump/
	echo "cp -r /data/vendor/ramdump/ssr_ramdump $SAVE_LOG_PATH"

	# copy /asdf/SubSysMedicalTable.txt
	cp -r /asdf/SubSysMedicalTable.txt $SAVE_LOG_PATH
	cp -r /asdf/SubSysMedicalTable_old.txt $SAVE_LOG_PATH
	echo "cp -r /asdf/SubSysMedicalTable.txt $SAVE_LOG_PATH"

	#add to stop and then capture modem log problem
############################################################################################
        micropTest=`cat /sys/class/switch/pfs_pad_ec/state`
	if [ "${micropTest}" = "1" ]; then
	date > $SAVE_LOG_PATH/microp_dump.txt
	 cat /d/gpio >> $SAVE_LOG_PATH/microp_dump.txt                   
        echo "cat /d/gpio > $SAVE_LOG_PATH/microp_dump.txt"  
        cat /d/microp >> $SAVE_LOG_PATH/microp_dump.txt
        echo "cat /d/microp > $SAVE_LOG_PATH/microp_dump.txt"
	fi
############################################################################################
# copy /data/misc/bluetooth/logs/ to data/media
ls -R -l /data/misc/bluetooth/logs > $SAVE_LOG_PATH/ls_data_btsnoop.txt
cp -r /data/misc/bluetooth/logs/* $SAVE_LOG_PATH/logcat_log/btsnoop/
echo "cp -r /data/misc/bluetooth/logs $SAVE_LOG_PATH/logcat_log/btsnoop/"
############################################################################################
#	timeout 5 cat /d/tzdbg/log > $SAVE_LOG_PATH/tz_log.txt
#	timeout 5 cat /d/tzdbg/qsee_log > $SAVE_LOG_PATH/qsee_log.txt
	timeout 5 cat /proc/tzdbg/log > $SAVE_LOG_PATH/tz_log.txt
	timeout 5 cat /proc/tzdbg/qsee_log > $SAVE_LOG_PATH/qsee_log.txt
############################################################################################
	cp -r /data/misc/grip $SAVE_LOG_PATH 
#	cp -r /vendor/factory  $SAVE_LOG_PATH 
#        dumpstate -q -d -z  -o $SAVE_LOG_PATH/bugreport

       vmstat 1 5 > $SAVE_LOG_PATH/vmstat.txt

	mkdir $SAVE_LOG_PATH/Power_Err_log
	cp /asdf/ASUS_*.txt $SAVE_LOG_PATH/Power_Err_log
	
	cp -r /vendor/logfs $SAVE_LOG_PATH 

##############################################################################################

	cp -r /data/misc/update_engine_log $SAVE_LOG_PATH/
##############################################################################################
	cp -r /sdcard/mocmna $SAVE_LOG_PATH/
##############################################################################################
	mkdir $SAVE_LOG_PATH/tencent
	chmod 777 $SAVE_LOG_PATH/tencent
	

	for pid in `ps -ef | grep "tencent"| awk '{print $2}'` ; do 
		name=`cat /proc/$pid/comm`
		pmap $pid > $SAVE_LOG_PATH/tencent/${name}_pmap.txt
		cat /proc/$pid/maps > $SAVE_LOG_PATH/tencent/${name}_maps.txt
		cat /proc/$pid/smaps > $SAVE_LOG_PATH/tencent/${name}_smaps.txt
	done

	for pid in `ps -ef | grep "audioserver"| awk '{print $2}'` ; do 
		name=`cat /proc/$pid/comm`
		pmap $pid > $SAVE_LOG_PATH/tencent/${name}_pmap.txt
		cat /proc/$pid/maps > $SAVE_LOG_PATH/tencent/${name}_maps.txt
		cat /proc/$pid/smaps > $SAVE_LOG_PATH/tencent/${name}_smaps.txt
	done
	
	for pid in `ps -ef | grep "system_server"| awk '{print $2}'` ; do 
		name=`cat /proc/$pid/comm`
		pmap $pid > $SAVE_LOG_PATH/tencent/${name}_pmap.txt
		cat /proc/$pid/maps > $SAVE_LOG_PATH/tencent/${name}_maps.txt
		cat /proc/$pid/smaps > $SAVE_LOG_PATH/tencent/${name}_smaps.txt
	done

##############################################################################################
dd if=/dev/block/bootdevice/by-name/rawdump  of=/data/vendor/ramdump/ramdump_header.txt bs=4 count=2

var=$(cat /data/vendor/ramdump/ramdump_header.txt)
if test "$var" = "Raw_Dmp!"
then
        #echo Found Raw Ram Dump!
        #echo Start to dump...
        dd if=/dev/block/bootdevice/by-name/rawdump of=/data/vendor/ramdump/RawRamDump.bin

        tar -czvf $SAVE_LOG_PATH/RawRamDump.tgz /data/vendor/ramdump/RawRamDump.bin

        rm /data/vendor/ramdump/RawRamDump.bin
        rm /data/vendor/ramdump/ramdump_header.txt
        dd if=/dev/zero of=/dev/block/bootdevice/by-name/rawdump bs=4 count=2

        #am broadcast -a android.intent.action.MEDIA_MOUNTED --ez read-only false -d file:///storage/emulated/0/ -p com.android.providers.media
        #echo Finish!
#else
        #echo Not Found Raw Ram Dump.
fi
#
##############################################################################################

dd if=/dev/block/bootdevice/by-name/ftm of=/data/vendor/ramdump/miniramdump_header.txt bs=4 count=2

var=$(cat /data/vendor/ramdump/miniramdump_header.txt)
if test "$var" = "MiniDump"
then
	#echo Found Raw Ram Dump!
	#echo Start to dump...
	echo "Raw_Dmp!" > /data/vendor/ramdump/miniramdump_header.txt
	dd if=/data/vendor/ramdump/miniramdump_header.txt of=/dev/block/bootdevice/by-name/ftm bs=4 count=2
	dd if=/dev/block/bootdevice/by-name/ftm of=/data/vendor/ramdump/MiniRawRamDump.bin

	tar -czvf $SAVE_LOG_PATH/MiniRawRamDump.tgz /data/vendor/ramdump/MiniRawRamDump.bin

	rm /data/vendor/ramdump/MiniRawRamDump.bin
	rm /data/vendor/ramdump/miniramdump_header.txt
	dd if=/dev/zero of=/dev/block/bootdevice/by-name/ftm bs=4 count=2

	#am broadcast -a android.intent.action.MEDIA_MOUNTED --ez read-only false -d file:///storage/emulated/0/ -p com.android.providers.media 
	#echo Finish!
#else
	#echo Not Found Raw Ram Dump.
fi

##############################################################################################
dd if=/dev/block/bootdevice/by-name/misc  of=$SAVE_LOG_PATH/misc.bin bs=1024 count=1024
cp -r /metadata/ota $SAVE_LOG_PATH

	# sync data to disk 
	# 1015 sdcard_rw

        bugreportz > $SAVE_LOG_PATH/bugreportz_log.txt
        for filename in $BUGREPORT_PATH/*; do
            name=${filename##*/}
        #   cp $filename  $GENERAL_LOG/$name
            cp $filename  $SAVE_LOG_PATH/$name
            rm $filename
        done

	enableQXDM=`getprop persist.logd.qxdmlog.enable`
	if [ "${enableQXDM}" = "1" ]; then
	    setprop persist.logd.qxdmlog.enable 0
	    echo "Turn off QXDM log for savelogmtp"
	    sleep 1
	    sync
	fi

	tar zcvf $SAVE_LOG_PATH.tar.gz $SAVE_LOG_PATH
	rm -rf $SAVE_LOG_PATH
	mkdir $SAVE_LOG_PATH
	mv $SAVE_LOG_PATH.tar.gz $SAVE_LOG_PATH


	echo "[savelogmtp] QXDM "`date` >> $SAVE_LOG_PATH/captureLogTime.txt
	ls -R -l /data/vendor/ramdump/diag_logs > $SAVE_LOG_PATH/ls_diag_logs.txt
	cp -r /data/vendor/ramdump/diag_logs/ $SAVE_LOG_PATH
	rm -r /data/vendor/ramdump/diag_logs/
	echo "cp -r /data/vendor/ramdump/diag_logs/ $SAVE_LOG_PATH"

	if [ "${enableQXDM}" = "1" ]; then
	    setprop persist.logd.qxdmlog.enable 1
	    echo "Turn on QXDM log for savelogmtp"
	fi

 
	chmod -R 777 $SAVE_LOG_PATH
	chmod -R 777 $SAVE_LOG_ROOT
	sync
am broadcast -a android.intent.action.MEDIA_MOUNTED --ez read-only false -d file:///storage/emulated/0/ -p com.android.providers.media -f 0x01000000

############################################################################################
for i in 1 2 3
do
echo 1500 > /sys/class/timed_output/vibrator/enable
sleep 2
done


