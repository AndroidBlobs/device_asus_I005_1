#!/vendor/bin/sh

inbox_card_id="Audio"
inbox_state=`cat /proc/asound/$inbox_card_id/state` > /dev/null 2>&1

if [ "$inbox_state" == "ONLINE" ]; then
    echo "1"
else
    echo "0"
fi
