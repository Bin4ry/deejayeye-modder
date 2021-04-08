@echo off
if not exist tools mkdir tools
java -jar download.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.2.4.jar apktool.jar
java -jar download.jar https://github.com/jingle1267/BSPatch/raw/master/test/bsdiff4.3-win32/bspatch.exe bspatch.exe
java -jar download.jar https://sourceforge.net/projects/gnuwin32/files/patch/2.5.9-7/patch-2.5.9-7-bin.zip/download patch.zip
move tools\unzip\bin\patch.exe tools\patch.exe
del /q tools\patch.zip
rmdir /s /q tools\unzip
