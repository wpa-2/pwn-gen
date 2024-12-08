#!/bin/bash -e

# install nexmon
NEXMON_REPO=https://github.com/DrSchottky/nexmon.git
NEXMON_PATCHES="patches/bcm43430a1/7_45_41_46/nexmon patches/bcm43455c0/7_45_206/nexmon patches/bcm43436b0/9_88_4_65/nexmon"

PHOME=/usr/local/src

cd /usr/local/src

# Enable recursive globbing
shopt -s globstar
# Define the destination path using globbing
MOD_DEST="/lib/modules/**/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac"
# Check if the specific file does not exist
if [ ! -f "${MOD_DEST}/brcmfmac.ko.xz.ORIG" ]; then
    echo -e "\e[32m=== cloning nexmon repository ===\e[0m"
    git clone $NEXMON_REPO
    cd nexmon

    source setup_env.sh
    make
    # for each kernel with a build directory
    for mod in $(cd /lib/modules ; ls); do

        if [ -d /lib/modules/"$mod"/build ]; then
        echo
        echo -e "\e[32m=== building Nexmon for $mod ===\e[0m"

        export QEMU_UNAME=$mod
        export KERNEL=$(echo "$mod" | cut -d . -f -2)
        MOD_DEST=/lib/modules/${mod}/kernel/drivers/net/wireless/broadcom/brcm80211/brcmfmac

        # checking for installed kernel module, and not re-installing
        # delete brcmfmac.ko.NEXMON to rebuild for that kernel tree
        if [ ! -f "${MOD_DEST}"/brcmfmac.ko.NEXMON ]; then
            for p in $NEXMON_PATCHES; do
            echo -e "\e[32m=== clean $mod patch $p ===\e[0m"
            pushd "$p"
            make clean
            popd
            done

            for p in $NEXMON_PATCHES; do
            echo -e "\e[32m=== build $mod patch $p ===\e[0m"
            pushd "$p"
            make
            echo -e "\e[32m===  install $mod patch $p ===\e[0m"
            # use invalid kernel number so install-firmware
            # skips module unloading and loading
            QEMU_UNAME=4.20.69 make install-firmware || true
            popd
            done

            # built a new driver module while building firmwares above, so copy it into place
            echo cp ${PHOME}/nexmon/patches/driver/brcmfmac_"${KERNEL}".y-nexmon/brcmfmac.ko "${MOD_DEST}"/brcmfmac.ko.NEXMON
            cp ${PHOME}/nexmon/patches/driver/brcmfmac_"${KERNEL}".y-nexmon/brcmfmac.ko "${MOD_DEST}"/brcmfmac.ko.NEXMON

            pushd "${MOD_DEST}"
            if [ -f brcmfmac.ko.xz -o -f brcmfmac.ko.xz.ORIG ]; then
                if [ -f brcmfmac.ko.xz.ORIG ]; then
                    # dont overwrite ORIG (again)
                    rm -f brcmfmac.ko.xz
                else
                    # save original
                    echo -e "\e[32m=== Back up original driver ===\e[0m"
                    mv brcmfmac.ko.xz brcmfmac.ko.xz.ORIG
                fi
                echo -e "\e[32m=== Compressing driver ===\e[0m"
                which xz
                xz --verbose -c brcmfmac.ko.NEXMON > brcmfmac.ko.xz
            elif [ -f brcmfmac.ko ]; then
                if [ -f brcmfmac.ko.ORIG ]; then
                    rm -f brcmfmac.ko
                else
                    echo -e "\e[32m=== Back up original driver ===\e[0m"
                    mv brcmfmac.ko brcmfmac.ko.ORIG
                fi
                echo -e "\e[32m=== Copying new driver ===\e[0m"
                ln brcmfmac.ko.NEXMON brcmfmac.ko
            fi

            echo -e "\e[32m=== Installed ${mod} kernel driver ===\e[0m"
            depmod "${mod}"
            popd
        else
            echo -e "\e[32m=== Already installed ${mod} ===\e[0m"
        fi

        else
            echo
            echo -e "\e[32m=== NO Kernel build tree for $mod ===\e[0m"
            echo -e "\e[32m=== Skipping Nexmon ===\e[0m"
        fi
    done


    if [ ! -L /usr/lib/firmware/brcm/brcmfmac43436s-sdio.bin ]; then
        echo Linking 43430 firmware to 43436s for pizero2w with 43430 chip
        ln -sf /usr/lib/firmware/brcm/brcmfmac43430-sdio.bin /usr/lib/firmware/brcm/brcmfmac43436s-sdio.bin
    fi

    if [ ! -f /usr/bin/nexutil ]; then
        pushd utilities/nexutil
        make
        make install
        popd
    fi

    rm -r /usr/local/src/nexmon
fi
