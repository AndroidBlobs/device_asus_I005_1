#!/system/bin/sh

LOG_TAG="antennaSwap"

ANTENNA_PROPERTY="vendor.odm.tel.antenna.state"
mState=`getprop $ANTENNA_PROPERTY`

do_pull_low() {
    log -t $LOG_TAG "pull gpio low"
    echo '0' > /sys/devices/platform/soc/soc:qcom,ipa_fws/antennaSwap
}

do_pull_high() {
    log -t $LOG_TAG "pull gpio high"
    echo '1' > /sys/devices/platform/soc/soc:qcom,ipa_fws/antennaSwap
}

if [ ! -z "$mState" ] ; then
    if [ "$mState" == "1" ]; then
        do_pull_high
    elif [ "$mState" == "0" ]; then
        do_pull_low
    fi
fi
