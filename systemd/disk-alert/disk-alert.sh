#!/bin/bash
source .env

# konfirgurasi
TOKEN=$TOKEN
CHAT_ID=$CHAT_ID
BATAS_BAHAYA=$BATAS_BAHAYA

# cek penggunaan disk
DISK_USAGE=$(df -h | awk 'NR==2 {print $5}' | tr -d '%')

# kirim telegram
kirim_telegram(){
  PESAN=$1
  URL="https://api.telegram.org/bot$TOKEN/sendMessage"

  curl -s -d "chat_id=$CHAT_ID&text=$PESAN" "$URL" > /dev/null
}

# logic utama
if [ "$DISK_USAGE" -ge "$BATAS_BAHAYA" ]; then
  echo "[BAHAYA] Disk penuh, penggunaan disk saat ini $DISK_USAGE"
  kirim_telegram "🚨 DARURAT BOS! Server mau meledak. Disk sisa dikit: ${DISK_USAGE}%"

else
  kirim_telegram "aman bos"
fi
