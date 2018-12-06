#!/bin/sh
#
# install my needed stuff on SalixOS and change some settings
#

zPkgList="gcc make binutils git wget openbox obconf obmenu tint2 parcellite nitrogen sakura gkrellm xfce4-settings"
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
sudo $zPkgDbUpdateCmd
sudo $zPkgInstallCmd $zPkgList


#
# change some settings in /etc
#
sudo sed -i 's#"\\e\[5~": .*#"\\e\[5~": history-search-backward#' /etc/inputrc
sudo sed -i 's#"\\e\[5~": .*#"\\e\[6~": history-search-forward#' /etc/inputrc


#
# install AppImages
#
mkdir -p ~/AppImages
cd ~/AppImages
wget -O KeePassXC.AppImage https://github.com/keepassxreboot/keepassxc/releases/download/2.3.4/KeePassXC-2.3.4-x86_64.AppImage


#
# build some stuff
#
mkdir ~/build

# squeezelite
cd ~/build
git clone https://github.com/ralph-irving/squeezelite.git squeezelite
cd squeezelite
make -j4
strip --strip-unneeded squeezelite
sudo install -m755 -o root -g root squeezelite /usr/local/bin/

# rofi
sudo $zPkgInstallCmd xcb-util-xrm libxkbcommon
cd ~/build
git clone https://github.com/DaveDavenport/rofi.git rofi
cd rofi
git submodule update --init
autoreconf -i
mkdir build
cd build
../configure --disable-check
make -j4
sudo make install

# gmrun
cd ~/build
git clone https://github.com/rtyler/gmrun.git gmrun
cd gmrun
./autogen.sh
make -j4
strip --strip-unneeded src/gmrun
sudo make install

# wm-logout
cd ~/build
git clone https://github.com/thenktor/wm-logout.git wm-logout
cd wm-logout
sudo ./install.sh


#
# install icons and themes
#
mkdir ~/.icons
mkdir ~/.themes

# Papirus
cd ~/build
wget -O papirus-icon-theme.zip https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/master.zip
unzip papirus-icon-theme.zip
rm papirus-icon-theme.zip
mv papirus-icon-theme-master/Papirus ~/.icons/
rm -r papirus-icon-theme-master

# Electric Funeral icons
cd
git clone https://github.com/ju1464/Electric_Funeral_Icon_Theme.git ~/.icons/Electric_Funeral

# Absolute GTK Theme
cd ~/build
wget -O absolute-themes.tar.bz2 https://dl.opendesktop.org/api/files/download/id/1460970554/126326-absolute-themes.tar.bz2
tar xf absolute-themes.tar.bz2
rm absolute-themes.tar.bz2
mv absolute-themes/* ~/.themes/
rm -r absolute-themes

#
# apply user settings
#
cd $zCWD
cp -r ../config/openbox/ ~/.config/
cp -r ../config/tint2/ ~/.config/
