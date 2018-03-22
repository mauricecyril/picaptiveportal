# picaptiveportal
Offline Raspberry Pi Captive Portal / Physical Web Space inspired by Anyfesto Pi.

wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/install.sh

sudo bash install.sh

## Requirements
* Raspberry Pi Zero W, Raspberry Pi 3, or Raspberry Pi 2 with Redbear WifiHat
* 16GB Micro SD Card
* Latest version of Raspbian Lite (Tested on Raspbian Stretch Lite)
* A Windows, OSX or Linux machine to write the Raspbian Lite image and activate ssh and setup wifi
* An internet connection
* SSH client to run the script after first boot


## Installation Instructions
### Step 1
Download latest version of Raspbian Lite:
https://www.raspberrypi.org/downloads/raspbian/

### Step 2
Unzip and write the downloaded image to an SD Card (ie. using Etcher, etc)
Instructions: https://www.raspberrypi.org/documentation/installation/installing-images/README.md

### Step 3
After the image has been written to the SD Card, eject the card and re-insert.

#### Manual Mounting Instructions on Linux
Insert SD Card and list all visible drives

### Step 4
Once the SD card has been mounted (or automounted) open up the /boot partition on the card

### Step 5
Create a blank file called SSH on the /boot partition of the SD card to make sure SSH is active on first boot.

For example:
```shell
df
cd /media/{your-username}/boot
```
Create the ssh file 
```shell
sudo touch ssh
```
### Step 6
Create a file on the /boot partition called "wpa_supplicant.conf"
Put your wifi details to make the raspberry pi connect to the internet / your router after the first boot (ie. headless mode).

Example wpa_supplicant.conf:
```
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
country=US

network={
	ssid="Your network SSID"
	psk="Your WPA/WPA2 security key"
	key_mgmt=WPA-PSK
}
```

### Step 7

Download the install script:
```shell
wget --no-check-certificate  https://raw.githubusercontent.com/mauricecyril/picaptiveportal/master/install.sh
```
Run the script as super user (sudo):
```shell
sudo bash install.sh
```
### Step 8
### Step 9
### Step 10
### Step 11
### Step 12

## Credits
* https://github.com/tomhiggins/anyfesto
* https://www.raspberrypi.org/forums/viewtopic.php?t=191252
* https://www.raspberrypi.org/documentation/configuration/security.md
