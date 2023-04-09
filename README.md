# openSSH_install

This is the easyest way how to upgrade openSSH to the latest varion.

Please, download the folder called "latest". 
This folder consists the files we have to copy into /usr/lib/systemd/system/

After the files are downloaded, change owner to root:root +
+ sudo chown root:root ./latest/* +
+ Copy four files from latest folder into /usr/lib/systemd/system/ +
+   1. First, a system update && upgrade                                       +
+   2. Second, installation dependencies                                       +
+   3. Third, compiling and install new version openSSH into /opt folder       +
+   4. Fourth, start ssh-latest.service 
