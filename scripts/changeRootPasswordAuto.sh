#!/bin/bash

PASSWORD=$(openssl rand -hex 6)
PASSWORD2=$(openssl rand -hex 6)


su - root <<!
root
echo -e "$PASSWORD\n$PASSWORD" | passwd root
echo -e "$PASSWORD2\n$PASSWORD2" | passwd live
!

echo -e > /home/live/Desktop/passwords.txt "root: $PASSWORD\nlive: $PASSWORD2"
chmod 666 /home/live/Desktop/passwords.txt

#echo "root:$PASSWORD" | chpasswd

#echo -e "$PASSWORD\n$PASSWORD" | passwd root