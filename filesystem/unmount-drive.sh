#!/bin/bash

# f:verb=run f:name=mount-drive

set -eo xtrace

if [ uname -eq "Darwin" ]; then
  echo "This script is for Linux only"
  exit 1
fi

# Find Drive
df -h
read -p "Enter drive to unmount: " DRIVE_NAME

# Unmount drive
sudo umount "/mnt/${DRIVE_NAME}"