#!/bin/bash

# Simulate disk failure in RAID 1
sudo mdadm /dev/md1 --fail /dev/loop2
sudo mdadm /dev/md1 --remove /dev/loop2
sudo dd if=/dev/zero of=/mnt/raid1-disk3.img bs=1M count=500
sudo losetup /dev/loop7 /mnt/raid1-disk3.img
sudo mdadm /dev/md1 --add /dev/loop7

# Simulate disk failure in RAID 5
sudo mdadm /dev/md2 --fail /dev/loop5
sudo mdadm /dev/md2 --remove /dev/loop5
sudo dd if=/dev/zero of=/mnt/raid5-disk4.img bs=1M count=500
sudo losetup /dev/loop8 /mnt/raid5-disk4.img
sudo mdadm /dev/md2 --add /dev/loop8

# Monitor rebuild process
watch -n 1 cat /proc/mdstat
