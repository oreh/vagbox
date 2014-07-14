#!/bin/bash
 
# Credits to:
#  - http://vstone.eu/reducing-vagrant-box-size/
#  - https://github.com/mitchellh/vagrant/issues/343
 
echo '***** clean disk spaces *****'

# Remove APT cache
apt-get clean -y
apt-get autoclean -y
 
# Zero free space to aid VM compression
# dd if=/dev/zero of=/EMPTY bs=1M
# rm -f /EMPTY
 
# Remove bash history
unset HISTFILE
rm -f /root/.bash_history
 
# Cleanup log files
find /var/log -type f | while read f; do echo -ne '' > $f; done;
 
# Whiteout root
count=`df --sync -kP / | tail -n1  | awk -F ' ' '{print $4}'`; 
let count--
echo / count:  $count
dd if=/dev/zero of=/tmp/whitespace bs=1024 count=$count;
rm /tmp/whitespace;
 
# Whiteout /boot
count=`df --sync -kP /boot | tail -n1 | awk -F ' ' '{print $4}'`;
let count--
echo /boort count: $count
dd if=/dev/zero of=/boot/whitespace bs=1024 count=$count;
rm /boot/whitespace;
 
swappart=`cat /proc/swaps | tail -n1 | awk -F ' ' '{print $1}'`
if [ $swappart != 'Filename' ]; then
    swapoff $swappart;
    dd if=/dev/zero of=$swappart;
    mkswap $swappart;
    swapon $swappart;
fi

# clean net rules if exists
net_rule=/etc/udev/rules.d/70-persistent-net.rules
if [ -e $net_rule ]; then
    rm -f $net_rule
fi
