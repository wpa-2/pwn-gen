#!/bin/bash -e

echo -e "\e[32m### Creating /home/pi/handshakes ###\e[0m"
install -v -d -m 777 "${ROOTFS_DIR}/home/pi/handshakes"