#!/bin/sh
#
# install my needed stuff on SalixOS and change some settings
#

zPkgList="easytag picard mp3gain vorbisgain numpy"
zCWD=`pwd`

#
# check distribution
#
if [ -e /etc/slackware-version -a -x /usr/bin/spi ]; then
    echo "Salix detected"
else
	echo "ERROR: Salix NOT detected"
	echo ""
	exit 1
fi

# package manager
zPkgMngr="/usr/bin/spi"
zPkgDbUpdateCmd="$zPkgMngr -u"
zPkgInstallCmd="$zPkgMngr -i"

#
# install packages from repository
#
echo "Install packages..."
sudo $zPkgDbUpdateCmd
sudo $zPkgInstallCmd $zPkgList


#
# install AppImages
#
echo "Install AppImages..."
mkdir -p ~/AppImages
cd ~/AppImages
if [ ! -e KeePassXC.AppImage ]; then
    echo "Downloading KeePassXC.AppImage..."
    wget -O KeePassXC.AppImage https://github.com/keepassxreboot/keepassxc/releases/download/2.3.4/KeePassXC-2.3.4-x86_64.AppImage
else
    echo "KeePassXC.AppImage already exists."
fi


#
# build some stuff
#
mkdir ~/build

# squeezelite
cd ~/build
if [ ! -e squeezelite ]; then
    echo "Build squezzelite..."
    git clone https://github.com/ralph-irving/squeezelite.git squeezelite
    cd squeezelite
    make -j4
    strip --strip-unneeded squeezelite
    sudo install -m755 -o root -g root squeezelite /usr/local/bin/
fi

# dr14meter
cd ~/build
if [ ! -e dr14meter ]; then
    echo "Build dr14meter..."
    git clone https://github.com/simon-r/dr14_t.meter.git dr14meter
    cd dr14meter
    sudo python setup.py install
fi


#
# apply user settings
#
cd $zCWD
