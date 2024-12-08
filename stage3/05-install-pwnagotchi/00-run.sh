#!/bin/bash -e

install -v -d "${ROOTFS_DIR}/etc/pwnagotchi"
install -v -d "${ROOTFS_DIR}/etc/pwnagotchi/log"
install -v -d "${ROOTFS_DIR}/etc/pwnagotchi/conf.d/"
install -v -d "${ROOTFS_DIR}/usr/local/share/pwnagotchi"
install -v -d "${ROOTFS_DIR}/usr/local/share/pwnagotchi/custom-plugins/"