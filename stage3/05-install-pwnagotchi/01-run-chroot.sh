#!/bin/bash -e

cd /opt/
if [ ! -d pwnagotchi ]; then
    git clone https://github.com/jayofelony/pwnagotchi.git
    cd pwnagotchi/
else
    cd pwnagotchi/
    git pull
fi
if [ -d .pwn ]; then
    rm -r /opt/.pwn
fi

export QEMU_CPU=arm1176

echo -e "\e[32m### Installing python virtual environment ###\e[0m"
python3 -m venv ../.pwn
echo -e "\e[32m### Activating virtual environment ###\e[0m"
source ../.pwn/bin/activate

echo -e "\e[32m### Installing Pwnagotchi ###\e[0m"
pip3 cache purge
pip3 install . --no-cache-dir

chown -R pi:pi /opt

ln -sf /opt/.pwn/bin/pwnagotchi /usr/bin/pwnagotchi