#!/bin/bash 
#Author: New Wavex86 
#Date Created: Tue 08 Sep 2020
#Simple script to install the plex media server
#Automated instructions from this guide linuxize.com/post/how-to-install-plex-media-server-on-raspberry-pi/


#Get color 
if [ -f $HOME/snippets/color ];
then
	source $HOME/snippets/color
fi

#Check if sudo exists
if [[ $(dpkg-query -s sudo) ]];
then
	echo "Sudo exists!"

else
	echo -e "${RED} Sudo does not exist please install it and run script again $RESET"
	exit 2
fi

#Update packages, enable a new repository over https
sudo apt update
sudo apt install apt-transport-https ca-certificates curl

#Import the repository's GPG Key
curl https://downloads.plex.tv/plex-keys/PlexSign.key | sudo apt-key add -

#Add the APT repository to your software repository
echo deb https://downloads.plex.tv/repo/deb public main | sudo tee /etc/apt/sources.list.d/plexmediaserver.list

sudo apt update
sudo apt install plexmediaserver #Install the actual service

#Verify the plex service is running
VERIFY=$( sudo systemctl status plexmediaserver | grep Active | awk ' { print $2}')
if [ "$VERIFY" == "active" ];
then
	echo -e "${GREEN}Plex is running as a service!$RESET"

else
	sudo systemctl enable plexmediaserver
	sudo systemctl start plexmediaserver
	if [ ! "$VERFIY" == "active" ]; #Check if it wasn't enabled
	then
		echo -e "${RED}Plex is not running as a service, please check apt if installed properly$RESET"
		echo -e "${RED} If possible you might have to unmask the service$RESET"
		echo "Exiting Now"
		sleep 1
		exit 2
	else
		echo -e "${GREEN} Plex is running $RESET"
	fi
fi

echo "Setup all done, please log into the Plex Media Server, and choose the folders you want to serve"
echo "If your serving the files from a Seagates or NFS drive, please run the accompanying script for them to work"
sleep 1


exit 0 
