#!/bin/bash
echo "########### Changing to home dir"
cd ~
echo "########### Updating Ubuntu"
sudo apt-get update && sudo apt-get -y upgrade
sudo apt-add-repository -y ppa:bitcoin/bitcoin
sudo apt-get -y install bitcoind

echo "########### Creating Swap"
#dd if=/dev/zero of=/swapfile bs=1M count=2048 ; mkswap /swapfile ; swapon /swapfile
#echo "/swapfile swap swap defaults 0 0" >> /etc/fstab

echo "########### Creating config"
config="/usr/bin/bitcoin.conf"
sudo touch $config
sudo echo "server=1" > $config
sudo echo "daemon=1" >> $config
sudo echo "connections=40" >> $config
randUser=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
randPass=`< /dev/urandom tr -dc A-Za-z0-9 | head -c30`
sudo echo "rpcuser=$randUser" >> $config
sudo echo "rpcpassword=$randPass" >> $config


echo "########### Setting up autostart (cron)"

sudo touch /root/script.sh
sudo echo "/usr/bin/bitcoind -daemon -conf=/usr/bin/bitcoin.conf" >> /root/script.sh
sudo chmod u+x /root/script.sh
echo "sh /root/script.sh &" >> /etc/rc.local
sudo echo "@reboot /usr/bin/bitcoind -daemon -conf=/usr/bin/bitcoin.conf" >> /etc/crontab

/usr/bin/bitcoind -daemon -conf=/usr/bin/bitcoin.conf
# reboot
