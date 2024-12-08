#!/bin/bash -e

export PATH=$PATH:/usr/local/go/bin

# install go packages
for pkg in bettercap pwngrid; do
    if [ -d "/usr/local/src"/$pkg ] ; then
        echo -e "\e[32m===> Installing $pkg ===\e[0m"
        if [ $pkg = "pwngrid" ]; then
            cd "/usr/local/src/pwngrid"
            git pull
            go mod tidy
            make
            make install
        elif [ $pkg = "bettercap" ]; then
            cd "/usr/local/src/bettercap"
            git pull
            go mod tidy
            make
            make install
        fi
    else
        echo -e "\e[32m===> Installing $pkg ===\e[0m"
        if [ $pkg = "pwngrid" ]; then
            cd "/usr/local/src"
            git clone https://github.com/jayofelony/pwngrid.git
            cd "/usr/local/src/pwngrid"
            go mod tidy
            make
            make install
        elif [ $pkg = "bettercap" ]; then
            cd "/usr/local/src"
            git clone --recurse-submodules https://github.com/bettercap/bettercap.git
            cd "/usr/local/src/bettercap"
            go mod tidy
            make
            make install
        fi
    fi
done
# install bettercap caplets
echo -e "\e[32m=== Installing bettercap caplets ===\e[0m"
cd "/usr/local/src"
git clone https://github.com/jayofelony/caplets.git
cd "/usr/local/src/caplets"
make install
rm -rf "/usr/local/src/caplets"