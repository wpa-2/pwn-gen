#!/bin/bash -e

cd /opt/
git clone https://github.com/jayofelony/pwnagotchi.git
cd pwnagotchi/

echo -e "\e[32m### Installing python virtual environment ###\e[0m"
python3 -m venv ../.pwn
echo -e "\e[32m### Activating virtual environment ###\e[0m"
source ../.pwn/bin/activate

echo -e "\e[32m### Installing Pwnagotchi ###\e[0m"
pip3 install .

chown -R pi:pi /opt

ln -sf /opt/.pwn/bin/pwnagotchi /usr/bin/pwnagotchi