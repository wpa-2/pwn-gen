#!/bin/bash -e
PWNUSER="${FIRST_USER_NAME:-pi}"
PWNHOME="/home/${PWNUSER}"

echo -e "\e[32m### Creating ${PWNHOME}/handshakes ###\e[0m"
install -v -d -m 777 "${ROOTFS_DIR}${PWNHOME}/handshakes"
