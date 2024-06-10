#!/bin/bash

# Detach loop devices
sudo losetup -d /dev/loop0
sudo losetup -d /dev/loop1
sudo losetup -d /dev/loop2
sudo losetup -d /dev/loop3
sudo losetup -d /dev/loop4
sudo losetup -d /dev/loop5
sudo losetup -d /dev/loop6

# Remove virtual disks
sudo rm /mnt/raid0-disk1.img
sudo rm /mnt/raid0-disk2.img
sudo rm /mnt/raid1-disk1.img
sudo rm /mnt/raid1-disk2.img
sudo rm /mnt/raid5-disk1.img
sudo rm /mnt/raid5-disk2.img
sudo rm /mnt/raid5-disk3.img
