#!/bin/bash

PASSWORD=root
PASSWORD2=live

echo -e "$PASSWORD\n$PASSWORD" | passwd root
echo -e "$PASSWORD2\n$PASSWORD2" | passwd live

echo -e > /home/live/Desktop/passwords.txt "root: $PASSWORD\nlive: $PASSWORD2"
chmod 666 /home/live/Desktop/passwords.txt