#!/bin/bash
# Proper header for a Bash script.

# Check for root user login
if [ ! $( id -u ) -eq 0 ]; then
	echo "You must be root to run this script."
	echo "Please enter su before running this script again."
	exit
fi

USERNAME=$(logname)
IS_CHROOT=0

# The remastering process uses chroot mode.
# Check to see if this script is operating in chroot mode.
# If /home/$USERNAME exists, then we are not in chroot mode.
if [ -d "/home/$USERNAME" ]; then
	IS_CHROOT=0 # not in chroot mode
	DIR_DEVELOP=/home/$USERNAME/develop 
else
	IS_CHROOT=1 # in chroot mode
	DIR_DEVELOP=/usr/local/bin/develop 
fi

echo "CHANGING CONKY"

if [ $IS_CHROOT -eq 0 ]; then
	rm /home/$USERNAME/.conkyrc
	cp $DIR_DEVELOP/conky/dot_conkyrc/conkyrc-diet /home/$USERNAME/.conkyrc
	chown $USERNAME:users /home/$USERNAME/.conkyrc
fi

rm /etc/skel/.conkyrc
cp $DIR_DEVELOP/conky/dot_conkyrc/conkyrc-diet /etc/skel/.conkyrc
if [ $IS_CHROOT -eq 0 ]; then
	chown $USERNAME:users /etc/skel/.conkyrc
else
	chown demo:users /etc/skel/.conkyrc
fi