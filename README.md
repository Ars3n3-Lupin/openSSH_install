# openSSH_install

This is the easyest way how to upgrade openSSH to the latest varion.

Please, download the folder called "latest". 
This folder consists the files we have to copy into /usr/lib/systemd/system/


Download latest folder and change owners of the files insied
+      sudo chown root:root ./latest/*
+      Copy four files from latest folder to /usr/lib/systemd/system/
+      First, a system update && upgrade
+      Second, installation dependencies
+      Third, compiling and install new version openSSH into /opt folder
+      Fourth, start ssh-latest.service 
