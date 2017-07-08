#!/bin/bash
mkdir out
clear
echo Welcome to the smali patcher
echo Please put the original file into the "PutApkHere" folder and name it orig.apk
read -p "Press any key to continue... "
echo Decompiling original apk
java -jar tools/apktool.jar d -o decompile_out PutApkHere/orig.apk
echo done
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "force FCC patch" on
         2 "remove forced Updates from DJI Go4" on
         3 "remove Firmware Upgrade check" off
		 4 "offline login" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            cd decompile_out
			patch -l -p1 < ../patches/forceFCC.patch
			cd ..
            ;;
        2)
            cd decompile_out
			patch -l -p1 < ../patches/removeUpdateForce.patch
			cd ..
            ;;
        3)
            cd decompile_out
			patch -l -p1 < ../patches/removeFWUpgradeService.patch
			cd ..
            ;;
		4)
            cd decompile_out
			patch -l -p1 < ../patches/offlineLogin.patch
			cd ..
            ;;
    esac
done
echo =======================
echo Done patching
echo Rebuilding apk
java -jar tools/apktool.jar b -o out/mod.apk decompile_out
echo Signing with testkey
java -jar tools/sign.jar out/mod.apk
rm -f out/mod.apk
mv out/mod.s.apk out/mod.apk
echo Done signing
echo Removing decompile_out folder
rm -rf decompile_out
echo Have fun and stay safe!
