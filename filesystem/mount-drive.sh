#!/bin/bash

# f:verb=run f:name=mount-drive

set -eo xtrace

if [ uname -eq "Darwin" ]; then
  echo "This script is for Linux only"
  exit 1
fi

# Find drive
sudo fdisk -l
read -p "Enter drive to mount: " DRIVE

# Name drive
read -p "Enter name for drive mount: " DRIVE_NAME

# Mount drive
sudo mkdir -p ${LOCAL_MOUNT_DIR}/${DRIVE_NAME}
sudo mount -o rw,user,uid=1000,umask=007,exec /dev/${DRIVE} "/mnt/${DRIVE_NAME}"
# sudo chown -R ${USER}:${USER} ${LOCAL_MOUNT_DIR}/${DRIVE_NAME}
# sudo chmod -R 777 ${LOCAL_MOUNT_DIR}/${DRIVE_NAME}

# Verify mount
echo "!!! Listing Contents. Please Verify. !!!"
df -h
ls -la "/mnt/${DRIVE_NAME}"

