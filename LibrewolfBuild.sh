#!/bin/bash

paru -G librewolf
if ! [ $? -eq 0 ]; then
	echo "couldn't get build files, exiting"
	exit 1
fi

cd librewolf

makepkg -C --noarchive
if ! [ $? -eq 0 ]; then
        echo "build failed, exiting"
        exit 2
fi
cd ..

rm -r librewolf-build
cp -r librewolf/src/librewolf-*/ librewolf-build

echo "copying binary"
cp -sf librewolf-build/obj-x86_64-pc-linux-gnu/dist/bin/librewolf-bin .
mkdir "$HOME/.local/bin/"
cp -sf "$PWD/"librewolf-build/obj-x86_64-pc-linux-gnu/dist/bin/librewolf-bin "$HOME/.local/bin/librewolf"

echo "copying .desktop file"
mkdir $HOME/.local/share/applications/
cp -f $PWD/librewolf.desktop $HOME/.local/share/applications/

echo "cloning/updating fx-autoconfig"
git clone https://github.com/MrOtherGuy/fx-autoconfig.git
cd fx-autoconfig
git pull
cd ..

echo "creating librewolf config"
rm $HOME/.librewolf/librewolf.overrides.cfg
mkdir $HOME/.librewolf/
cat config.txt >> $HOME/.librewolf/librewolf.overrides.cfg
cat fx-autoconfig/program/config.js >> $HOME/.librewolf/librewolf.overrides.cfg
echo "copying profile stuff"
mkdir desktop-profile/chrome/
cp -rsf $PWD/fx-autoconfig/profile/chrome/* $PWD/desktop-profile/chrome

echo "cloning/updating firefox-second-sidebar"
git clone https://github.com/aminought/firefox-second-sidebar.git
cd firefox-second-sidebar
git pull
git switch -f firefox-update-fixes
cd ..
echo "copying second sidebar stuff"
cp -rsf $PWD/firefox-second-sidebar/src/* $PWD/desktop-profile/chrome/JS/

echo "cleaning up dangling symlinks"
find . -xtype l -exec rm {} \;

echo "clearing startup cache"
rm -r desktop-profile/startupCache

xdg-icon-resource install --novendor --context apps --size 128 librewolf-build/browser/branding/librewolf/default128.png librewolf
xdg-icon-resource install --novendor --context apps --size 64 librewolf-build/browser/branding/librewolf/default64.png librewolf
xdg-icon-resource install --novendor --context apps --size 48 librewolf-build/browser/branding/librewolf/default48.png librewolf
xdg-icon-resource install --novendor --context apps --size 32 librewolf-build/browser/branding/librewolf/default32.png librewolf
xdg-icon-resource install --novendor --context apps --size 16 librewolf-build/browser/branding/librewolf/default16.png librewolf
