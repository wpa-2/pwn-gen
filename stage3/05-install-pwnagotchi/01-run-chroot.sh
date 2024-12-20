#!/bin/bash -e

cd /home/pi
if [ ! -d pwnagotchi ]; then
    git clone https://github.com/jayofelony/pwnagotchi.git
    cd pwnagotchi/
else
    cd /home/pi/pwnagotchi/
    git pull
fi
if [ -d /home/pi/.pwn ]; then
    rm -r /home/pi/.pwn
fi
if [ "$(uname -m)" = "armv6l" ]; then
    export QEMU_CPU=arm1176
fi

echo -e "\e[32m### Installing python virtual environment ###\e[0m"
python3 -m venv /home/pi/.pwn/
echo -e "\e[32m### Activating virtual environment ###\e[0m"
source /home/pi/.pwn/bin/activate

echo -e "\e[32m### Installing Pwnagotchi ###\e[0m"
pip3 cache purge
pip3 install . --no-cache-dir
deactivate

cd /home/pi
rm /usr/bin/pwnagotchi

ln -sf /home/pi/.pwn/bin/pwnagotchi /usr/bin/pwnagotchi
rm -r /home/pi/pwnagotchi