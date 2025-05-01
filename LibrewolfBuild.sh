#!/bin/bash

git clone --recursive https://gitlab.com/librewolf-community/browser/source.git librewolf-source
cd librewolf-source

rm -r librewolf-*/obj-*/dist/bin/*

make dir
make bootstrap
make build

cd ..
cp -s librewolf-source/librewolf-*/obj-*/dist/bin/librewolf .

