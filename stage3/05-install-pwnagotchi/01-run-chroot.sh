#!/bin/bash -e

cd /home/pi
echo -e "\e[32m### Manually installing lgpio from source ###\e[0m" >&2
wget http://abyz.me.uk/lg/lg.zip
unzip lg.zip
cd lg
make
make install

cd /home/pi
rm -r lg.zip lg/

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

echo -e "\e[32m### Installing python virtual environment ###\e[0m" >&2
python3 -m venv /home/pi/.pwn/ --system-site-packages
echo -e "\e[32m### Activating virtual environment ###\e[0m" >&2
source /home/pi/.pwn/bin/activate

echo -e "\e[32m### Installing Pwnagotchi ###\e[0m" >&2
pip3 cache purge
pip3 install . --no-cache-dir
deactivate

cd /home/pi
rm /usr/bin/pwnagotchi

ln -sf /home/pi/.pwn/bin/pwnagotchi /usr/bin/pwnagotchi
rm -r /home/pi/pwnagotchi