#!/bin/bash
command -v dialog >/dev/null 2>&1 || { echo "I require dialog but it's not installed.  Aborting." >&2; err=1; }
command -v bspatch >/dev/null 2>&1 || { echo "I require bspatch but it's not installed.  Aborting." >&2; err=1; }
command -v patch >/dev/null 2>&1 || { echo "I require patch but it's not installed.  Aborting." >&2; err=1; }
command -v dos2unix >/dev/null 2>&1 || { echo "I require dos2unix but it's not installed.  Aborting." >&2; err=1; }

if [ ! -f tools/apktool.jar ] 
then
echo "apktool.jar not found, run download_tools.sh!"
err=1
fi
if [ ! -f tools/apksigner/apksigner.jar ] 
then
echo "apksigner.jar not found, run download_tools.sh!"
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

echo "Smali patcher version: $ver" > $outdir/lastbuild-cfg.txt
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
options=()
i=1
cmd=(dialog --separate-output --checklist "Select patches for APK Version: $apkver-$apkvcode" 22 76 16)
for file in "patches/$apkver-$apkvcode/"*.patch; do
	filename=$(basename "$file")
	extension="${filename##*.}"
	filename="${filename%.*}"
#	echo "$i $filename"
	options+=($i "$filename" on)
	((i++))
done
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

cd decompile_out
for choice in $choices
do
	let sel=$choice-1
	let sel=$sel*3
	let sel=$sel+1
	patch=${options[$sel]}
	dos2unix ../patches/$apkver-$apkvcode/$patch.patch
	patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/$patch.patch
	if [ "$patch" == "removeOnlinefunction" ]
	then
			bspatch lib/armeabi-v7a/libSDKRelativeJNI.so lib/armeabi-v7a/libSDKRelativeJNI-n.so ../patches/$apkver-$apkvcode/so.bspatch
			rm lib/armeabi-v7a/libSDKRelativeJNI.so
			mv lib/armeabi-v7a/libSDKRelativeJNI-n.so lib/armeabi-v7a/libSDKRelativeJNI.so
	fi
	
	echo "$patch" >> ../$outdir/lastbuild-cfg.txt
done

dos2unix ../patches/$apkver-$apkvcode/origin
if [ -f ../patches/$apkver-$apkvcode/so2.bspatch ] 
then
bspatch lib/armeabi-v7a/libFREncrypt.so lib/armeabi-v7a/libFREncrypt-n.so ../patches/$apkver-$apkvcode/so2.bspatch
rm lib/armeabi-v7a/libFREncrypt.so
mv lib/armeabi-v7a/libFREncrypt-n.so lib/armeabi-v7a/libFREncrypt.so
fi
patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/origin
cd ..
echo =======================
echo Done patching
echo Rebuilding apk
java -jar tools/apktool.jar b -o $outdir/mod.apk decompile_out
echo Signing with testkey
java -jar tools/apksigner/apksigner.jar sign --key tools/apksigner/testkey.pk8 --cert tools/apksigner/testkey.x509.pem $outdir/mod.apk
rm -f $outdir/mod-$ver.apk
mv $outdir/mod.apk $outdir/mod-$ver.apk
echo Done signing
md5sum $outdir/mod-$ver.apk > $outdir/lastbuild-md5.txt
echo Removing decompile_out folder
rm -rf decompile_out
echo Have fun and stay safe!