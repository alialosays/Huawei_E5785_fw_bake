#!/system/bin/busyboxx sh

mkdir bin
ln -s /system/bin/sh /bin/sh

busybox echo 0 > /proc/sys/net/netfilter/nf_conntrack_checksum

temp=$(cat /sys/class/power_supply/battery/temp)
if [ $temp -eq -30 ]; then
	echo -ne '\x00\x00\x82\xe5' | dd of=/dev/mem bs=1 seek=2797765824
fi

/app/webroot/webui_init1.sh

g_bAtDataLocked=`grep -w -m1 "g_bAtDataLocked" /proc/kallsyms`
addr=0x${g_bAtDataLocked:0:8}
dd if=/dev/zero of=/dev/kmem bs=1 seek=$((addr)) count=4

/system/etc/fix_ttl.sh

/etc/huawei_process_start

mv /sbin/adbd /sbin/adbd~

#busyboxx telnetd -l /bin/sh
#adbd &

mkdir -p /data/dropbear
dropbear -R

/app/webroot/webui_init2.sh
