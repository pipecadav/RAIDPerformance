#!/bin/bash

# Create virtual disks
sudo dd if=/dev/zero of=/mnt/raid0-disk1.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid0-disk2.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid1-disk1.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid1-disk2.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid5-disk1.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid5-disk2.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid5-disk3.img bs=1M count=500

# Setup loop devices
sudo losetup /dev/loop0 /mnt/raid0-disk1.img
sudo losetup /dev/loop1 /mnt/raid0-disk2.img
sudo losetup /dev/loop2 /mnt/raid1-disk1.img
sudo losetup /dev/loop3 /mnt/raid1-disk2.img
sudo losetup /dev/loop4 /mnt/raid5-disk1.img
sudo losetup /dev/loop5 /mnt/raid5-disk2.img
sudo losetup /dev/loop6 /mnt/raid5-disk3.img
