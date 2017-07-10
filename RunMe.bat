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
	echo "Applying %folder%\%%f"
	cd decompile_out
	patch -l -s -p1 < ..\%folder%\%%f
	cd ..
	)
echo "======================="
echo "Done patching"
echo "Rebuilding apk"
java -jar tools\apktool.jar b -o out\mod.apk decompile_out
echo "Signing with testkey"
java -jar tools\sign.jar out\mod.apk
del /f /q out\mod.apk
move out\mod.s.apk out\mod-v8.apk
echo "Done signing"
echo "Removing decompile_out folder"
rd /S /Q decompile_out
echo "Have fun and stay safe!"
pause