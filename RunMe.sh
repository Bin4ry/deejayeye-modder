#!/bin/bash
command -v dialog >/dev/null 2>&1 || { echo "I require dialog but it's not installed.  Aborting." >&2; err=1; }
command -v bspatch >/dev/null 2>&1 || { echo "I require bspatch but it's not installed.  Aborting." >&2; err=1; }
command -v patch >/dev/null 2>&1 || { echo "I require patch but it's not installed.  Aborting." >&2; err=1; }

if [ ! -f tools/apktool.jar ] 
then
echo "apktool.jar not found, run download_tools.sh!"
err=1
fi
if [ ! -f tools/sign.jar ] 
then
echo "Sign.jar not found, run download_tools.sh!"
err=1
fi

if [ $err == 1 ]
then
exit 1
fi

ver=`cat version.txt`
mkdir out
if [ -e out/lastbuild-cfg.txt ]
then
rm out/lastbuild-cfg.txt
fi
if [ -e out/lastbuild-md5.txt ]
then
rm out/lastbuild-md5.txt
fi

echo "Smali patcher version: $ver" >> out/lastbuild-cfg.txt
clear
echo Welcome to the smali patcher version: $ver
while true; do
if [ -e PutApkHere/orig.apk ]
then
break
else
echo Original App not found! Please put the original file into the "PutApkHere" folder and name it orig.apk
read -p "Press any key to continue... "
fi
done
 
echo Decompiling original apk
java -jar tools/apktool.jar d -f -o decompile_out PutApkHere/orig.apk
echo done
cd decompile_out
apkver=`cat apktool.yml | grep versionName: | awk '{print $2}'`
apkvcode=`cat apktool.yml | grep versionCode: | awk '{print $2}'`
eval apkvcode=$apkvcode
cd ..
echo "APK Version: $apkver-$apkvcode" >> out/lastbuild-cfg.txt
echo " " >> out/lastbuild-cfg.txt
#echo "$apkver-$apkvcode"
if [ ! -d "patches/$apkver-$apkvcode" ] 
then
echo "Incompatible apk version!"
echo "ApkVersion: $apkver"
echo "ApkVersionCode: $apkvcode"
echo "Please take a look into the patches folder to see supported versions!"
read -p ""
echo "Removing decompile_out folder"
rm -rf decompile_out
echo "Exiting now"
exit 3
fi
echo "Active patches: " >> out/lastbuild-cfg.txt
if [ "$apkver" == "4.1.3" ]
then
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "force FCC patch" on
         2 "remove forced Updates from DJI Go4" on
         3 "remove Firmware Upgrade check" on
		 4 "offline login (thx artu-ole)" on
		 5 "remove Onlinefunction [only use with offline login!] (thx err0r4o4)" on
		 6 "remove Google APIs (keep if you want to keep social)" on
		 7 "remove social networks (keep Google APIs too!)" on
		 8 "enable Mavic flight modes for Spark (thx djayeyeballs)" on 
		 9 "enable Wifi channel selection on Spark with OTG" on
		 10 "enable Cache control" on 
		 11 "enable P3 Series (remove SD or it will crash) (thx DKoro1)" off)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
fi

if [ "$apkver" == "4.1.4" ]
then
#mv decompile_out/smali/com/dji/k/a/a/b.smali decompile_out/smali/com/dji/k/a/a/b.bak
#python decrypt_strings.py decompile_out/smali/dji
#python decrypt_strings.py decompile_out/smali/com/dji
#python decrypt_strings.py decompile_out/smali_classes2/com/dji
#python decrypt_strings.py decompile_out/smali_classes3/dji
#python decrypt_strings.py decompile_out/smali_classes4/dji
#python decrypt_strings.py decompile_out/smali_classes5/dji
#python decrypt_strings.py decompile_out/smali_classes6/dji
#mv decompile_out/smali/com/dji/k/a/a/b.bak decompile_out/smali/com/dji/k/a/a/b.smali
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "force FCC patch" on
         2 "remove forced Updates from DJI Go4" on
         3 "remove Firmware Upgrade check" on
		 8 "enable Mavic flight modes for Spark (thx djayeyeballs)" on
 		 9 "enable Wifi channel selection on Spark with OTG" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
fi
 
for choice in $choices
do
    case $choice in
        1)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/forceFCC.patch
			cd ..
			echo "forceFCC" >> out/lastbuild-cfg.txt
            ;;
        2)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeUpdateForce.patch
			cd ..
			echo "removeUpdateForce" >> out/lastbuild-cfg.txt
            ;;
        3)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeFWUpgradeService.patch
			cd ..
			echo "removeFWUpgradeService" >> out/lastbuild-cfg.txt
            ;;
		4)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/offlineLogin.patch
			cd ..
			echo "offlineLogin" >> out/lastbuild-cfg.txt
            ;;
		5)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeOnlinefunction.patch
			bspatch lib/armeabi-v7a/libSDKRelativeJNI.so lib/armeabi-v7a/libSDKRelativeJNI-n.so ../patches/$apkver-$apkvcode/so.bspatch
			rm lib/armeabi-v7a/libSDKRelativeJNI.so
			mv lib/armeabi-v7a/libSDKRelativeJNI-n.so lib/armeabi-v7a/libSDKRelativeJNI.so
			cd ..
			echo "removeOnlinefunction" >> out/lastbuild-cfg.txt
            ;;	
		6)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeGoogleApis.patch
			cd ..
			echo "removeGoogleApis" >> out/lastbuild-cfg.txt
            ;;	
		7)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeSocial.patch
			cd ..
			echo "removeSocial" >> out/lastbuild-cfg.txt
            ;;	
		8)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableMavicFlightModesOnSpark.patch
			cd ..
			echo "enableMavicFlightModesOnSpark" >> out/lastbuild-cfg.txt
            ;;	
		9)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableSparkWifiChannelSelectOnOtg.patch
			cd ..
			echo "enableSparkWifiChannelSelectOnOtg" >> out/lastbuild-cfg.txt
            ;;	
		10)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableCacheControl.patch
			cd ..
			echo "enableCacheControl" >> out/lastbuild-cfg.txt
            ;;	
		11)
            cd decompile_out
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableP3series.patch
			cd ..
			echo "enableP3series" >> out/lastbuild-cfg.txt
            ;;	
    esac
done
cd decompile_out
patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/origin
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
md5sum out/mod-$ver.apk > lastbuild-md5.txt
echo Removing decompile_out folder
rm -rf decompile_out
echo Have fun and stay safe!