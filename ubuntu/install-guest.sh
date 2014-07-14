#!/bin/bash

apt-get update
apt-get -y upgrade 
apt-get install -y build-essential linux-headers-$(uname -r)

mount /dev/cdrom /mnt
/mnt/VBoxLinuxAdditions.run
umount -l /mnt

