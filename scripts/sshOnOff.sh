#!/bin/bash

## this file location:
#   /sbin/sshStart
## set runable:
#	chmod 555 /sbin/sshStart
#
## Run as root without password
# visudo
## add as ! LAST ! line
# 	ALL ALL=(ALL) NOPASSWD: /sbin/sshStart
#
## Desktop link to start / stop sshd
# nano /home/live/Desktop/ssh.desktop
#   sudo /sbin/sshStart
# chmod 555 /home/live/Desktop/ssh.desktop
#
#
## disabled sshd on boot time
# systemctl disable ssh.service

# is sshd running
systemctl is-active --quiet ssh.service

# is running -> stop sshd
# is not running -> start sshd
if [ $? -eq 0 ]
then
	echo "Shutdown ssh!"
	systemctl stop ssh.service
else
	echo "Starting ssh!"
	systemctl start ssh.service
fi

# show info to user, can be skipped
sleep 5