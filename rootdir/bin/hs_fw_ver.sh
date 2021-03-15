#!/vendor/bin/sh
echo fw > /proc/driver/audio_debug
cat /proc/driver/audio_debug
