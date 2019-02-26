#!/bin/sh
#
# install my needed stuff on SalixOS and change some settings
#

zPkgList="gcc make binutils git wget openbox obconf obmenu tint2 murrine parcellite nitrogen sakura gkrellm xfce4-settings"
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
# change some settings in /etc
#
echo "Edit /etc/inputrc..."
sudo sed -i 's#"\\e\[5~": .*#"\\e\[5~": history-search-backward#' /etc/inputrc
sudo sed -i 's#"\\e\[6~": .*#"\\e\[6~": history-search-forward#' /etc/inputrc


#
# build some stuff
#
mkdir ~/build

# rofi
cd ~/build
if [ ! -e rofi ]; then
    echo "Build rofi..."
    sudo $zPkgInstallCmd xcb-util-xrm libxkbcommon
    git clone https://github.com/DaveDavenport/rofi.git rofi
    cd rofi
    git submodule update --init
    autoreconf -i
    mkdir build
    cd build
    ../configure --disable-check
    make -j4
    sudo make install
fi

# gmrun
cd ~/build
if [ ! -e gmrun ]; then
    echo "Build gmrun..."
    git clone https://github.com/rtyler/gmrun.git gmrun
    cd gmrun
    ./autogen.sh
    make -j4
    strip --strip-unneeded src/gmrun
    sudo make install
fi

# wm-logout
cd ~/build
if [ ! -e wm-logout ]; then
    echo "Build wm-logout..."
    git clone https://github.com/thenktor/wm-logout.git wm-logout
    cd wm-logout
    sudo ./install.sh
fi


#
# apply user settings
#
cd $zCWD
cp -r ../config/openbox/ ~/.config/
cp -r ../config/tint2/ ~/.config/
