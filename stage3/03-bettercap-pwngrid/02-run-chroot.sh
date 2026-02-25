#!/bin/bash -e
PWNUSER="${FIRST_USER_NAME:-pi}"
PWNHOME="/home/${PWNUSER}"

export GOPROXY=direct
export GONOSUMDB=*
export GOFLAGS=-mod=mod
export GONOSUMCHECK=*
export PATH=$PATH:/usr/local/go/bin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin

# install go packages
for pkg in bettercap pwngrid; do
    if [ -d "${PWNHOME}/"$pkg ] ; then
        echo -e "\e[32m===> Installing $pkg ===\e[0m"
        if [ $pkg = "pwngrid" ]; then
            cd "${PWNHOME}/pwngrid"
            git pull
            go mod tidy
            make
            make install
        elif [ $pkg = "bettercap" ]; then
            cd "${PWNHOME}/bettercap"
            git pull
            go mod tidy
            make
            make install
        fi
    else
        echo -e "\e[32m===> Installing $pkg ===\e[0m"
        if [ $pkg = "pwngrid" ]; then
            cd "${PWNHOME}"
            git clone https://github.com/jayofelony/pwngrid.git
            cd "${PWNHOME}/pwngrid"
            go mod tidy
            make
            make install
        elif [ $pkg = "bettercap" ]; then
            cd "${PWNHOME}"
            git clone --recurse-submodules https://github.com/bettercap/bettercap.git
            cd "${PWNHOME}/bettercap"
            go mod tidy
            make
            make install
        fi
    fi
done

# install bettercap caplets
echo -e "\e[32m=== Installing bettercap caplets ===\e[0m"
cd "${PWNHOME}/"
git clone https://github.com/jayofelony/caplets.git
cd "${PWNHOME}/caplets"
make install
rm -rf "${PWNHOME}/caplets"

# cleanup source repos - not needed on final image
echo -e "\e[32m=== Cleaning up build sources ===\e[0m"
rm -rf "${PWNHOME}/bettercap"
rm -rf "${PWNHOME}/pwngrid"
