#!/bin/bash

#Justin Bee, 2019
#Deniz Ege Tunçay, 2019
#nrtkbb, 2018
#Neal Burger, 2017

#Autodesk Maya Installation Bash Script v1.0 for Ubuntu 18.04 based Linux Distributions
#if you have any issues, feel free tweet me // @egetun

#Make sure we’re running with root permissions.
if [ `whoami` != root ]; then
    echo Please run this script using sudo
    echo Just type “sudo !!”
    exit
fi

#Check for 64-bit arch
if [uname -m != x86_64]; then
    echo Maya will only run on 64-bit linux. 
    echo Please install the 64-bit ubuntu and try again.
    exit
fi

## Create Download Directory
##      mkdir -p maya2019install
##      cp maya2019install.sh maya2019install/maya2019install.sh
##      cd maya2019install

## Download Maya Install Files
wget https://edutrial.autodesk.com/NetSWDLD/2019/MAYA/EC2C6A7B-1F1B-4522-0054-4FF79B4B73B5/ESD/Autodesk_Maya_2019_Linux_64bit.tgz
tar xvf Autodesk_Maya_2019_Linux_64bit.tgz

## Install Dependencies
apt-get install -y libssl1.0.0 gcc  libssl-dev libjpeg62 alien csh tcsh libaudiofile-dev libglw1-mesa elfutils libglw1-mesa-dev mesa-utils xfstt xfonts-100dpi xfonts-75dpi ttf-mscorefonts-installer libfam0 libfam-dev libcurl4-openssl-dev libtbb-dev
apt-get install rpm --reinstall
#apt-get install -y libtbb-dev 
wget http://launchpadlibrarian.net/183708483/libxp6_1.0.2-2_amd64.deb
wget http://mirrors.kernel.org/ubuntu/pool/main/libp/libpng/libpng12-0_1.2.54-1ubuntu1_amd64.deb

## Install Maya 
alien -cv *.rpm
dpkg -i *.deb
echo "int main (void) {return 0;}" > mayainstall.c
gcc mayainstall.c
mv /usr/bin/rpm /usr/bin/rpm_backup
cp a.out /usr/bin/rpm
chmod +x ./setup
sudo QT_X11_NO_MITSHM=1 ./setup
rm /usr/bin/rpm
mv /usr/bin/rpm_backup /usr/bin/rpm

## Copy lib*.so
cp libQt* /usr/autodesk/maya2019/lib/
cp libadlm* /usr/lib/x86_64-linux-gnu/

## Fix Startup Errors
ln -s /usr/lib/x86_64-linux-gnu/libtiff.so.5.3.0 /usr/lib/libtiff.so.3
ln -s /usr/lib/x86_64-linux-gnu/libssl.so.1.0.0 /usr/autodesk/maya2019/lib/libssl.so.10
ln -s /usr/lib/x86_64-linux-gnu/libcrypto.so /usr/autodesk/maya2019/lib/libcrypto.so.10
ln -s /usr/lib/x86_64-linux-gnu/libtbb.so.2 /usr/lib/x86_64-linux-gnu/libtbb_preview.so.2
ln -s /usr/lib/x86_64-linux-gnu/libpcre16.so.3 /usr/autodesk/maya2019/lib/libpcre16.so.0
##      ln -s /usr/lib/x86_64-linux-gnu/libpng16.so.16 /usr/autodesk/maya2019/lib/libpng15.so.15


mkdir -p /usr/tmp
chmod 777 /usr/tmp

mkdir -p ~/maya/2019/
chmod 777 ~/maya/2019/

## Fix Segmentation Fault Error
echo "MAYA_DISABLE_CIP=1" >> ~/maya/2019/Maya.env

## Fix Color Managment Errors
echo "LC_ALL=C" >> ~/maya/2019/Maya.env

chmod 777 ~/maya/2019/Maya.env

## Maya Camera Modifier Key
gsettings set org.gnome.desktop.wm.preferences mouse-button-modifier "<Super>"

## Ensure that Fonts are Loaded
xset +fp /usr/share/fonts/X11/100dpi/
xset +fp /usr/share/fonts/X11/75dpi/
xset fp rehash

wget https://vorboss.dl.sourceforge.net/project/libpng/libpng15/1.5.30/libpng-1.5.30.tar.gz
tar zxvf libpng-1.5.30.tar.gz
##      cd libpng-1.5.30/
./libpng-1.5.30/configure 
make
make install
cp /usr/local/lib/libpng15.so.15 /usr/autodesk/maya2019/lib/libpng15.so.15
make uninstall

chmod -R 777 /opt/Autodesk 
chmod -R 777 /opt/flexnetserver/
chmod -R 777 /usr/autodesk/
chmod -R 777 /var/opt/Autodesk/ 


echo We hope Autodesk Maya 2019 was installed successfully.
