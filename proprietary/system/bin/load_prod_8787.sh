#!/system/bin/sh

rmmod bt8xxx
rmmod sd8xxx
rmmod mlan

echo 0 > /sys/class/rfkill/rfkill0/state
echo 1 > /sys/class/rfkill/rfkill0/state

insmod /system/lib/modules/mlan.ko
insmod /system/lib/modules/sd8xxx.ko
insmod /system/lib/modules/mbt8xxx.ko

ifconfig mlan0 up
hciconfig hci0 up
