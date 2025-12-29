#!/bin/bash

DOMAIN="rifki.test"
DIR="/var/www/$DOMAIN/html"
CONFIG_FILE="/etc/nginx/sites-available/$DOMAIN"

# cek sudo
if [[ $EUID -ne 0 ]]; then
  echo "Butuh akses root"
  exit 1
fi

echo "Memulai Automasi Deployment Web Server..."

# update and install
echo "Menginstall nginx..."
apt update > /dev/null 2>&1
apt install nginx -y > /dev/null 2>&1
systemctl  enable --now nginx

# make web folder
echo "Membuat direktori website di $DIR..."
mkdir -p $DIR

# permission
chown -R $SUDO_USER:$SUDO_USER /var/www/$DOMAIN/html

# make html file
echo "Membuat file index.html..."
echo "<h1>YOSH! Ini website hasil Automation Rifki.</h1>" > "$DIR/index.html"

# nginx config
echo "Membuat konfigurasi Nginx..."
cat <<EOF > $CONFIG_FILE
server {
  listen 80;
  server_name $DOMAIN www.$DOMAIN;

  root $DIR;
  index index.html;

  location / {
    try_files \$uri \$uri/ =404;
  }
}
EOF

# enable config
echo "Mengaktifkan website..."

# Hapus dulu kalau ada symlink lama (biar ga error)
rm -f /etc/nginx/sites-enabled/$DOMAIN
ln -s $CONFIG_FILE /etc/nginx/sites-enabled/

# restart nginx
echo "Restarting Nginx"
nginx -t #cek config
if [[ $? -eq 0 ]]; then
  systemctl restart nginx
  echo "sukses, website $DOMAIN telah aktif"
else
  echo "Config Error!"
fi
