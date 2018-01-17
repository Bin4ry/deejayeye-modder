# deejayeye-modder

![UNLOCK](https://i.imgflip.com/1ssr9s.jpg)

![UDONTSAY](https://image.ibb.co/e4bWLQ/dji_statement.png)

![BRINGIT](https://gifyu.com/images/bringit.gif)

This software is free to use, feel free to modify.

Only thing i ask for is to link this git as a start point of your own modifications.


## Disclaimer:


I am not responsible for any damage done! Use your brain and all will be fine!

Also i will not include any apk to this git! You have to do everything yourself, if you cannot you should not play with stuff like this!

## Donations

Due to request i add some donation methods, thank you very much for donating so the hacking of this stuff can go on :)

PayPal: andreas.makris@gmail.com

BTC: 1QKMFRMkauTXii8MGrYvt3C6m5dTjym9NG

BCH: 12UnxVsA1Q9AHpy384spTVDNJVnudPZWXP

ETH: 0x8fc3461e971790498eb43b4608ba58f7e4300c98

thank you emails :) -> andreas.makris@gmail.com



## Want to contribute or learn some stuff? 
Join our Slack (this is where the magic happens):
https://join.slack.com/t/dji-rev/shared_invite/enQtMjk5OTEyMzcyMjI3LTdlZjY4NzQ5M2M2NmE5ZWM4OTgyNThmZDVmZjdjODE4ODYyNmYwZjYxMDcyYzcxNmZlYzI5ZjI2ZGQ2NGY1ZTc

## What is the latest version to work?

Latest version which works with this patches is app version 4.1.15, since the original version is encrypted you need a special decrypted version. This version can be found online.
The filename is "4.1.15_V3027412-nosecneo" ONLY THIS VERSION is supported, you will not find this version on apk-mirror or such!
For further information come to slack and join #android-apk-patching

## App version >= 4.1.4

Starting from 4.1.4 the CC check dialog is gone and will not come back (still the fcc patch code is present and working)

## FCC 

If you get a message about different region etc. etc after using the FCC patch: YOU HAVE TO CLICK OK ONCE AFTER THE PATCH IS APPLIED! This will reboot the AC with the new Region (FCC REGION). Once you use and unmodded app the same popup will come again and if you click OK now it will reboot and apply the limits of your current region again!

## HowTo:

### Linux:

1. make sure you have dialog installed: sudo apt-get install dialog
2. Download needed tools manually or run the script provided.

   a) Download apktool, rename it to apktool.jar and save it to tools folder: https://bitbucket.org/iBotPeaches/apktool/downloads/

   b) Download sign.jar from https://github.com/appium/sign/raw/master/dist/sign.jar and put it in tools folder

3. Get the apk to modify (ver. **4.1.3**), try 'Raccoon, the apk downloader' (Linux/OSX/Windows), you can get it here: http://raccoon.onyxbits.de/, or try a mirror such as http://www.apkmirror.com/

4. RunMe.sh or RunMeNg.sh (Ng version has new features!)

### macOS:

1. Install the required dependencies with [Brew](https://brew.sh/):

	`brew install dialog dos2unix imagemagick webp`

2. Download needed tools manually or run the script provided.

   a) Download [apktool](https://bitbucket.org/iBotPeaches/apktool/downloads/), rename it to `apktool.jar` and save it
   to `tools` folder.

   b) Download [sign.jar](https://github.com/appium/sign/raw/master/dist/sign.jar) and save it to `tools` folder.

3. Get the apk to modify (ver. **4.1.3**), try 'Raccoon, the apk downloader' (Linux/OSX/Windows), you can get it here: http://raccoon.onyxbits.de/, or try a mirror such as http://www.apkmirror.com/

4. RunMe.sh or RunMeNg.sh (Ng version has new features!)

### Windows
(For Windows there is currently no support of the new features [app-cloning etc.] like in the Ng version on Linux)

1. You may need to install Java Development Kit, you can get it here: http://www.oracle.com/technetwork/java/javase/downloads/index.html
2. Run the download_tools.bat file
3. Get the apk (look in the patches folder for supported versions), check above for link
4. RunMe.bat (as Administrator)


### URLs patching

two new tools designed for that purpose instead of the old patching way
search_urls.sh and url_patcher.sh
both take one argument which is the name of the decompiled directory

search_urls.sh generate some config files in __MODDED_APK_OUT__/urls/subdir_with_name_of_workdir
the file fogged_urls.txt and unfogged_urls.txt can (must) be edited, changing the first column to enable / disable further application by the second script :
the default files DO NOT DISABLE any url in order not to break the app. The files must be edited to goOffline (or partially offline)

url_patcher.sh applies the patching prepared in __MODDED_APK_OUT__/urls/subdir_with_name_of_workdir

THIS DO NOT MEAN that the app can not reach servers by other path... take care...

#### UPDATE: No more NFZ stuff here.

##### Reasons:

1. I don't want people flying in NFZ
2. It did not work consistently

If you want to fly in a RED NFZ AND are allowed to AND have problems with them activating your account to do so you should fallback to the firmware parameter change. This was never meant to help people fly in RED NFZ!


### #DeejayeyeHackingClub information repos aka "The OG's" (Original Gangsters)

http://dji.retroroms.info/ - "Wiki"

https://github.com/fvantienen/dji_rev - This repository contains tools for reverse engineering DJI product firmware images.

https://github.com/Bin4ry/deejayeye-modder - APK "tweaks" for settings & "mods" for additional / altered functionality

https://github.com/hdnes/pyduml - Assistant-less firmware pushes and DUMLHacks referred to as DUMBHerring when used with "fireworks.tar" from RedHerring. DJI silently changes Assistant? great... we will just stop using it.

https://github.com/MAVProxyUser/P0VsRedHerring - RedHerring, aka "July 4th Independence Day exploit", "FTPD directory transversal 0day", etc. (Requires Assistant). We all needed a public root exploit... why not burn some 0day?

https://github.com/MAVProxyUser/dji_system.bin - Current Archive of dji_system.bin files that compose firmware updates referenced by MD5 sum. These can be used to upgrade and downgrade, and root your I2, P4, Mavic, Spark, Goggles, and Mavic RC to your hearts content. (Use with pyduml or DUMLDore)

https://github.com/MAVProxyUser/firm_cache - Extracted contents of dji_system.bin, in the future will be used to mix and match pieces of firmware for custom upgrade files. This repo was previously private... it is now open.

https://github.com/MAVProxyUser/DUMLrub - Ruby port of PyDUML, and firmware cherry picking tool. Allows rolling of custom firmware images.

https://github.com/jezzab/DUMLdore - Even windows users need some love, so DUMLDore was created to help archive, and flash dji_system.bin files on windows platforms.

https://github.com/MAVProxyUser/DJI_ftpd_aes_unscramble - DJI has modified the GPL Busybox ftpd on Mavic, Spark, & Inspire 2 to include AES scrambling of downloaded files... this tool will reverse the scrambling

https://github.com/darksimpson/jdjitools - Java DJI Tools, a collection of various tools/snippets tied in one CLI shell-like application.
