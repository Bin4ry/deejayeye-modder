@echo off
REM Please install GnuWin patch
REM You can get here: https://downloads.sourceforge.net/project/gnuwin32/patch/2.5.9-7/patch-2.5.9-7-setup.exe

set "folder=PutPatchesHere"
md out
md %folder%
echo "Welcome to the smali patcher"
echo "Please put the original file into the "PutApkHere" folder and name it orig.apk"
echo "and the patches to apply to the "PutPatchesHere" folder"
pause
echo "Decompiling original apk"
java -jar tools\apktool.jar d -o decompile_out PutApkHere\orig.apk
echo "done"
for /f "tokens=*" %%f in ('dir /b %folder%\*.patch') do (
	echo "Converting %folder%\%%f"
	copy %folder%\%%f %folder%\%%f.copy
	del /f /q %folder%\%%f
	TYPE "%folder%\%%f.copy" | MORE /P > "%folder%\%%f"
	del /f /q %folder%\%%f.copy
	)

IF EXIST %folder%\removeNFZ.patch (
	echo "removing NFZ..."
	cd decompile_out
	del /f /q "assets\flysafe\flysafe_areas_djigo.db"
	del /f /q "assets\flysafe\flyforbid_airmap\*.json"
	del /f /q "res\raw\flyforbid.json"
	del /f /q "lib\libSDKRelativeJNI.so"
	copy "..\patches\nfz\flyforbid.json" "res\raw\flyforbid.json"
	copy "..\patches\nfz\flyforbid_airmap\*.*" "assets\flysafe\flyforbid_airmap\"
	copy "..\patches\nfz\flysafe_areas_djigo.db" "assets\flysafe\flysafe_areas_djigo.db"
	copy "..\patches\libSDKRelativeJNI.so" "lib\libSDKRelativeJNI.so"
	patch -l -s -p1 < ..\%folder%\removeNFZ.patch
	rename "..\%folder%\removeNFZ.patch" removeNFZ.patch.done
	cd ..
)

for /f "tokens=*" %%f in ('dir /b %folder%\*.patch') do (
	echo "Applying %folder%\%%f"
	cd decompile_out
	patch  -l -s -p1 < ..\%folder%\%%f
	cd ..
	)
IF EXIST %folder%\removeNFZ.patch.done (
	rename "%folder%\removeNFZ.patch.done" removeNFZ.patch
	)
echo "======================="
echo "Done patching"
echo "Rebuilding apk"
java -jar tools\apktool.jar b -o out\mod.apk decompile_out
echo "Signing with testkey"
java -jar tools\sign.jar out\mod.apk
del /f /q out\mod.apk
move out\mod.s.apk out\mod-v9.apk
echo "Done signing"
echo "Removing decompile_out folder"
rd /S /Q decompile_out
echo "Have fun and stay safe!"
pause