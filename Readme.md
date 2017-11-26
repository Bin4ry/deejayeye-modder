# deejayeye-modder

![UNLOCK](https://i.imgflip.com/1ssr9s.jpg)

![UDONTSAY](https://image.ibb.co/e4bWLQ/dji_statement.png)

![BRINGIT](https://gifyu.com/images/bringit.gif)

This software is free to use, feel free to modify.

Only thing i ask for is to link this git as a start point of your own modifications.


## Disclaimer:


I am not responsible for any damage done! Use your brain and all will be fine!

Also i will not include any apk to this git! You have to do everything yourself, if you cannot you should not play with stuff like this!

IF you ONLY want FCC mode and nothing else, you might be better of with this (works on Android AND iOS):
https://dji.retroroms.info/howto/dji_configs


## Want to contribute or learn some stuff? 
Join our Slack (this is where the magic happens):
https://join.slack.com/t/dji-rev/shared_invite/enQtMjIzMTI1MDA5MDcyLWJmZjQwYjdjZGMzYmZhYzIwZTQ1M2ZmYTY1Y2ZhYjkzYTkwYThiMjNlYzQzN2M5NDA4MmQ3M2RkZGMzZTIyNTY

## What is the latest version to work?

Latest version which works with this patches is app version 4.1.14, since the original version is encrypted you need a special decrypted version. This version can be found online.
The filename is "go.v4_4.1.14-1027326-noSecNeo.apk" ONLY THIS VERSION is supported! 
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

4. RunMe.sh


### Windows

1. You may need to install Java Development Kit, you can get it here: http://www.oracle.com/technetwork/java/javase/downloads/index.html
2. Run the download_tools.bat file
3. Get the apk (look in the patches folder for supported versions), check above for link
4. RunMe.bat (as Administrator)


### Windows Patcher

![APKPATCH](http://i.imgur.com/43OgEOg.jpg)

1. Follow the instructions for installing java and gnuwin32 above.
2. Install .Net Framework 4.6.2 if you don't have it: https://www.microsoft.com/en-us/download/details.aspx?id=53344
3. Install all tools as mentioned above
4. Rename the original apk you are going to decompile to something without any spaces like DJeyeGO-413.apk
5. Launch the app by double clicking PatchAPK.exe
6. Select file, and find your renamed apk
7. Click decompile, and wait until it finishes. apk will be decompiled to "decompile" directory
8. Select the patches to apply, and click the Patch button. (The dry run checkbox is for testing the patches without applying them)
9. Click the build and sign button. Signed apk will be "decompile\dist\mod.apk"
10. Enjoy!

Need help? Check out the wiki: http://dji.retroroms.info/howto/deejayeye-modder

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
