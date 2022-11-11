#!/bin/env bash
#
# Author: Afiniel
# Date: 2022-11-11
#
# Start the installation of openxdagpool.

# Recall the last settings used if we're running this a second time.
if [ -f /etc/xdagpool.conf ]; then
    # Load the old .conf file to get existing configuration options loaded
    # into variables with a DEFAULT_ prefix.
    cat /etc/xdagpool.conf | sed s/^/DEFAULT_/ >/tmp/xdagpool.prev.conf
    source /tmp/xdagpool.prev.conf
    source /etc/xdagpool.conf
    rm -f /tmp/xdagpool.prev.conf
else
    FIRST_TIME_SETUP=1
fi

# Copy functions.sh to /etc/
if [[ ("$FIRST_TIME_SETUP" == "1") ]]; then
    clear
    cd $HOME/openxdagpool/install

    # copy functions to /etc
    source functions.sh
    sudo cp -r functions.sh /etc/

    # Check system setup: Are we running as root on Ubuntu 16.04 on a
    # machine with enough memory?
    # If not, this shows an error and exits.
    source preflight.sh

    # Ensure Python reads/writes files in UTF-8. If the machine
    # triggers some other locale in Python, like ASCII encoding,
    # Python may not be able to read/write files. This is also
    # in the management daemon startup script and the cron script.

    if ! locale -a | grep en_US.utf8 >/dev/null; then
        # Generate locale if not exists
        hide_output locale-gen en_US.UTF-8
    fi

    export LANGUAGE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_TYPE=en_US.UTF-8

    # Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
    export NCURSES_NO_UTF8_ACS=1

    #check for user
    echo -e "$YELLOW => Installing needed packages for setup to continue  <= $COL_RESET"
    hide_output sudo apt-get -q -q update
    apt_get_quiet install dialog nginx php7.0-fpm php7.0-cli php7.0-mysql php7.0-opcache build-essential libssl-dev gcc libgmp3-dev libtool autoconf mysql-client mysql-server || exit 1

    # Are we running as root?
    if [[ $EUID -ne 0 ]]; then
        # Welcome
        message_box "xdagpool Installer" \
        "Hello and thanks for using the xdagpool Installer!
        \n\nInstallation for the most part is fully automated. In most cases any user responses that are needed are asked prior to the installation.
        \n\nNOTE: You should only install this on a brand new Ubuntu 16.04 or Ubuntu 18.04 installation."
        source existing_user.sh
        exit
    else
        source create_user.sh
        exit
    fi
    cd ~

else
    clear

    # Ensure Python reads/writes files in UTF-8. If the machine
    # triggers some other locale in Python, like ASCII encoding,
    # Python may not be able to read/write files. This is also
    # in the management daemon startup script and the cron script.
    
    if ! locale -a | grep en_US.utf8 >/dev/null; then
    # Generate locale if not exists
    hide_output locale-gen en_US.UTF-8
    fi

    export LANGUAGE=en_US.UTF-8
    export LC_ALL=en_US.UTF-8
    export LANG=en_US.UTF-8
    export LC_TYPE=en_US.UTF-8
    # Fix so line drawing characters are shown correctly in Putty on Windows. See #744.
    export NCURSES_NO_UTF8_ACS=1

    # Load our functions and variables.
    source /etc/functions.sh
    source /etc/Openxdagpool.conf
    # Start xdagpool
    cd $HOME/openxdagpool/install
    clear
    source 
    echo "<-------------------------------------|--------------------------------------->"
    echo -e "$YELLOW Thank you for using OpenxDAG Install Script$GREEN v0.0.1 $YELLOW fork by Afiniel!     $COL_RESET"
    echo
    echo -e "$YELLOW =>  To run this installer anytime simply type:$GREEN xdagpool         $COL_RESET"
    echo "<----------------------------------------------------------------------------->"
    echo -e "$YELLOW => Do you like the installer and want to support the project? use wallets below:             $COL_RESET"
    echo "<----------------------------------------------------------------------------->"
    echo -e "$YELLOW =>  BTC:$GREEN $BTCDON                                   		       $COL_RESET"
    echo
    echo -e "$YELLOW =>  BCH:$GREEN $BCHDON                                   		       $COL_RESET"
    echo
    echo -e "$YELLOW =>  ETH:$GREEN $ETHDON                                   		       $COL_RESET"
    echo
    echo -e "$YELLOW =>  DOGE:$GREEN $DOGEDON                                 		       $COL_RESET"
    echo
    echo -e "$YELLOW =>  LTC:$GREEN $LTCDON                                   		       $COL_RESET"
    echo "<-------------------------------------|-------------------------------------->"
    cd ~
fi
