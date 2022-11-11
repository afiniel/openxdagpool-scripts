#!/usr/bin/env bash

###########################################################################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox                            #
# Updated by Afiniel crypto use...                                                                		  #
# This script is intended to be run like this:                                                            #
#                                                                                                         #
#  curl https://raw.githubusercontent.com/afiniel/openxdagpool-scripts/master/install.sh | bash			  # 
#                                                                                                         #
###########################################################################################################


# Clone the Yiimp Server repository if it doesn't exist.
clear
echo Installing git . . .
apt-get -q -q update
apt-get -q -q install -y git < /dev/null
echo

echo Downloading Yiimp Server Installer v1.0. . .
git clone https://github.com/afiniel/openxdagpool-scripts.git "$HOME"/openxdagpool/install < /dev/null 2> /dev/null
echo

# Start setup script.
bash $HOME/openxdagpool/install/start.sh