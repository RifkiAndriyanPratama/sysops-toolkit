#!/bin/bash

echo "Update Arch"
echo "Restore Point (Backup)"
sudo timeshift --create --comments "Backup sebelum update $(date +%Y-%m-%d)"

#cek backup
if [ $? -eq 0 ]; then
    echo "Backup sukses"
else 
    echo "Backup gagal, update dihentikan"
    exit 1
fi

#update
echo "Mengupdate sistem"
sudo pacman -Syu

#bersih bersih
sudo pacman -Sc --noconfirm

echo "Update selesai"
