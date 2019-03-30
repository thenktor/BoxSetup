#!/bin/sh
#
# install some themes
#

zCWD=`pwd`

#
# install icons and themes
#
mkdir ~/.icons
mkdir ~/.themes

# Episode_1
cd "$zCWD"
if [ ! -e ~/.themes/Episode_1 ]; then
    echo "Install Episode_1 Openbox theme..."
    cp -r ../themes/Episode_1 ~/.themes/
fi

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
if [ ! -e ~/.icons/Electric_Funeral_Icon_Theme.git ]; then
    echo "Install Electric Funeral icon theme..."
    git clone https://github.com/ju1464/Electric_Funeral_Icon_Theme.git ~/.icons/Electric_Funeral_Icon_Theme.git
else
    echo "Update Electric Funeral icon theme..."
    cd ~/.icons/Electric_Funeral_Icon_Theme.git
    git pull
    cd ~/.icons/
    ln -sf Electric_Funeral_Icon_Theme.git/Electric_Dark_Funeral/ Electric_Dark_Funeral
    ln -sf Electric_Funeral_Icon_Theme.git/Electric_Light_Funeral/ Electric_Light_Funeral
    ln -sf Electric_Funeral_Icon_Theme.git/Dominus_Dark_Funeral/ Dominus_Dark_Funeral
    ln -sf Electric_Funeral_Icon_Theme.git/Dominus_Light_Funeral/ Dominus_Light_Funeral
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
