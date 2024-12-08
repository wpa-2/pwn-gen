#!/bin/bash -e

echo -e "\e[32m### Setting permissions ###\e[0m"
chmod +x /usr/bin/*
chmod +x /usr/local/bin/*
chmod +x /etc/update-motd.d/*

echo -e "\e[32m### Enabling services ###\e[0m"
systemctl daemon-reload
systemctl enable bettercap pwngrid-peer pwnagotchi
systemctl disable wpa_supplicant apt-daily-upgrade.service apt-daily-upgrade.timer apt-daily.service apt-daily.timer bluetooth.service

echo -e "\e[32m### Disable apt packages from upgrading ###\e[0m"
apt-mark hold firmware-atheros firmware-brcm80211 firmware-libertas firmware-misc-nonfree firmware-realtek libpcap-dev libpcap0.8 libpcap0.8-dev

cat << EOF >> /boot/firmware/config.txt
dtparam=i2c1=on
dtparam=i2c_arm=on
dtparam=spi=on
gpu_mem=1
dtoverlay=dwc2
enable_uart=1

[pi0]
dtoverlay=spi0-2cs
#dtoverlay=disable-wifi

[pi3]
dtoverlay=spi0-2cs
#dtoverlay=disable-wifi

[pi4]
dtoverlay=spi0-2cs
#dtoverlay=disable-wifi

[pi5]
dtoverlay=spi0-2cs
#dtoverlay=disable-wifi
EOF