#!/bin/bash


HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $1}')
#CPU=$(lscpu | grep -w "CPU(s):" | sed -n "1p")
CPU=$(lscpu | grep -w "CPU(s):" | awk 'FNR == 1 {print""$1,$2}')
RAM=$(free -h | grep -i mem | awk '{print $1 $2}')
DISK=$(lsblk | grep -Ew 'sda|sdb|vda' | awk '{print $1 "   " $4}')


#BACKU SERVER DETAILS
BACKUP_SRV_IP=192.168.7.22
BACKUP_PATH=/rear-backup 



log_file=/var/log/rear/$HOSTNAME.log

#delete old bkps
find /tmp/rear* -type d -ctime +0 -exec rm -rf {} \;
find /var/tmp/rear* -type d -ctime +0 -exec rm -rf {} \;

echo "Hostname:- $HOSTNAME" > /opt/output.txt
echo "IP:- $IP" >> /opt/output.txt
echo "Start:- `date`" >> /opt/output.txt

/usr/sbin/rear -v -d mkbackup #> /dev/null

#ls 

suc=$?

if [ $suc -eq 0 ];

then

echo "End:- `date`" >> /opt/output.txt

echo "Status:- $HOSTNAME Rear Backup successfully done" >> /opt/output.txt

echo "Specifications:- Number of cpu = $CPU, Ram Size = $RAM, Harddisk Size = $DISK" >> /opt/output.txt


else

echo "End:- `date`" >> /opt/output.txt

echo "Status:- $HOSTNAME Rear Backup failed" >> /opt/output.txt

echo "Specification:- Number of cpu = $CPU, Ram Size = $RAM, Harddisk Size = $DISK" >> /opt/output.txt



fi


#delete old bkps
#find /tmp/rear* -exec rm -rf {} \;
#find /var/tmp/rear* -exec rm -rf {} \;

echo "Backup distination : nfs://$BACKUP_SRV_IP$BACKUP_PATH "  >> /opt/output.txt

#echo $suc >> /opt/output.txt

#echo "----------------------------------------------------------------------" >> /opt/output.txt




