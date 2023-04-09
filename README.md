# openSSH_install

This is the easyest way how to upgrade openSSH to the latest varion.
At the time of writing this guide, the latest openSSH version is OpenSSH 9.3 released March 15, 2023.

Please, download the folder called "latest". 
This folder consists the files we have to copy into /usr/lib/systemd/system/

After the folder "latest" is downloaded, the owner of the files iside of the folder must be change
+      sudo chown root:root ./latest/*
+      sudo cp ./latest/* /usr/lib/systemd/system/
+      First, a system update && upgrade
+      Second, installation dependencies
+      Third, compiling and install new version openSSH into /opt folder
+      Fourth, start ssh-latest.service 
