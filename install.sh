#!/bin/bash

sudo apt-get install -qq yad 
sudo apt-get install -qq hfsprogs

LINUX=$?
if [[ $LINUX eq -1 ]]; do


else

sudo dnf install -qy yad
sudo dnf install -qy hfsplus-tools
