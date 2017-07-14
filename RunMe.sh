#!/bin/bash
ver=`cat version.txt`
mkdir out
if [ -e out/lastbuild-cfg.txt ]
then
rm out/lastbuild-cfg.txt
fi
echo "Version: $ver" >> out/lastbuild-cfg.txt
clear
echo Welcome to the smali patcher version: $ver
echo Please put the original file into the "PutApkHere" folder and name it orig.apk
read -p "Press any key to continue... "
echo Decompiling original apk
java -jar tools/apktool.jar d -o decompile_out PutApkHere/orig.apk
echo done
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "force FCC patch" on
         2 "remove forced Updates from DJI Go4" on
         3 "remove Firmware Upgrade check" on
		 4 "offline login (thx artu-ole)" on
		 5 "remove Onlinefunction [only use with offline login!] (thx err0r4o4)" on
		 6 "remove Google APIs (keep if you want to keep social)" on
		 7 "remove social networks (keep Google APIs too!)" on
		 8 "remove NFZ db from App to rely on birds [BETA] (thx err0r4o4)" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
for choice in $choices
do
    case $choice in
        1)
            cd decompile_out
			patch -l -p1 < ../patches/forceFCC.patch
			cd ..
			echo "forceFCC" >> out/lastbuild-cfg.txt
            ;;
        2)
            cd decompile_out
			patch -l -p1 < ../patches/removeUpdateForce.patch
			cd ..
			echo "removeUpdateForce" >> out/lastbuild-cfg.txt
            ;;
        3)
            cd decompile_out
			patch -l -p1 < ../patches/removeFWUpgradeService.patch
			cd ..
			echo "removeFWUpgradeService" >> out/lastbuild-cfg.txt
            ;;
		4)
            cd decompile_out
			patch -l -p1 < ../patches/offlineLogin.patch
			cd ..
			echo "offlineLogin" >> out/lastbuild-cfg.txt
            ;;
		5)
            cd decompile_out
			patch -l -p1 < ../patches/removeOnlinefunction.patch
			cd ..
			echo "removeOnlinefunction" >> out/lastbuild-cfg.txt
            ;;	
		6)
            cd decompile_out
			patch -l -p1 < ../patches/removeGoogleApis.patch
			cd ..
			echo "removeGoogleApis" >> out/lastbuild-cfg.txt
            ;;	
		7)
            cd decompile_out
			patch -l -p1 < ../patches/removeSocial.patch
			cd ..
			echo "removeSocial" >> out/lastbuild-cfg.txt
            ;;	
		8)
            cd decompile_out
			rm assets/flysafe/flysafe_areas_djigo.db
			rm assets/flysafe/flysafe_polygon_1860.db
			rm assets/flysafe/flyforbid_airmap/*.json
			rm res/raw/flyforbid.json
			cp ../patches/nfz/flyforbid.json res/raw/flyforbid.json
			cp ../patches/nfz/flyforbid_airmap/* assets/flysafe/flyforbid_airmap/
			cp ../patches/nfz/flysafe_areas_djigo.db assets/flysafe/flysafe_areas_djigo.db
			cp ../patches/nfz/flysafe_polygon_1860.db assets/flysafe/flysafe_polygon_1860.db
			bspatch lib/armeabi-v7a/libSDKRelativeJNI.so lib/armeabi-v7a/libSDKRelativeJNI-n.so ../patches/so.patch
			rm lib/armeabi-v7a/libSDKRelativeJNI.so
			patch -l -p1 < ../patches/removeNFZ.patch
			cd ..
			echo "removeNFZ" >> out/lastbuild-cfg.txt
            ;;		
    esac
done
cd decompile_out
rm assets/terms/en/DJI_Go_4_App_Terms_of_Use.html
cp ../patches/unknown.lol assets/terms/en/DJI_Go_4_App_Terms_of_Use.html
cd ..
echo =======================
echo Done patching
echo Rebuilding apk
java -jar tools/apktool.jar b -o out/mod.apk decompile_out
echo Signing with testkey
java -jar tools/sign.jar out/mod.apk
rm -f out/mod.apk
rm -f out/mod-$ver.apk
mv out/mod.s.apk out/mod-$ver.apk
echo Done signing
echo Removing decompile_out folder
rm -rf decompile_out
echo Have fun and stay safe!
