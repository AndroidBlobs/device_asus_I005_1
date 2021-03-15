#!/vendor/bin/sh
echo driver > /proc/driver/audio_debug
cat /proc/driver/audio_debug
