#!/bin/bash

# RAID 0 Configuration
sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/loop0 /dev/loop1
sudo mkfs.ext4 /dev/md0
sudo mkdir -p /mnt/raid0
sudo mount /dev/md0 /mnt/raid0

# RAID 1 Configuration
sudo mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/loop2 /dev/loop3
sudo mkfs.ext4 /dev/md1
sudo mkdir -p /mnt/raid1
sudo mount /dev/md1 /mnt/raid1

# RAID 5 Configuration
sudo mdadm --create --verbose /dev/md2 --level=5 --raid-devices=3 /dev/loop4 /dev/loop5 /dev/loop6
sudo mkfs.ext4 /dev/md2
sudo mkdir -p /mnt/raid5
sudo mount /dev/md2 /mnt/raid5
