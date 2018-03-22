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

# Upgrade and Install Packages
# Packages Needed for Captive Portal and Access Point: lighttpd dnsmasq isc-dhcp-server hostapd php-cgi avahi-daemon 
# Unzip Packages (Just in Case): git zip unzip tar bzip2 
# Additional Packages for Offline Dev: perl python python3 nano python3-django python3-flask
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y install lighttpd dnsmasq isc-dhcp-server hostapd git zip unzip tar bzip2 perl python python3 php-cgi avahi-daemon nano python3-django python3-flask

sudo rm /bin/sh
sudo ln /bin/bash /bin/sh
sudo chmod a+rw /bin/sh
cd ~

# Make config folder that will be used to store config files from https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/configfiles
mkdir configs

# Setup the Directories and lighttpd 
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up the Directories and Lighttp Web Server"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"

# Create a "Content" folder in the home folder
mkdir /home/pi/content

# Link the content folder to the html folder
sudo ln -s /home/pi/content /var/www/html/content   

# Remove default index.html from /var/www/html
cd /var/www/html
sudo mv index.html index.backup

# Download new index html
sudo wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/html/index.html

# Download bootstrap and copy to /var/www/html folder
cd ~
wget https://github.com/twbs/bootstrap/releases/download/v3.3.7/bootstrap-3.3.7-dist.zip
unzip bootstrap-3.3.7-dist.zip 
sudo cp -r bootstrap-3.3.7-dist/* /var/www/html/

# Download carousel style sheet
cd /var/www/html/css
sudo wget https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/html/carousel.css

# Download jsquery
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


# Install UFW as firewall
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Setting Up Firewall"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"

# Install ufw
sudo apt-get -y install ufw

# Setup default rules with incoming blocked
sudo ufw default allow outgoing
sudo ufw default deny incoming

# Update the incoming to only allow SSH (22), HTTP (80), HTTPS (443)
sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

# Enable firewall
sudo ufw --force enable


echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
echo "Installation Complete...Preparing To Reboot"
echo "-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_"
read -p "Press any key to reboot the PI."
sudo /etc/init.d/hostapd  stop
sudo systemctl daemon-reload 
sudo update-rc.d hostapd enable
sudo update-rc.d isc-dhcp-server enable 
sudo ifconfig wlan0 down
sudo ifconfig wlan0 up
sudo sync 
sudo reboot
