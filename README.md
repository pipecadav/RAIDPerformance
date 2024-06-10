# RAID Configuration and Performance Evaluation

## Overview

This project evaluates the performance, data redundancy, and rebuild times of different RAID configurations (RAID 0, RAID 1, and RAID 5) using virtual disks on an Ubuntu system. By leveraging software-based RAID management tools and benchmarking tools, we simulated real-world scenarios to provide comprehensive insights into the efficiency and reliability of each RAID level.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [RAID Configuration](#raid-configuration)
- [Workload Generation](#workload-generation)
- [Performance Measurement](#performance-measurement)
- [Data Redundancy Testing](#data-redundancy-testing)
- [Results and Analysis](#results-and-analysis)
- [Conclusion](#conclusion)

## Prerequisites

Ensure you have the following installed on your Ubuntu system:
- `mdadm`
- `fio`

## Setup

### Create Virtual Disks
Create six 500MB virtual disks to simulate physical disks:

```sh
# Create virtual disks
sudo dd if=/dev/zero of=/mnt/raid0-disk1.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid0-disk2.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid1-disk1.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid1-disk2.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid5-disk1.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid5-disk2.img bs=1M count=500
sudo dd if=/dev/zero of=/mnt/raid5-disk3.img bs=1M count=500
```
### Set Up Loop Devices
Attach the virtual disks to loop devices:

```sh
# Setup loop devices
sudo losetup /dev/loop0 /mnt/raid0-disk1.img
sudo losetup /dev/loop1 /mnt/raid0-disk2.img
sudo losetup /dev/loop2 /mnt/raid1-disk1.img
sudo losetup /dev/loop3 /mnt/raid1-disk2.img
sudo losetup /dev/loop4 /mnt/raid5-disk1.img
sudo losetup /dev/loop5 /mnt/raid5-disk2.img
sudo losetup /dev/loop6 /mnt/raid5-disk3.img
```

## RAID Configuration

### RAID 0 Configuration
```sh
# Create RAID 0 array
sudo mdadm --create --verbose /dev/md0 --level=0 --raid-devices=2 /dev/loop0 /dev/loop1
# Format the RAID array
sudo mkfs.ext4 /dev/md0
# Mount the RAID array
sudo mkdir -p /mnt/raid0
sudo mount /dev/md0 /mnt/raid0
```
### RAID 1 Configuration
```sh
# Create RAID 1 array
sudo mdadm --create --verbose /dev/md1 --level=1 --raid-devices=2 /dev/loop2 /dev/loop3
# Format the RAID array
sudo mkfs.ext4 /dev/md1
# Mount the RAID array
sudo mkdir -p /mnt/raid1
sudo mount /dev/md1 /mnt/raid1
```

### RAID 5 Configuration
```sh
# Create RAID 5 array
sudo mdadm --create --verbose /dev/md2 --level=5 --raid-devices=3 /dev/loop4 /dev/loop5 /dev/loop6
# Format the RAID array
sudo mkfs.ext4 /dev/md2
# Mount the RAID array
sudo mkdir -p /mnt/raid5
sudo mount /dev/md2 /mnt/raid5
```

## Workload Generation
We used `fio` to generate synthetic workloads simulating typical read and write operations.

### Create `fio` Job Files

#### RAID 0
```sh
echo "
[global]
ioengine=libaio
bs=4k
size=250M
direct=1
runtime=60
time_based
numjobs=4
group_reporting

[read]
rw=randread
filename=/mnt/raid0/testfile

[write]
rw=randwrite
filename=/mnt/raid0/testfile
" > raid0.fio
```

#### RAID 1
```sh
echo "
[global]
ioengine=libaio
bs=4k
size=250M
direct=1
runtime=60
time_based
numjobs=4
group_reporting

[read]
rw=randread
filename=/mnt/raid1/testfile

[write]
rw=randwrite
filename=/mnt/raid1/testfile
" > raid1.fio
```

#### RAID 5
```sh
echo "
[global]
ioengine=libaio
bs=4k
size=250M
direct=1
runtime=60
time_based
numjobs=4
group_reporting

[read]
rw=randread
filename=/mnt/raid5/testfile

[write]
rw=randwrite
filename=/mnt/raid5/testfile
" > raid5.fio
```

### Run `fio` Benchmarks
Run the benchmarks and save the results:

```sh
# Run fio benchmarks
sudo fio raid0.fio > raid0_result.txt
sudo fio raid1.fio > raid1_result.txt
sudo fio raid5.fio > raid5_result.txt
```

## Performance Measurement

Extract key performance metrics from the `fio` results and compile them into a table for comparison.

|RAID Level	|Read IOPS	|Write IOPS	|Read Throughput (MB/s)	|Write Throughput (MB/s)|
|RAID 0	|82.9k	|81.0k	|340 MB/s	|332 MB/s|
|RAID 1	|62.1k	|43.7k	|254 MB/s	|179 MB/s|
|RAID 5	|95.1k	|26.4k	|389 MB/s	|108 MB/s|


## Data Redundancy Testing

Simulate disk failures within the RAID 1 and RAID 5 configurations to observe the impact on data redundancy and availability.

### RAID 1 Disk Failure Simulation
```sh
# Simulate disk failure in RAID 1
sudo mdadm /dev/md1 --fail /dev/loop2
sudo mdadm /dev/md1 --remove /dev/loop2
# Add a new disk to the array
sudo dd if=/dev/zero of=/mnt/raid1-disk3.img bs=1M count=500
sudo losetup /dev/loop7 /mnt/raid1-disk3.img
sudo mdadm /dev/md1 --add /dev/loop7
```

### RAID 5 Disk Failure Simulation
```sh
# Simulate disk failure in RAID 5
sudo mdadm /dev/md2 --fail /dev/loop5
sudo mdadm /dev/md2 --remove /dev/loop5
# Add a new disk to the array
sudo dd if=/dev/zero of=/mnt/raid5-disk4.img bs=1M count=500
sudo losetup /dev/loop8 /mnt/raid5-disk4.img
sudo mdadm /dev/md2 --add /dev/loop8
```

### Monitor Rebuild Process
Monitor the rebuild process to ensure data redundancy is restored:

```sh
watch -n 1 cat /proc/mdstat
```
