#!/system/bin/sh

rmmod sd8xxx
rmmod mlan

mount -o rw,remount /data
echo "script ran" > /data/test.txt
echo "$(date)" >> /data/test.txt
echo "" >> /data/test.txt
lsmod >> /data/test.txt
echo "" >> /data/test.txt
/system/bin/mrvl_dut >> /data/test.txt
ifconfig wlan0 up >> /data/test.txt
setprop wifi.interface.online 1
echo "" >> /data/test.txt
lsmod >> /data/test.txt
