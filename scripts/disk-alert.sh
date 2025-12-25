#!/bin/bash

#cek penggunaan
DISK_USAGE=$(df -h| awk 'NR==2{print $5}' | tr -d '%')

BATAS_BAHAYA=90

if [ "$DISK_USAGE" -ge "$BATAS_BAHAYA" ]; then
    echo "Disk hampir penuh! penggunaan disk saat ini: $DISK_USAGE"
else
    echo "Disk aman, penggunaan disk saat ini: $DISK_USAGE"
fi
