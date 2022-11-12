#!/usr/bin/env bash
#
# @Author: Afiniel
# @Date:   2022-11-11
# 
#               This shell set up xdagpool
#------------------------------------------------------------>

source /etc/functions.sh
source /etc/openxdagpool.conf

echo -e "$CYAN => Openxdagpool , XDAG Setup <= $COL_RESET"
cd ~
sudo mkdir -p /home/pool/storage
cd $HOME/pool/
sudo mkdir -p /home/pool/scripts
hide_output git clone https://github.com/afiniel/openxdagpool-scripts.git
hide_output git clone https://github.com/XDagger/xdag.git xdag1
hide_output git clone https://github.com/XDagger/xdag.git xdag2

echo -n 1 > ~/CURRENT_XDAG

sudo mkdir $HOME/var/www/openxdagpool && sudo chown -R $STORAGE_USER:$STORAGE_USER $HOME/var/www/openxdagpool

