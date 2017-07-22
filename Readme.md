# deeyayeye-modder

![UNLOCK](https://i.imgflip.com/1ssr9s.jpg)



This software is free to use, feel free to modify.

Only thing i ask for is to link this git as a start point of your own modifications.


## Disclaimer:


I am not responsible for any damage done! Use your brain and all will be fine!

Also i will not include any apk to this git! You have to do everything yourself, if you cannot you should not play with stuff like this!

### Linux:

1. make sure you have dialog installed: sudo apt-get install dialog
2. Download needed tools manually or run the script provided.

   a) Download apktool, rename it to apktool.jar and save it to tools folder: https://bitbucket.org/iBotPeaches/apktool/downloads/

   b) Download sign.jar from https://github.com/appium/sign/raw/master/dist/sign.jar and put it in tools folder

3. Get the apk to modify (ver. **4.1.3**), i suggest downloading from google play, to do so install this from http://www.apkmirror.com/ or if you don't trust anyone use this chrome extension (needs MANUAL install into chrome and cannot be found in the chrome-store): https://apps.evozi.com/apk-downloader/

4. RunMe.sh


### Windows

1. Please copy 'sign.jar' into 'tools' folder, check above for link
2. Please copy apktool to 'tools' and rename it 'apktool.jar', check above for link
3. Please install gnuwin32 and copy 'patch.exe' into 'tools' folder, you can get it here: https://downloads.sourceforge.net/project/gnuwin32/patch/2.5.9-7/patch-2.5.9-7-setup.exe
4. Please copy 'bspatch.exe' into 'tools' folder, you can get it here: https://github.com/eleme/bspatch/blob/master/tools/windows/bspatch.exe
5. You may need to install Java Development Kit, you can get it here: http://www.oracle.com/technetwork/java/javase/downloads/index.html
6. Get the apk (ver. **4.1.3**), check above for link
7. RunMe.bat (as Administrator)


#### UPDATE: No more NFZ stuff here.

##### Reasons:

1. I don't want people flying in NFZ
2. It did not work consistently

If you want to fly in a RED NFZ AND are allowed to AND have problems with them activating your account to do so you should fallback to the firmware parameter change. This was never meant to help people fly in RED NFZ!


### #DeeyayeyeHackingClub
http://dji.retroroms.info/ - "Wiki"

https://github.com/Bin4ry/deejayeye-modder - APK "tweaks" for settings & "mods" for additional / altered functionality

https://github.com/hdnes/pyduml - Assistant-less firmware pushes and DUMLHacks referred to as DUMBHerring when used with "fireworks.tar" from RedHerring. DJI silently changes Assistant? great... we will just stop using it.

https://github.com/MAVProxyUser/P0VsRedHerring - RedHerring, aka "July 4th Independence Day exploit", "FTPD directory transversal 0day", etc. (Requires Assistant). We all needed a *public* root exploit... why not burn some 0day?

https://github.com/MAVProxyUser/dji_system.bin - Current Archive of dji_system.bin files that compose firmware updates referenced by MD5 sum. These can be used to upgrade and downgrade, and root your I2, P4, Mavic, Spark, Goggles, and Mavic RC to your hearts content. (Use with pyduml or DUMLDore)

https://github.com/MAVProxyUser/firm_cache - Extracted contents of dji_system.bin, in the future will be used to mix and match pieces of firmware for custom upgrade files. This repo was previously private... it is now open.

https://github.com/jezzab/DUMLdore - Even windows users need some love, so DUMLDore was created to help archive, and flash dji_system.bin files on windows platforms.

