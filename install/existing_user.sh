#!/bin/env bash

##################################################################################
# This is the entry point for configuring the system.                            #
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox   #
# Updated by Afiniel for xdagpool use...                                         #
##################################################################################

source /etc/functions.sh
cd ~/openxdagpool/install
clear

# Get logged in user name
whoami=`whoami`
echo -e " Modifying existing user $whoami for xdagpool support."
sudo usermod -aG sudo ${whoami}

echo '# yiimp
# It needs passwordless sudo functionality.
'""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

echo '
cd ~/openxdagpool/install
bash start.sh
' | sudo -E tee /usr/bin/xdagpool >/dev/null 2>&1
sudo chmod +x /usr/bin/xdagpool

# Check required files and set global variables
cd $HOME/openxdagpool/install
source pre_setup.sh

# Create the STORAGE_USER and STORAGE_ROOT directory if they don't already exist.
if ! id -u $STORAGE_USER >/dev/null 2>&1; then
sudo useradd -m $STORAGE_USER
fi
if [ ! -d $STORAGE_ROOT ]; then
sudo mkdir -p $STORAGE_ROOT
fi

# Save the global options in /etc/openxdagpool.conf so that standalone
# tools know where to look for data.
echo 'STORAGE_USER='"${STORAGE_USER}"'
STORAGE_ROOT='"${STORAGE_ROOT}"'
PUBLIC_IP='"${PUBLIC_IP}"'
PUBLIC_IPV6='"${PUBLIC_IPV6}"'
DISTRO='"${DISTRO}"'
FIRST_TIME_SETUP='"${FIRST_TIME_SETUP}"'
PRIVATE_IP='"${PRIVATE_IP}"'' | sudo -E tee /etc/openxdagpool.conf >/dev/null 2>&1


cd ~
sudo setfacl -m u:${whoami}:rwx /home/${whoami}/openxdagpool
clear
echo -e "$YELLOW Your User:$MAGENTA ${whoami}$YELLOW has been modified for xdagpool support. $COL_RESET"
echo -e "$YELLOW You must$RED reboot$YELLOW the system for the new permissions to update and type$GREEN xdagpool$YELLOW to continue setup...$COL_RESET"
exit 0