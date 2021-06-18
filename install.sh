#!/bin/bash -e

set -x

sudo apt-get update --fix-missing

#Install Dependancies
sudo apt-get -y install jackd2 virtualenv python3-pip python3-dev git build-essential libasound2-dev libjack-jackd2-dev liblilv-dev libjpeg-dev zlib1g-dev cmake debhelper dh-autoreconf dh-python gperf intltool ladspa-sdk libarmadillo-dev libasound2-dev libavahi-gobject-dev libavcodec-dev libavutil-dev libbluetooth-dev libboost-dev libeigen3-dev libfftw3-dev libglib2.0-dev libglibmm-2.4-dev libgtk2.0-dev libgtkmm-2.4-dev libjack-jackd2-dev libjack-jackd2-dev liblilv-dev liblrdf0-dev libsamplerate0-dev libsigc++-2.0-dev libsndfile1-dev libsndfile1-dev libzita-convolver-dev libzita-resampler-dev lv2-dev p7zip-full python3-all python3-setuptools libreadline-dev

#Install Python Dependancies
sudo pip3 install pyserial==3.0 pystache==0.5.4 aggdraw==1.3.11 scandir backports.shutil-get-terminal-size
sudo pip3 install git+git://github.com/dlitz/pycrypto@master#egg=pycrypto

#Install Mod Software
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

#Browsepy
git clone https://github.com/moddevices/browsepy.git
cd browsepy
sudo pip3 install ./
cd ..

#Mod-host
git clone https://github.com/moddevices/mod-host.git
cd mod-host
make -j 4
sudo make install
make clean
cd ..

#Mod Control Chain
#git clone https://github.com/moddevices/cc-master.git
#cd cc-master
#./waf configure
#./waf build
#sudo ./waf install
#cd ..

#Mod-ttymidi
git clone https://github.com/moddevices/mod-ttymidi.git
cd mod-ttymidi
make -j 4
sudo make install
cd ..

#Mod-cabsim
git clone https://github.com/moddevices/mod-cabsim-IR-loader.git
cd mod-cabsim-IR-loader/source
make
cp -r cabsim-IR-loader.lv2 ~pi/.lv2/
cd ../..

#Veja cabsim
git clone https://github.com/VeJa-Plugins/Cabinet-Simulator.git
cd Cabinet-Simulator/cabsim/source
make
cp -r cabsim.lv2/ ~pi/.lv2
cd ../../..

#Veja bass cabsim
git clone https://github.com/VeJa-Plugins/Bass-Cabinets.git
cd Bass-Cabinets
make clean
make
cp -r veja-bass-cab.lv2/ ~pi/.lv2
cd ..

#tamgamp #TODO - very good sounding amp sim
git clone https://github.com/sadko4u/tamgamp.lv2.git
cd tamgamp.lv2
make
sudo make install
cp -r /usr/local/lib/lv2/tamgamp.lv2 ~pi/.lv2
cd ..

#Mod-ui
git clone https://github.com/moddevices/mod-ui.git
cd mod-ui
chmod +x setup.py
pip3 install -r requirements.txt
cd utils
make
cd ..
sudo ./setup.py install
cd ..
cp -r /home/pi/mod/mod-ui/default.pedalboard /home/pi/data

deb_file=audio.injector.scripts_0.1-1_all.deb
wget https://github.com/Audio-Injector/stereo-and-zero/raw/master/${deb_file}
sudo dpkg -i ${deb_file}
rm -f ${deb_file}
sudo sed -i 's/sudo rpi-update/#sudo rpi-update/' /usr/bin/audioInjector-setup.sh
/usr/bin/audioInjector-setup.sh
#sudo sed -i -e 's/hw:pisound/hw:audioinjectorpi/' /etc/jackdrc

# # Change amixer settings
cd /home/pi/install
# sudo cp asound.state.RCA.thru.test /usr/share/doc/audioInjector/asound.state.RCA.thru.test
# alsactl --file /usr/share/doc/audioInjector/asound.state.RCA.thru.test restore
# -P 70 -t 2000 -s -d alsa -d hw:audioinjectorpi -r 48000 -p 128 -n 2 -X raw

#Create Services
sudo cp *.service /usr/lib/systemd/system/
sudo ln -sf /usr/lib/systemd/system/jack.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-ttymidi.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/browsepy.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-host.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-ui.service /etc/systemd/system/multi-user.target.wants
sudo ln -sf /usr/lib/systemd/system/mod-monitor.service /etc/systemd/system/multi-user.target.wants
