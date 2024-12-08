#!/bin/bash -e

cd /opt/pwnagotchi

if [ "$(uname -m)" = "armv6l" -o "$(uname -m)" = "armv7l" ]; then
    export QEMU_CPU=arm1176
fi

echo -e "\e[32m### Installing python virtual environment ###\e[0m"
python3 -m venv ../.pwn
echo -e "\e[32m### Activating virtual environment ###\e[0m"
source ../.pwn/bin/activate

echo -e "\e[32m### Installing Pwnagotchi ###\e[0m"
pip3 install .

chown -R pi:pi /opt

ln -sf /opt/.pwn/bin/pwnagotchi /usr/bin/pwnagotchi