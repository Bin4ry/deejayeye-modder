mkdir tools
java -jar download.jar https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.2.4.jar apktool.jar
java -jar download.jar https://github.com/jingle1267/BSPatch/raw/master/test/bsdiff4.3-win32/bspatch.exe bspatch.exe
java -jar download.jar https://sourceforge.mirrorservice.org/g/gn/gnuwin32/patch/2.5.9-7/patch-2.5.9-7-bin.zip patch.zip
move tools\unzip\bin\patch.exe tools\patch.exe
del /q tools\patch.zip
rmdir /s /q tools\unzip

