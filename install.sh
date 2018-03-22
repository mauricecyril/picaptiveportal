#!/bin/bash

# Basic Captive Portal for Raspberry Pi Zero and Raspberry Pi 3
# Based on the Anyfesto Install Script for the PI
# See original project: https://github.com/tomhiggins/anyfesto 

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
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/dhcpd.conf 
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/dnsmasq.conf
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/hostapd
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/hostapd.conf
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/interfaces
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/isc-dhcp-server
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/lighttpd.conf
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/hosts
wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/configfiles/hostname

sudo chown root:root *
sudo chmod a+rx *

sudo mv -f dhcpdpi.conf /etc/dhcp/dhcpd.conf
sudo mv -f dnsmasqpi.conf /etc/dnsmasq.conf
sudo mv -f hostapd /etc/default/hostapd
sudo mv -f hostapdpi.conf /etc/hostapd/hostapd.conf 
sudo mv -f interfacespi /etc/network/interfaces 
sudo mv -f isc-dhcp-serverpi /etc/default/isc-dhcp-server
sudo mv -f lighttpd.conf /etc/lighttpd/lighttpd.conf
sudo mv -f hostspi /etc/hosts
sudo mv -f hostnamepi /etc/hostname



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
