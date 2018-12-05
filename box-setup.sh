#!/bin/sh
#
# install my needed stuff on SalixOS and change some settings
#

zCWD=`pwd`

#
# check distribution
#
if [ -e /etc/slackware-version -a -x /usr/bin/spi ]; then
    echo "Salix detected"
    ./scripts/salix-box-setup.sh
    exit $?
fi
