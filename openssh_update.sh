#!/bin/bash
# Installation folder
# /opt/openssh
#
#
clear

# Update and Upgrade OS
sudo apt-get update && sudo apt full-upgrade -y && sudo apt-get dist-upgrade -y && sudo apt-get autoremove -y

# Set variable. OenSSH version
Old_VER="9.3p1"
VER="9.4p1"

sudo mkdir /opt/openssh-${VER}
cd /opt/openssh-${VER}

# Downloads openSSH
sudo wget --no-check-certificate https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${VER}.tar.gz
sudo tar -zxf openssh-${VER}.tar.gz

sudo rm -rf /opt/openssh-${VER}/openssh-${VER}.tar.gz

cd /opt/openssh-${VER}/openssh-${VER}

# Compilation of OpenSSH
sudo ./configure --without-openssl-header-check --prefix=/opt/openssh-${VER} --sysconfdir=/etc/ssh
sudo make
sudo make install

# Creates symbolic links
sudo ln -fvs /opt/openssh-${VER} /opt/openssh-latest
sudo ln -fvs /opt/openssh-latest /etc/ssh-latest

# Installation
sudo install -v -m700 -d /var/lib/sshd
sudo chown -v root:sys /var/lib/sshd
sudo groupadd sshd
sudo useradd  -c 'sshd PrivSep' -d /var/lib/sshd -g sshd -s /bin/false -u 50 sshd

# recreat new symbolic link
sudo systemctl stop ssh-latest
cd /opt
sudo rm -v openssh-latest
sleep 2
sudo ln -fvs openssh-${VER} openssh-latest
sleep 1

# Start SSH-latest.service
sudo systemctl enable ssh-latest.service
sudo systemctl enable ssh-latest.socket
sudo systemctl daemon-reload
sudo systemctl start ssh-latest.service
sudo systemctl start ssh-latest.socket
sudo systemctl stop ssh.service
sudo systemctl stop ssh.socket
sudo systemctl disable ssh.service
sudo systemctl disable ssh.socket
sudo systemctl daemon-reload
sudo systemctl restart ssh-latest.service
sudo systemctl stop ssh-latest.socket
sudo systemctl disable ssh-latest.socket
sudo systemctl daemon-reload

sudo rm -rf openssh-${Old_VER}
sudo rm -rf ./openssh_update.sh