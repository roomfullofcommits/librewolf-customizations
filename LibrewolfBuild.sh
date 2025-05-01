#!/bin/bash

git clone --recursive https://gitlab.com/librewolf-community/browser/source.git librewolf-source
cd librewolf-source
git pull

echo "make dir"
make dir
echo "make bootstrap"
make bootstrap
echo "make build"
make build

cd ..
echo "copying binary"
rm librewolf
cp -s librewolf-source/librewolf-*/obj-*/dist/bin/librewolf .

echo "copying .desktop file"
rm $HOME/.local/share/applications/librewolf.desktop
cp $PWD/librewolf.desktop $HOME/.local/share/applications/

git clone https://github.com/MrOtherGuy/fx-autoconfig.git
cd fx-autoconfig
git pull
cd ..
rm $HOME/.librewolf/librewolf.overrides.cfg
cat config.txt >> $HOME/.librewolf/librewolf.overrides.cfg
cat fx-autoconfig/program/config.js >> $HOME/.librewolf/librewolf.overrides.cfg
echo "copying profile stuff"
mkdir desktop-profile/chrome/
cp -rf fx-autoconfig/profile/chrome/* desktop-profile/chrome

git clone https://github.com/aminought/firefox-second-sidebar.git
cd firefox-second-sidebar
git pull
cd ..
echo "copying stuff"
cp -rf firefox-second-sidebar/src/* desktop-profile/chrome/JS/

echo "clearing startup cache"
rm -r desktop-profile/startupCache

