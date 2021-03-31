#!/bin/bash

git clone https://github.com/moddevices/mod-host
git clone https://github.com/moddevices/mod-ui
git clone https://github.com/micahvdm/mod
#wget https://drive.google.com/file/d/1lWgu4jEL0AUsyYNAYgu54fr-o3XSiFIB/view?usp=sharing

mkdir .lv2
#unzip plugins.zip
#cd plugins
#sudo mv * $HOME/.lv2

sudo apt-get install virtualenv python3-pip python3-dev git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev liblilv-dev libreadline-moddevices

cd mod-host
make
sudo make install
cd ..
cd mod-ui
sudo pip3 install -r requirements.txt
sudo make -C utils
cd ..
cd mod
sudo cp mod-ui.service mod-host.service /usr/lib/systemd/system

