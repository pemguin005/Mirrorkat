#!/bin/bash

sudo apt-get update -qq

sudo apt-get install -qq yad 
sudo apt-get install -qq hfsprogs

if [ $? -eq 0 ]; then

	echo "Dependencies have installed and Mirrokat is ready for use!"
	read -n 1 -srp "Press any key to exit"
	echo 
	exit

else

	sudo dnf install -qy yad
	sudo dnf install -qy hfsplus-tools

		if [ $? -eq 0 ]; then

		echo "Dependencies have installed and Mirrokat is ready for use!"
		read -n 1 -srp "Press any key to exit"
		echo 
		exit

		fi
	fi

echo "Something went wrong..."

read -n 1 -srp "Press any key to exit"
echo 
exit
