#!/bin/bash

rm -rf /var/lib/jenkins/workspace/rear-bkp/mails/new.txt 


#mail variables

SMTP_HOST=apmosys.icewarpcloud.in
SMTP_PORT=587
SMTP_AUTH_MAILID='admin@apmosys.com'
#SMTP_AUTH_PASSWD=$(cat /root/mails/.secret_vault.txt | openssl enc -aes-256-cbc -md sha512 -a -d -pbkdf2 -iter 100000 -salt -pass pass:'secret#vault!password')
SENDER_MAILID='admin@apmosys.com'
RECEIVER_MAILID='mohamed.rafik@apmosys.com awais.khan@apmosys.com admin@apmosys.com mohamed.rafik@apmosys.com'
SMTP_AUTH_PASSWD='password'

date=$(date)

#array defined

array_ips=("192.168.12.84" "192.168.12.86" "192.168.12.45" "192.168.12.46" "192.168.0.151" "192.168.12.48" "192.168.12.58" "192.168.0.128" "192.168.12.49" "192.168.12.68" "192.168.12.67" "192.168.12.92" "192.168.12.97" "192.168.12.17" "192.168.21.195" "192.168.12.54" "192.168.12.32" "192.168.12.37" "192.168.12.36" "192.168.21.175" "192.168.12.24" "192.168.12.71" "192.168.12.93" "192.168.21.78")

#array_ips=("192.168.12.77" "192.168.12.44" "192.168.3.83")

#array used to scp files

#for i in "${array_ips[@]}"

#do

#rsync -arvz -e 'ssh -p 22' --progress  $i:/tmp/output.txt /home/ansible/mail/$i.txt

#done

#array used to combine all files in new.txt


for i in "${!array_ips[@]}"
do
echo "====================================================================" >> /var/lib/jenkins/workspace/rear-bkp/mails/new.txt
echo "IMAGE BACKUP $i" >> /var/lib/jenkins/workspace/rear-bkp/mails/new.txt
cat /var/lib/jenkins/workspace/rear-bkp/mails/${array_ips[$i]}.txt >> /var/lib/jenkins/workspace/rear-bkp/mails/new.txt
done


#backup log mail

#if backup fails.

fail=$(cat /var/lib/jenkins/workspace/rear-bkp/mails/new.txt | grep -w failed)

#if fail variable is not empty then trigger this or else
if [[ -n "$fail" ]]

then

cat /var/lib/jenkins/workspace/rear-bkp/mails/new.txt | mailx -s "Failed Image backup $date"   -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login  -S smtp=smtp://$SMTP_HOST:$SMTP_PORT -S from="$SENDER_MAILID" -S smtp-auth-user=$SMTP_AUTH_MAILID -S smtp-auth-password=$SMTP_AUTH_PASSWD -S nss-config-dir=/etc/pki/nssdb/  $RECEIVER_MAILID

#exit 1 # this code means OK


#if backup is successful

else

cat /var/lib/jenkins/workspace/rear-bkp/mails/new.txt | mailx -s "Successful Image backup done $date"   -S smtp-use-starttls -S ssl-verify=ignore -S smtp-auth=login  -S smtp=smtp://$SMTP_HOST:$SMTP_PORT -S from="$SENDER_MAILID" -S smtp-auth-user=$SMTP_AUTH_MAILID -S smtp-auth-password=$SMTP_AUTH_PASSWD -S nss-config-dir=/etc/pki/nssdb/  $RECEIVER_MAILID

#exit 1 # this code means OK

fi



