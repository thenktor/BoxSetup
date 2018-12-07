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
sudo sed -i 's#"\\e\[5~": .*#"\\e\[6~": history-search-forward#' /etc/inputrc


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
# install icons and themes
#
mkdir ~/.icons
mkdir ~/.themes

# Papirus
cd ~/build
if [ ! -e papirus-icon-theme-master ]; then
    echo "Install Papirus icon theme..."
    wget -O papirus-icon-theme.zip https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/master.zip
    unzip papirus-icon-theme.zip
    rm papirus-icon-theme.zip
    cp -r papirus-icon-theme-master/Papirus ~/.icons/
fi

# Electric Funeral icons
cd
if [ ! -e ~/.icons/Electric_Funeral ]; then
    echo "Install Electric Funeral icon theme..."
    git clone https://github.com/ju1464/Electric_Funeral_Icon_Theme.git ~/.icons/Electric_Funeral
else
    echo "Update Electric Funeral icon theme..."
    cd ~/.icons/Electric_Funeral
    git pull
fi

# Absolute GTK Theme
cd ~/build
if [ ! -e absolute-themes ]; then
    echo "Install Absolte Gtk theme..."
    wget -O absolute-themes.tar.bz2 https://dl.opendesktop.org/api/files/download/id/1460970554/s/f44cd6e2f1275a63bbb954021d0a8e024f621b3d6a7d5f138984961da8dda5a9d2090c4af500a563a85210b1a9cfd07d24d95f9d14cd93d086beb9bddd365cf3/t/1544130696/u//126326-absolute-themes.tar.bz2
    tar xf absolute-themes.tar.bz2
    rm absolute-themes.tar.bz2
    cp -r absolute-themes/* ~/.themes/
fi


#
# apply user settings
#
cd $zCWD
cp -r ../config/openbox/ ~/.config/
cp -r ../config/tint2/ ~/.config/
