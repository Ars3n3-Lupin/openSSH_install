#!/bin/bash
# Installation folder
# /opt/openssh
#
#
clear

# Colors ==============
# Style - backgroud - Forground
Magenta="echo -e \033[3;00;35m"
Blue="echo -e \033[3;00;36m"
ENDS="\033[0m"
# =====================
# Functions ==========
countdown(){
    i=${1-$cdNum}
    while [ "$i" -ge 1 ]; do
    printf '\r%s ' "$i"
    i=`expr $i - 1`
    sleep 1
    done
}
# =====================
echo ""
$Blue"
********************************************************************************
+                   This is an openSSH installation file                       +
+                                                                              +
+      Download the folder called "latest" and change owner of the files       +
+      sudo chown root:root ./latest/*                                         +
+      Copy four files from latest folder to /usr/lib/systemd/system/          +
+   1. System update && upgrade                                                +
+   2. Install dependencies                                                    +
+   3. Compile and install new version openSSH into /opt folder                +
+   4. If openSSH was upgraded before and now, you want to upgrade openSSH     +
+      again, press 5 to recreate simbolic links                               +
+   5. Start ssh-latest.service                                                +
+                                                                              +
********************************************************************************
"$ENDS
echo ""
echo ""

anew=yes
while [ "$anew" = yes ]; do
    anew=no

	prompt='Enter your choice, please: '
	options=("Update && upgrade a system"
			"Install dependances"
			"Install openSSH-server && openSSH-client"
			"Create symbolic link"
			"Recreate symbolic link, new version"
			"Start ssh-latest.service"
			"What port is activated"
			"Check the version"
			"SSHD proceses running"
			"Check ssh services active")
	PS3="$prompt"

	select opt in "${options[@]}" "Quit";
	do
	case "$REPLY" in
	"1") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+          The system is going to be updated && upgraded         +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
"$ENDS
		sleep 2
		sudo apt-get update && sudo apt full-upgrade -y && sudo apt-get autoremove -y
$Magenta"System was successfully updated."$ENDS
		anew=yes
		sleep 3
		clear
		break
	;;
	"2")
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                      Installing dependances                    +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
"$ENDS
		sleep 2
		sudo apt install libssl-dev \
				gcc \
				g++ \
				gdb \
				cpp -y
		sudo apt install make \
						cmake \
						libtool \
						libc6 \
						autoconf \
						automake \
						pkg-config \
						build-essential \
						gettext -y
		sudo apt install libzstd1 \
						zlib1g \
						libssh-4 \
						libssh-dev \
						libc6-dev \
						libc6 \
						libcrypt-dev -y
		sudo apt install netcat lsof
$Magenta"Dependances are successfully installed."$ENDS
		anew=yes
		sleep 3
		clear
		break
	;;
	"3") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+               Add an openSSH vesrion and install               +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
"$ENDS

		echo -en "\033[3;00;36m Enter an openSSH version e.g. 9.3p1 : \033[0m"
		read VER
		echo openssh-${VER}

		sudo mkdir /opt/openssh-${VER}
		cd /opt/openssh-${VER}

$Magenta"This is your home directory." $ENDS && pwd && echo ""
sleep 3

		sudo wget --no-check-certificate https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${VER}.tar.gz
		# tar -z filter the archive through gzip -x extract 
		# -v verbosely list files processed -f archive file
		sudo tar -zxf openssh-${VER}.tar.gz

		sudo rm -rf /opt/openssh-${VER}/openssh-${VER}.tar.gz

		cd /opt/openssh-${VER}/openssh-${VER}
		pwd
sleep 3

$Magenta "OpenSSH is going to be compiled." $ENDS
sleep 3
		sudo ./configure --without-openssl-header-check --prefix=/opt/openssh-${VER} --sysconfdir=/etc/ssh
		sudo make
		sudo make install
sleep 5
		anew=yes
		clear
		break
	;;
	"4") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                    Create symbolic links                       +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
		sleep 3
		sudo ln -fvs /opt/openssh-${VER} /opt/openssh-latest
		sudo ln -fvs /opt/openssh-latest /etc/ssh-latest
		clear
$Magenta "Successfully installed" $ENDS
		sudo install -v -m700 -d /var/lib/sshd
		sudo chown -v root:sys /var/lib/sshd
		sudo groupadd sshd
		sudo useradd  -c 'sshd PrivSep' -d /var/lib/sshd -g sshd -s /bin/false -u 50 sshd
		sleep 3
		anew=yes
		clear
		break
	;;
	"5") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+         After new installation recreat new symbolic link       +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
		if [[ -z "${VER}" ]]; then
			echo -en "\033[3;00;36m Enter an openSSH version e.g. 9.3p1 : \033[0m"
			read VER
			echo openssh-${VER}
			sleep 3
			sudo systemctl stop ssh-latest
			cd /opt
			sudo rm -v openssh-latest
			sleep 2
			sudo ln -fvs openssh-${VER} openssh-latest
			sleep 1
			sudo systemctl start ssh-latest
$Magenta "Symlink is successfully recreated" $ENDS
			sleep 3
			anew=yes
			clear
			break
		  else
			sleep 3
			sudo systemctl stop ssh-latest
			cd /opt
			sudo rm -v openssh-latest
			sleep 3
			sudo ln -fvs openssh-${VER} openssh-latest
			sudo systemctl start ssh-latest
$Magenta "Symlink is successfully recreated" $ENDS
			sleep 3
			anew=yes
			clear
			break
		fi
	;;
	"6") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                    Start SSH-latest.service                    +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
		sleep 3
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
        sudo systemctl start ssh-latest.service
        sudo systemctl stop ssh-latest.socket
        sudo systemctl disable ssh-latest.socket
        sudo systemctl daemon-reload
        sudo systemctl status ssh-latest.service
		sleep 3
		clear
		anew=yes
		clear
		break
	;;
	"7") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                    What port is activated                      +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
		echo "Here is the port which is activated"
		echo "sudo lsof -PVn -iTCP | grep sshd | grep LISTEN"
		echo ""
		sudo lsof -PVn -iTCP | grep sshd | grep LISTEN
		sleep 3
		echo ""
		anew=yes
		break
	;;
	"8") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                   Check an installed vrsion                    +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
		echo "echo | nc localhost 22"
		echo ""
		echo "Enter your actual port: "
		read PORT
		echo | nc localhost ${PORT}
		sleep 3
		echo ""
		anew=yes
		break
	;;
	"9") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+         There are two different sshd -D daemon processes       +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
		echo "ps -ef --forest | grep "sshd -D""
		echo ""
		sudo ps -ef --forest | grep "sshd -D"
		echo ""
		sleep 3
		anew=yes
		break
	;;
	"10") 
		clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+                   Check ssh services active                    +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
		sudo systemctl status ssh-latest
		sleep 1
		sudo systemctl status ssh-latest.socket
		sleep 1
		sudo systemctl status ssh.socket
		sleep 1
		sudo systemctl status ssh
		countdown 7
		clear
		anew=yes
		break
	;;
		$((${#options[@]}+1))) echo "Goodbye!"; 
		break;;
		*) echo "invalid option $REPLY"; 
		continue;;
		esac
	done
done
