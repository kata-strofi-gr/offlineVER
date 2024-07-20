This guide will walk you through the process of installing MongoDB on Windows and configuring it with PHP on XAMPP (SOS PHP Version 8.1.25 xampp ).

XAMPP : all syte must be under the folder C:\xampp\htdocs

Step 1: Download MongoDB Driver

Download the latest stable release of the MongoDB THREAD SAFE driver for Windows from https://pecl.php.net/package/mongodb/1.13.0/windows.
Extract the downloaded file and copy the .dll file to the ext directory of your XAMPP installation. For example, if you installed XAMPP to the C drive, the full path to the ext folder would be C:\xampp\php\ext.
Step 2: Modify php.ini

Open the php.ini file in a text editor.
Add the following line to the php.ini file:
extension=php_mongodb.dll
Save the php.ini file.
Step 3: Restart Apache

Restart the Apache server in XAMPP.
Step 4: Install MongoDB Server

Download the latest stable release of MongoDB from https://www.mongodb.com/try/download/community.
Choose the custom setup type and install MongoDB to the C:\mongodb folder.

