#!/bin/bash

git clone --recursive https://gitlab.com/librewolf-community/browser/source.git librewolf-source
cd librewolf-source

git pull
git fetch --tags

currentcommit=$(git log -1 --oneline)
newesttag=$(git describe --tags "$(git rev-list --tags --max-count=1)")
git checkout $newesttag
newesttagcommit=$(git log -1 --oneline)

echo "checking for update"
if [ "$currentcommit" != "$newesttagcommit" ]; then
    echo "getting newest version, deleting old builds"
    rm -rf librewolf-* firefox-*
else
    echo "already up to date :)"
fi

echo "make dir"
make dir
echo "make bootstrap"
make bootstrap
echo "make build"
make build

cd ..
echo "copying binary"
cp -sf librewolf-source/librewolf-*/obj-*/dist/bin/librewolf .

echo "copying .desktop file"
cp -f $PWD/librewolf.desktop $HOME/.local/share/applications/

echo "cloning/updating fx-autoconfig"
git clone https://github.com/MrOtherGuy/fx-autoconfig.git
cd fx-autoconfig
git pull
cd ..

echo "creating librewolf config"
rm $HOME/.librewolf/librewolf.overrides.cfg
cat config.txt >> $HOME/.librewolf/librewolf.overrides.cfg
cat fx-autoconfig/program/config.js >> $HOME/.librewolf/librewolf.overrides.cfg
echo "copying profile stuff"
mkdir desktop-profile/chrome/
cp -rsf $PWD/fx-autoconfig/profile/chrome/* $PWD/desktop-profile/chrome

echo "cloning/updating firefox-second-sidebar"
git clone https://github.com/aminought/firefox-second-sidebar.git
cd firefox-second-sidebar
git pull
cd ..
echo "copying second sidebar stuff"
cp -rsf $PWD/firefox-second-sidebar/src/* $PWD/desktop-profile/chrome/JS/

echo "cleaning up dangling symlinks"
find . -xtype l -exec rm {} \;

echo "clearing startup cache"
rm -r desktop-profile/startupCache

xdg-icon-resource install --novendor --context apps --size 128 librewolf-source/themes/browser/branding/librewolf/default128.png librewolf
xdg-icon-resource install --novendor --context apps --size 128 librewolf-source/themes/browser/branding/librewolf/default64.png librewolf
xdg-icon-resource install --novendor --context apps --size 128 librewolf-source/themes/browser/branding/librewolf/default48.png librewolf
xdg-icon-resource install --novendor --context apps --size 128 librewolf-source/themes/browser/branding/librewolf/default32.png librewolf
xdg-icon-resource install --novendor --context apps --size 128 librewolf-source/themes/browser/branding/librewolf/default16.png librewolf
