#!/bin/bash -e

echo -e "\e[32m### Upgrading system packages ###\e[0m" >&2
apt-get update
apt-get -y dist-upgrade