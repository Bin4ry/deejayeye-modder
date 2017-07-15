@echo off
REM Please copy 'sign.jar' into 'tools' folder
REM You can get it here: https://github.com/appium/sign/raw/master/dist/sign.jar
REM Please copy apktool to 'tools' and rename it 'apktool.jar'
REM You can get it here: https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.2.3.jar
REM Please install gnuwin32 and copy 'patch.exe' into 'tools' folder
REM You can get here: https://downloads.sourceforge.net/project/gnuwin32/patch/2.5.9-7/patch-2.5.9-7-setup.exe
REM Please copy 'bspatch.exe' into 'tools' folder
REM You can get here: https://github.com/eleme/bspatch/blob/master/tools/windows/bspatch.exe
REM apktool.jar CRC32 184A0735
REM bspatch.exe CRC32 0E267C90
REM patch.exe CRC32 13C89B7A
REM sign.jar CRC32 AD954C4B
REM orig.apk CRC32 9D8B27AC
cd /d %~dp0
set /p ver=<version.txt
set "winpatch=PutPatchesHere"
md out
md %winpatch%
echo "Welcome to the smali patcher version: %ver%"
echo "Please put the original file into the "PutApkHere" folder and name it orig.apk"
echo "and the patches to apply to the "PutPatchesHere" folder"
pause
echo "Decompiling original apk"
java -jar tools\apktool.jar d -o decompile_out PutApkHere\orig.apk
echo "done"
IF EXIST %winpatch%\so.patch (
	rename "%winpatch%\so.patch" so.bspatch
	)
for /f "tokens=*" %%f in ('dir /b %winpatch%\*.patch') do (
	echo "Converting %winpatch%\%%f"
	copy %winpatch%\%%f %winpatch%\%%f.copy
	del /f /q %winpatch%\%%f
	TYPE "%winpatch%\%%f.copy" | MORE /P > "%winpatch%\%%f"
	del /f /q %winpatch%\%%f.copy
	)
IF EXIST %winpatch%\removeOnlinefunction.patch (
	cd decompile_out
	echo "Applying so.patch"
	IF EXIST ..\%winpatch%\so.bspatch (
		..\tools\bspatch lib\armeabi-v7a\libSDKRelativeJNI.so lib\armeabi-v7a\libSDKRelativeJNI-n.so ..\%winpatch%\so.bspatch
		) ELSE (
		..\tools\bspatch lib\armeabi-v7a\libSDKRelativeJNI.so lib\armeabi-v7a\libSDKRelativeJNI-n.so ..\patches\so.patch
		)
	del /f /q "lib\armeabi-v7a\libSDKRelativeJNI.so"
	rename "lib\armeabi-v7a\libSDKRelativeJNI-n.so" libSDKRelativeJNI.so
	echo "Applying removeOnlinefunction.patch"
	..\tools\patch -l -s -p1 < ..\%winpatch%\removeOnlinefunction.patch
	rename "..\%winpatch%\removeOnlinefunction.patch" removeOnlinefunction.patch.done
	cd ..
	)
for /f "tokens=*" %%f in ('dir /b %winpatch%\*.patch') do (
	echo "Applying %%f"
	cd decompile_out
	..\tools\patch  -l -s -p1 < ..\%winpatch%\%%f
	cd ..
	)
IF EXIST %winpatch%\so.bspatch (
	rename "%winpatch%\so.bspatch" so.patch
	)
IF EXIST %winpatch%\removeOnlinefunction.patch.done (
	rename "%winpatch%\removeOnlinefunction.patch.done" removeOnlinefunction.patch
	)
cd decompile_out
del /f /q "assets\terms\en\DJI_Go_4_App_Terms_of_Use.html"
copy "..\patches\unknown.lol" "assets\terms\en\DJI_Go_4_App_Terms_of_Use.html"
cd ..
echo "======================="
echo "Done patching"
echo "Rebuilding apk"
java -jar tools\apktool.jar b -o out\mod.apk decompile_out
echo "Signing with testkey"
java -jar tools\sign.jar out\mod.apk
del /f /q out\mod.apk
IF EXIST out\mod-%ver%.apk (
	del /f /q out\mod-%ver%.apk
	)
move out\mod.s.apk out\mod-%ver%.apk
echo "Done signing"
echo "Removing decompile_out folder"
rd /S /Q decompile_out
echo "Have fun and stay safe!"
pause