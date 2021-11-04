#!/bin/bash -e

set -x

sudo apt-get update --allow-releaseinfo-change --fix-missing

#Install Dependancies
sudo apt-get -y install virtualenv python3-pip python3-dev git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev cmake debhelper dh-autoreconf dh-python gperf intltool ladspa-sdk libarmadillo-dev libasound2-dev libavahi-gobject-dev libavcodec-dev libavutil-dev libbluetooth-dev libboost-dev libeigen3-dev libfftw3-dev libglib2.0-dev libglibmm-2.4-dev libgtk2.0-dev libgtkmm-2.4-dev libjack-jackd2-dev libjack-jackd2-dev liblilv-dev liblrdf0-dev libsamplerate0-dev libsigc++-2.0-dev libsndfile1-dev libsndfile1-dev libzita-convolver-dev libzita-resampler-dev lv2-dev p7zip-full python3-all python3-setuptools libreadline-dev

#Install Python Dependancies
sudo pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11 scandir backports.shutil-get-terminal-size
sudo pip3 install git+git://github.com/dlitz/pycrypto@master#egg=pycrypto

#Install Mod Software
mv /home/pi/mod /home/pi/install
mkdir /home/pi/.lv2
mkdir /home/pi/mod
mkdir /home/pi/data
mkdir /home/pi/data/pedalboards
mkdir /home/pi/data/user-files
cd /home/pi/data/user-files
mkdir "Speaker Cabinets IRs"
mkdir "Reverb IRs"
mkdir "Audio Loops"
mkdir "Audio Recordings"
mkdir "Audio Samples"
mkdir "Audio Tracks"
mkdir "MIDI Clips"
mkdir "MIDI Songs"
mkdir "Hydrogen Drumkits"
mkdir "SF2 Instruments"
mkdir "SFZ Instruments"
cd /home/pi/mod

#Jack2
sudo apt-get install -y jackd2

#Browsepy
git clone https://github.com/moddevices/browsepy.git
cd browsepy
sudo pip3 install ./
cd ..

#Mod-host
git clone --branch hotfix-1.10 https://github.com/moddevices/mod-host.git
cd mod-host
make -j 4
sudo make install
make clean
cd ..

#Mod-ui
git clone --branch hotfix-1.10-filehandling https://github.com/moddevices/mod-ui.git
cd mod-ui
chmod +x setup.py
pip3 install -r requirements.txt
cd utils
make
cd ..
sudo ./setup.py install
cd ..
cp -r /home/pi/mod/mod-ui/default.pedalboard /home/pi/data

#Create Services
cd /home/pi/install
sudo cp *.service /usr/lib/systemd/system/
sudo ln -sf /usr/lib/systemd/system/browsepy.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-host.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-ui.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-monitor.service /etc/systemd/system/multi-user.target.wants
sudo ln -s /home/pi/data /root/data
sudo ln -s /home/pi/data/pedalboards /root/.pedalboards
