#!/bin/bash -e

echo -e "\e[32m### Installing patched files ###\e[0m"
install -v -m 644 files/profile "${ROOTFS_DIR}/etc/profile"
install -v -m 644 files/pyvenv.cfg "${ROOTFS_DIR}/opt/.pwn/pyvenv.cfg"
install -v -m 644 files/sudoers "${ROOTFS_DIR}/etc/sudoers"

# /usr/bin/
# must be executable (755)
echo -e "\e[32m### Installing /usr/bin/ files ###\e[0m"
install -v -m 755 files/bettercap-launcher "${ROOTFS_DIR}/usr/bin/bettercap-launcher"
install -v -m 755 files/decryption-webserver "${ROOTFS_DIR}/usr/bin/decryption-webserver"
install -v -m 755 files/monstart "${ROOTFS_DIR}/usr/bin/monstart"
install -v -m 755 files/monstop "${ROOTFS_DIR}/usr/bin/monstop"
install -v -m 755 files/pwnagotchi-launcher "${ROOTFS_DIR}/usr/bin/pwnagotchi-launcher"
install -v -m 755 files/pwnlib "${ROOTFS_DIR}/usr/bin/pwnlib"

# /etc/
echo -e "\e[32m### Installing /etc/ files ###\e[0m"
install -v -m 644 files/dphys-swapfile "${ROOTFS_DIR}/etc/dphys-swapfile"

# /etc/bash_completion.d/
echo -e "\e[32m### Installing /etc/bash_completion.d/ files ###\e[0m"
install -v -m 644 files/pwnagotchi_completion.sh "${ROOTFS_DIR}/etc/bash_completion.d/pwnagotchi_completion.sh"

# /etc/modules-load.d/
echo -e "\e[32m### Installing /etc/modules-load.d/ files ###\e[0m"
install -v -m 644 files/modules.conf "${ROOTFS_DIR}/etc/modules-load.d/modules.conf"

# /etc/network/interfaces.d/
# deprecated, now using NetworkManager configurations below. Keeping files for good measure, just in case.
# echo -e "\e[32m### Installing /etc/network/interfaces.d/ files ###\e[0m"
# install -v -m 644 files/eth0-cfg "${ROOTFS_DIR}/etc/network/interfaces.d/eth0-cfg"
# install -v -m 644 files/lo-cfg "${ROOTFS_DIR}/etc/network/interfaces.d/lo-cfg"
# install -v -m 644 files/usb0-cfg "${ROOTFS_DIR}/etc/network/interfaces.d/usb0-cfg"
# install -v -m 644 files/wlan0-cfg "${ROOTFS_DIR}/etc/network/interfaces.d/wlan0-cfg"

# /etc/systemd/system/
echo -e "\e[32m### Installing /etc/systemd/system/ files ###\e[0m"
install -v -m 644 files/bettercap.service "${ROOTFS_DIR}/etc/systemd/system/bettercap.service"
install -v -m 644 files/pwnagotchi.service "${ROOTFS_DIR}/etc/systemd/system/pwnagotchi.service"
install -v -m 644 files/pwngrid-peer.service "${ROOTFS_DIR}/etc/systemd/system/pwngrid-peer.service"

# /etc/update-motd.d/
# must be executable (755)
echo -e "\e[32m### Installing /etc/update-motd.d/ files ###\e[0m"
install -v -m 755 files/01-motd "${ROOTFS_DIR}/etc/update-motd.d/01-motd"

# /etc/NetworkManager/
echo -e "e[32m### Installing NetworkManager configurations ###\e[0m"
install -v -m 600 files/usb0.nmconnection "${ROOTFS_DIR}/etc/NetworkManager/system-connections/usb0.nmconnection"
install -v -m 644 files/NetworkManager.conf "${ROOTFS_DIR}/etc/NetworkManager/NetworkManager.conf"

# /root/
echo -e "\e[32m### Installing /root/ files ###\e[0m"
install -v -m 644 files/client_secrets.json "${ROOTFS_DIR}/root/client_secrets.json"
install -v -m 644 files/settings.yaml "${ROOTFS_DIR}/root/settings.yaml"

# Remove unnecessary files, if they exist
echo -e "\e[32m### Removing unnecessary files ###\e[0m"
if [ -f "${ROOTFS_DIR}/etc/motd" ]; then
    rm "${ROOTFS_DIR}/etc/motd"
fi
if [ -f "${ROOTFS_DIR}/etc/update-motd.d/10-uname" ]; then
    rm "${ROOTFS_DIR}/etc/update-motd.d/10-uname"
fi
if [ -f "${ROOTFS_DIR}/etc/profile.d/sshpwd.sh" ]; then
    rm "${ROOTFS_DIR}/etc/profile.d/sshpwd.sh"
fi

echo -e "\e[32m### Setting NM Unmanaged udev rules to 0 ###\e[0m"
cp "${ROOTFS_DIR}"/usr/lib/udev/rules.d/85-nm-unmanaged.rules "${ROOTFS_DIR}"/etc/udev/rules.d/85-nm-unmanaged.rules
sed -i '36 s/ENV{DEVTYPE}=="gadget", ENV{NM_UNMANAGED}="1"/ENV{DEVTYPE}=="gadget", ENV{NM_UNMANAGED}="0"/' "${ROOTFS_DIR}"/etc/udev/rules.d/85-nm-unmanaged.rules
