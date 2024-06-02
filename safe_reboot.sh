#!/bin/bash

#VM
VMIDs=$(/usr/sbin/qm list | grep running | awk '/[0-9]/ {print $1}')
for VM in $VMIDs
do
    /usr/sbin/qm shutdown $VM
done

for VM in $VMIDs
do
    while [[ $(/usr/sbin/qm status $VM) =~ running ]] ; do
        sleep 1
    done
done

#CT
VMIDs=$(/usr/sbin/pct list | grep running | awk '/[0-9]/ {print $1}')
for VM in $VMIDs
do
    /usr/sbin/pct shutdown $VM
done
COUNT = 0
for VM in $VMIDs
do
    while [[ $(/usr/sbin/pct status $VM) =~ running ]] ; do
        sleep 1
        COUNT = $((COUNT+1))
        IF (( $COUNT > 30 )) ; then
            /usr/sbin/pct stop $VM
            COUNT = 0
        fi
    done
    COUNT = 0
done

# Just to be safe
sleep 30

# Do Reboot
/sbin/shutdown -r now
