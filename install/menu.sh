#!/usr/bin/env bash
#
# @Author: Afiniel
# @Date:   2022-11-11
# 
#               This is the menu for xdagpool
#------------------------------------------------------------>

source /etc/functions.sh

RESULT=$(dialog --stdout --nocancel --default-item 1 --title "xdagpool Menu v0.5.6" --menu "Choose one" -1 60 16 \
' ' "- XdagPool Menu  -" \
1 "Install openxdagpool" \
' ' "- Update Option is still in progress  -" \
2 "Update openxdagpool" \
3 Exit)
if [ $RESULT = ] 
then
bash $(basename $0) && exit;
fi

if [ $RESULT = 1 ]
then
clear;
cd $HOME/openxdagpool/xdagpool
source start.sh;
fi

if [ $RESULT = 2 ]
then
clear;
echo "This is not done yet, please come back later! Use xdagpool command again to start again.";
exit;
fi

if [ $RESULT = 3 ]
then
clear;
exit;
fi
