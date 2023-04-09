# openSSH_install

This is the easiest way how to upgrade openSSH to the latest verion.
At the time of writing this guide, the latest openSSH version is OpenSSH 9.3 portable released March 15, 2023 available on this web page
https://cdn.openbsd.org/pub/OpenBSD/OpenSSH/portable/

First of all, baskup sshd_config file.
+      sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config_bkp
This config file will be used by new instalation

Please, download the folder called "latest". 
This folder consists the files we have to copy into /usr/lib/systemd/system/

After the folder "latest" is downloaded, the owner of the files iside of the folder must be change
+      sudo chown root:root ./latest/*
+      sudo cp ./latest/* /usr/lib/systemd/system/

For installation proces we use the file "./openSSH_opt_install.sh"
To execute this file we have to chage mode to executable file
+      sudo chmod +x ./openSSH_opt_install.sh

After executing the file please, follow instractions on the screen.

 - Download the folder called "latest" and change owner of the files
 - System update && upgrade
 - Install dependencies
 - Compile and install new version openSSH into /opt folder
 - If openSSH was upgraded before and now, you want to upgrade openSSH
   again, press 5 to recreate simbolic links
 - Start ssh-latest.service
 - Check what posrt is activated to use ssh
 - Check what version of SSH is running
