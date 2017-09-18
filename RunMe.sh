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

if [ $err -eq 1 ]
then
exit 1
fi

ver=`cat version.txt`
outdir="__MODDED_APK_OUT__"
mkdir $outdir
if [ -e $outdir/lastbuild-cfg.txt ]
then
rm $outdir/lastbuild-cfg.txt
fi
if [ -e $outdir/lastbuild-md5.txt ]
then
rm $outdir/lastbuild-md5.txt
fi

echo "Smali patcher version: $ver" >> $outdir/lastbuild-cfg.txt
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
echo "APK Version: $apkver-$apkvcode" >> $outdir/lastbuild-cfg.txt
echo " " >> $outdir/lastbuild-cfg.txt
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
echo "Active patches: " >> $outdir/lastbuild-cfg.txt
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
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "force FCC patch" on
         2 "remove forced Updates from DJI Go4" on
         3 "remove Firmware Upgrade check" on
		 8 "enable Mavic flight modes for Spark (thx djayeyeballs)" on
 		 9 "enable Wifi channel selection on Spark with OTG" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
fi

if [ "$apkver" == "4.1.8" ]
then
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "force FCC patch" on
         2 "remove forced Updates from DJI Go4" on
         3 "remove Firmware Upgrade check" on
		 4 "remove login" on
		 5 "remove Onlinefunction [use with remove login!]\n\t (removes Social too)" on
		 8 "enable Mavic flight modes for Spark (thx djayeyeballs)" on
 		 9 "enable Wifi channel selection on Spark with OTG" on
		 10 "enable Cache control" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
fi

if [ "$apkver" == "4.1.9" ]
then
cmd=(dialog --separate-output --checklist "Select options:" 22 76 16)
options=(1 "force FCC patch" on
         2 "remove forced Updates from DJI Go4" on
         3 "remove Firmware Upgrade check" on
		 4 "remove login" on
		 8 "enable Mavic flight modes for Spark (thx djayeyeballs)" on
 		 9 "enable Wifi channel selection on Spark with OTG" on
		 10 "enable Cache control" on)
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
clear
fi

 
for choice in $choices
do
    case $choice in
        1)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/forceFCC.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/forceFCC.patch
			cd ..
			echo "forceFCC" >> $outdir/lastbuild-cfg.txt
            ;;
        2)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/removeUpdateForce.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeUpdateForce.patch
			cd ..
			echo "removeUpdateForce" >> $outdir/lastbuild-cfg.txt
            ;;
        3)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/removeFWUpgradeService.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeFWUpgradeService.patch
			cd ..
			echo "removeFWUpgradeService" >> $outdir/lastbuild-cfg.txt
            ;;
		4)
            cd decompile_out
			if [ "$apkver" == "4.1.8" ]
			then
				dos2unix ../patches/$apkver-$apkvcode/removeLogin.patch
				patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeLogin.patch
			else
				dos2unix ../patches/$apkver-$apkvcode/offlineLogin.patch
				patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/offlineLogin.patch
			fi
			cd ..
			echo "offlineLogin" >> $outdir/lastbuild-cfg.txt
            ;;
		5)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/removeOnlinefunction.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeOnlinefunction.patch
			bspatch lib/armeabi-v7a/libSDKRelativeJNI.so lib/armeabi-v7a/libSDKRelativeJNI-n.so ../patches/$apkver-$apkvcode/so.bspatch
			rm lib/armeabi-v7a/libSDKRelativeJNI.so
			mv lib/armeabi-v7a/libSDKRelativeJNI-n.so lib/armeabi-v7a/libSDKRelativeJNI.so
			cd ..
			echo "removeOnlinefunction" >> $outdir/lastbuild-cfg.txt
            ;;	
		6)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/removeGoogleApis.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeGoogleApis.patch
			cd ..
			echo "removeGoogleApis" >> $outdir/lastbuild-cfg.txt
            ;;	
		7)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/removeSocial.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/removeSocial.patch
			cd ..
			echo "removeSocial" >> $outdir/lastbuild-cfg.txt
            ;;	
		8)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/enableMavicFlightModesOnSpark.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableMavicFlightModesOnSpark.patch
			cd ..
			echo "enableMavicFlightModesOnSpark" >> $outdir/lastbuild-cfg.txt
            ;;	
		9)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/enableSparkWifiChannelSelectOnOtg.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableSparkWifiChannelSelectOnOtg.patch
			cd ..
			echo "enableSparkWifiChannelSelectOnOtg" >> $outdir/lastbuild-cfg.txt
            ;;	
		10)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/enableCacheControl.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableCacheControl.patch
			cd ..
			echo "enableCacheControl" >> $outdir/lastbuild-cfg.txt
            ;;	
		11)
            cd decompile_out
			dos2unix ../patches/$apkver-$apkvcode/enableP3series.patch
			patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/enableP3series.patch
			cd ..
			echo "enableP3series" >> $outdir/lastbuild-cfg.txt
            ;;
    esac
done
cd decompile_out
dos2unix ../patches/$apkver-$apkvcode/origin
patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/origin
cd ..
echo =======================
echo Done patching
echo Rebuilding apk
java -jar tools/apktool.jar b -o $outdir/mod.apk decompile_out
echo Signing with testkey
java -jar tools/sign.jar $outdir/mod.apk
rm -f $outdir/mod.apk
rm -f $outdir/mod-$ver.apk
mv $outdir/mod.s.apk $outdir/mod-$ver.apk
echo Done signing
md5sum $outdir/mod-$ver.apk > $outdir/lastbuild-md5.txt
echo Removing decompile_out folder
rm -rf decompile_out
echo Have fun and stay safe!