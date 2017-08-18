# deejayeye-modder

![UNLOCK](https://i.imgflip.com/1ssr9s.jpg)

![UDONTSAY](https://image.ibb.co/e4bWLQ/dji_statement.png)

![BRINGIT](https://gifyu.com/images/bringit.gif)

This software is free to use, feel free to modify.

Only thing i ask for is to link this git as a start point of your own modifications.


## Disclaimer:


I am not responsible for any damage done! Use your brain and all will be fine!

Also i will not include any apk to this git! You have to do everything yourself, if you cannot you should not play with stuff like this!

## App version 4.1.4

App version 4.1.4 is still work in progress. I would personally recommend using 4.1.3, anyway if you want to use 4.1.4 you can but it has not all patches yet AND the CC check dialog is gone and will not come back (still the fcc patch code is present and working [Spark RC 300FW seems to cause problems but SparkRC 100FW works!])

## FCC 

If you get a message about different region etc. etc after using the FCC patch: YOU HAVE TO CLICK OK! 

## HowTo:

### Linux:

1. make sure you have dialog installed: sudo apt-get install dialog
2. Download needed tools manually or run the script provided.

   a) Download apktool, rename it to apktool.jar and save it to tools folder: https://bitbucket.org/iBotPeaches/apktool/downloads/

   b) Download sign.jar from https://github.com/appium/sign/raw/master/dist/sign.jar and put it in tools folder

3. Get the apk to modify (ver. **4.1.3**), try 'Raccoon, the apk downloader' (Linux/OSX/Windows), you can get it here: http://raccoon.onyxbits.de/, or try a mirror such as http://www.apkmirror.com/, or if you don't trust anyone use this chrome extension (needs MANUAL install into chrome and cannot be found in the chrome-store): https://apps.evozi.com/apk-downloader/

4. RunMe.sh


### Windows

1. Please copy 'sign.jar' into 'tools' folder, check above for link (if the 'tools' folder doesn't exist, simply create at the same level as the 'PutApkHere' folder)
2. Please copy apktool to 'tools' and rename it 'apktool.jar', check above for link
3. Please install gnuwin32 and copy 'patch.exe' into 'tools' folder, you can get it here: https://downloads.sourceforge.net/project/gnuwin32/patch/2.5.9-7/patch-2.5.9-7-setup.exe
4. Please copy 'bspatch.exe' into 'tools' folder, you can get it here: https://github.com/eleme/bspatch/blob/master/tools/windows/bspatch.exe
5. You may need to install Java Development Kit, you can get it here: http://www.oracle.com/technetwork/java/javase/downloads/index.html
6. Get the apk (ver. **4.1.3**), check above for link
7. RunMe.bat (as Administrator)


### Windows Patcher

1. Follow the instructions for installing java and gnuwin32 above.
2. Install .Net Framework 4.6.2 if you don't have it: https://www.microsoft.com/en-us/download/details.aspx?id=53344
3. Unzip PatchAPK.zip to a directory with no spaces, something like C:\DJIHacks will do.
4. Add the tools path to your system environment PATH variable. So add C:\DJIHacks\PatchAPK\tools
5. Rename the original apk you are going to decompile to something without any spaces like DJIGO-413.apk
6. Launch the app by double clicking PatchAPK.exe
7. Select file, and find your renamed apk
8. Select file, and choose the version of the apk you are patching
9. Click decompile, and wait until it finishes. apk will be decompiled to C:\DJIHacks\PatchAPK\decompile directory
10. Select the patches to apply, and click the Patch button. (The dry run checkbox is for testing the patches without applying them)
11. Click the build and sign button. Signed apk will be C:\DJIHacks\PatchAPK\decompile\dist\mod.apk
12. Enjoy!

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
