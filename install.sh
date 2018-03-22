#!/bin/bash

# Basic Captive Portal for Raspberry Pi Zero and Raspberry Pi 3
# Based on the Anyfesto Install Script for the PI
# See original project: https://github.com/tomhiggins/anyfesto
#
# Run the following in the command shell
# wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/install.sh
# bash install.sh

# Install the Basic Packages and Infrastructure

echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Starting the Offline Captive Portal Install...."
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Installing the Basic Packages and Infrastructure."
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install lighttpd dnsmasq isc-dhcp-server hostapd git zip unzip tar bzip2 perl python python3 php5-cgi avahi-daemon nano python3-django python3-flask

sudo rm /bin/sh
sudo ln /bin/bash /bin/sh
sudo chmod a+rw /bin/sh
cd ~
mkdir configs

# Setup the Directories and lighttpd 
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up the Directories and Lighttp Web Server"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
mkdir /home/pi/content
sudo ln -s /home/pi/content /var/www/html/content   
cd ~
wget https://github.com/twbs/bootstrap/releases/download/v3.3.7/bootstrap-3.3.7-dist.zip
unzip bootstrap-3.3.7-dist.zip 
sudo cp -r bootstrap-3.3.7-dist/* /var/www/html/
cd /var/www/html/js
sudo wget https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js


# Setup Network and Captive Portal 
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up The Network, Access Point and Captive Portal"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
cd ~/configs
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/dhcpd.conf 
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/dnsmasq.conf
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/hostapd
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/hostapd.conf
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/interfaces
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/isc-dhcp-server
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/lighttpd.conf
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/hosts
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles/hostname

sudo chown root:root *
sudo chmod a+rx *

sudo mv -f dhcpd.conf /etc/dhcp/dhcpd.conf
sudo mv -f dnsmasq.conf /etc/dnsmasq.conf
sudo mv -f hostapd /etc/default/hostapd
sudo mv -f hostapd.conf /etc/hostapd/hostapd.conf 
sudo mv -f interfaces /etc/network/interfaces 
sudo mv -f isc-dhcp-server /etc/default/isc-dhcp-server
sudo mv -f lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo mv -f hosts /etc/hosts
sudo mv -f hostname /etc/hostname



echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Installation Complete...Preparing To Reboot"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
read -p "Press any key to reboot the PI."
sudo /etc/init.d/hostapd  stop
sudo systemctl daemon-reload 
sudo update-rc.d mumble-server enable
sudo update-rc.d hostapd enable
sudo update-rc.d isc-dhcp-server enable 
sudo ifconfig wlan0 down
sudo ifconfig wlan0 up
sudo sync 
sudo reboot
