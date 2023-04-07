#!/bin/bash
clear

# Variables ====+======


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
+   1. The first step is updating system                                       +
+   2. The second step is uninstalling old version openSSH-server && client    +
+   3. The third step is installing dependances                                +
+   4. The fourth step is compiling and installing new version openSSH         +
+   5. The fiveth step is is creting ssh.service file                          +
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
			"Uninstall openSSH-server && openSSH-client"
			"Install dependances"
			"Install openSSH-server && openSSH-client"
			"Create ssh.service file")
	PS3="$prompt"

	select opt in "${options[@]}" "Quit";
	do
		case "$REPLY" in
			"1") 
			clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++
+      I'm updatting && upgrading a system       +
++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
			sleep 2
			sudo apt-get update && sudo apt full-upgrade -y && sudo apt-get autoremove -y
			echo -e \033[3;00;35m "The System was successfully updated." \033[0m
			anew=yes
			sleep 3
			clear
			break
			;;
			"2") 
			clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++
+        I'm uninstalling openSSH-server         +
++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
			sleep 2
			sudo apt-get --purge remove openssh-client openssh-server -y
			sleep 3
$Magenta"OpenSSH-server && openSSH-client successfully uninstalled."$ENDS
			anew=yes
			sleep 5
			clear
			break
			;;
			"3")
			clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++
+             Installing dependances             +
++++++++++++++++++++++++++++++++++++++++++++++++++
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
			sleep 3
$Magenta"Dependances were successfully installed."$ENDS
			anew=yes
			sleep 5
			clear
			break
			;;
			"4") 
			clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
+          The next step is downloading an compiling openSSH         +
+                                                                    +
+   1. Moving to home directory                                      +
+   2. Downloading openSSH latest                                    +
+      Use this link to download latest openSSH                      +
+      https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/         +
+      Notes: file must be openSSH portable                          +
+   3.                                                               +
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
			cd ~/
$Magenta"Enter an openSSH version e.g. 9.2p1 : "$ENDS
			read VER
			echo openssh-${VER}

$Magenta"This is your install directory." $ENDS && pwd && echo ""
			sleep 2
			sudo wget https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-${VER}.tar.gz
			sleep 3
$Magenta "Extracting a file to ~/openssh-${VER}" $ENDS
			sleep 3
			# tar -z filter the archive through gzip -x extract 
			# -v verbosely list files processed -f archive file
			sudo tar -zxf openssh-${VER}.tar.gz
			cd ~/openssh-${VER}
$Magenta "$fileName will be removed." $ENDS
			sleep 3
			sudo rm -rf ~/openssh-${VER}.tar.gz
			sleep 3
$Magenta "OpenSSH will be compiled." $ENDS
			sleep 2
			sudo ./configure --prefix=/usr \
				--sysconfdir=/etc/ssh \
				--with-privsep-path=/var/lib/sshd \
				--with-default-path=/usr/bin \
				--with-superuser-path=/usr/sbin:/usr/bin \
				--with-pid-dir=/run \
				--with-md5-password
$Magenta "Data were successfully compiled" $ENDS
			sudo make
			sudo make install
			sudo install -v -m700 -d /var/lib/sshd
			sudo chown -v root:sys /var/lib/sshd
			sudo groupadd sshd
			sudo useradd  -c 'sshd PrivSep' -d /var/lib/sshd -g sshd -s /bin/false -u 50 sshd
$Magenta "Wait till sshd will be launched." $ENDS
			sleep 3
			anew=yes
			sleep 5
			clear
			break
			;;
			"5")
			clear
$Magenta"
++++++++++++++++++++++++++++++++++++++++++++++++++
+           Creating ssh.service file            +
++++++++++++++++++++++++++++++++++++++++++++++++++
"$ENDS
sleep 3
FILE=~/services
if [[ -e "$FILE" ]]; then
    sleep 2
    sudo rm -rf ~/services
else
    sleep 2
    mkdir $FILE
    cd $FILE
fi

# ===========================================>

FILE01=ssh@.service

sudo touch ./${FILE01}
sudo chown root:root ${FILE01}
sudo chmod 646 ${FILE01}

cat > ./${FILE01} <<EOF
[Unit]
Description=OpenBSD Secure Shell server per-connection daemon
Documentation=man:sshd(8) man:sshd_config(5)
After=auditd.service

[Service]
EnvironmentFile=-/etc/default/ssh
ExecStart=-/usr/sbin/sshd -i $SSHD_OPTS
StandardInput=socket
RuntimeDirectory=sshd
RuntimeDirectoryMode=0755
EOF
sudo chmod 644 ${FILE01}

# ===========================================>

FILE02=sshswitch.service

sudo touch ./${FILE02}
sudo chown root:root ${FILE02}
sudo chmod 646 ${FILE02}

cat > ./${FILE02} <<EOF
[Unit]
Description=Turn on SSH if /boot/ssh is present
ConditionPathExistsGlob=/boot/ssh{,.txt}
After=regenerate_ssh_host_keys.service

[Service]
Type=oneshot
ExecStart=/bin/sh -c "systemctl enable --now ssh && rm -f /boot/ssh /boot/ssh.txt"

[Install]
WantedBy=multi-user.target
EOF
sudo chmod 644 ${FILE02}

# ===========================================>

FILE03=ssh.socket

sudo touch ./${FILE03}
sudo chown root:root ${FILE03}
sudo chmod 646 ${FILE03}

cat > ./${FILE03} <<EOF
[Unit]
Description=OpenBSD Secure Shell server socket
Before=ssh.service
Conflicts=ssh.service
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Socket]
ListenStream=22
Accept=yes

[Install]
WantedBy=sockets.target
EOF
sudo chmod 644 ${FILE03}

# ===========================================>

FILE06=rescue-ssh.target

sudo touch ./${FILE06}
sudo chown root:root ${FILE06}
sudo chmod 646 ${FILE06}

cat > ./${FILE06} <<EOF
[Unit]
Description=Rescue with network and ssh
Documentation=man:systemd.special(7)
Requires=network-online.target ssh.service
After=network-online.target ssh.service
AllowIsolate=yes
EOF
sudo chmod 644 ${FILE06}

# ===========================================>

FILE06=ssh.service

sudo touch ./${FILE06}
sudo chown root:root ${FILE06}
sudo chmod 646 ${FILE06}

cat > ./${FILE06} <<EOF
[Unit]
Description=OpenBSD Secure Shell server
Documentation=man:sshd(8) man:sshd_config(5)
After=network.target auditd.service
ConditionPathExists=!/etc/ssh/sshd_not_to_be_run

[Service]
EnvironmentFile=-/etc/default/ssh
ExecStartPre=/usr/sbin/sshd -t
ExecStart=/usr/sbin/sshd -D
ExecReload=/usr/sbin/sshd -t
ExecReload=/bin/kill -HUP
KillMode=process
Restart=on-failure
RestartPreventExitStatus=255
Type=notify
RuntimeDirectory=sshd
RuntimeDirectoryMode=0755

[Install]
WantedBy=multi-user.target
Alias=sshd.service
EOF
sudo chmod 644 ${FILE06}

# ===========================================>

FILE06=regenerate_ssh_host_keys.service

sudo touch ./${FILE06}
sudo chown root:root ${FILE06}
sudo chmod 646 ${FILE06}

cat > ./${FILE06} <<EOF
[Unit]
Description=Regenerate SSH host keys
Before=ssh.service
ConditionFileIsExecutable=/usr/bin/ssh-keygen

[Service]
Type=oneshot
ExecStartPre=-/bin/dd if=/dev/hwrng of=/dev/urandom count=1 bs=4096
ExecStartPre=-/bin/sh -c "/bin/rm -f -v /etc/ssh/ssh_host_*_key*"
ExecStart=/usr/bin/ssh-keygen -A -v
ExecStartPost=/bin/systemctl disable regenerate_ssh_host_keys

[Install]
WantedBy=multi-user.target
EOF
sudo chmod 644 ${FILE06}

sudo cp $FILE/* /usr/lib/systemd/system

sudo rm -rf $FILE

sleep 3
#			sudo systemctl enable /etc/systemd/system/ssh.service
#			sudo systemctl start /etc/systemd/system/ssh.service
#			sudo systemctl status ssh
$Magenta " 
********************************************************************************************
+   Data were added to /lib/systemd/system/. Now, enable and start ssh.service manually.   +
+                                                                                          +
+   1. sudo systemctl enable /etc/systemd/system/ssh.service                               +
+   2. sudo systemctl start /etc/systemd/system/ssh.service                                +
+   3. sudo systemctl status ssh                                                           +
+                                                                                          +
********************************************************************************************
"$ENDS

			countdown 12	
			anew=yes
			clear
			break
			;;
			$((${#options[@]}+1))) echo "Goodbye!"; 
			break;;
			*) echo "invalid option $REPLY"; 
			continue;;
		esac
	done
done
