#!/bin/bash
#
# Part of original RunMe.sh script that handles patching the apk found
# in subdirectory PutApkHere that have been decompiled
#
# script is modified to take 2 arguments
#
# First argument  : name of the decompiled apk directory e.g. decompile_out
# Second argument : timestamp for generating the logs with autogeneration if empty

err=0

command -v dialog >/dev/null 2>&1 || { echo "I require dialog but it's not installed.  Aborting." >&2; err=1; }
command -v bspatch >/dev/null 2>&1 || { echo "I require bspatch but it's not installed.  Aborting." >&2; err=1; }
command -v patch >/dev/null 2>&1 || { echo "I require patch but it's not installed.  Aborting." >&2; err=1; }
command -v dos2unix >/dev/null 2>&1 || { echo "I require dos2unix but it's not installed.  Aborting." >&2; err=1; }

if [ $err = 1 ]
then
echo "Missing package"
exit 1
fi

ver=`cat version.txt`
outdir="__MODDED_APK_OUT__"
mkdir -p $outdir

if [ "$2" = "" ]
then
	timestamp=$(date -u +"%Y-%M-%dT%R:%S")
else
	timestamp=$2
fi

log_file="$outdir/log-cfg-${timestamp//:/_}.txt"

cd $1
apkver=`cat apktool.yml | grep versionName: | awk '{print $2}'`
apkvcode=`cat apktool.yml | grep versionCode: | awk '{print $2}'`
eval apkvcode=$apkvcode
cd ..

if [ ! -d "patches/$apkver-$apkvcode" ] 
then
	echo "Incompatible apk version!"
	echo "ApkVersion: $apkver"
	echo "ApkVersionCode: $apkvcode"
	echo "Please take a look into the patches folder to see supported versions!"
	read -p "Press a key"
	echo "Exiting now"
	exit 3
fi


options=()
i=1
cmd=(dialog --separate-output --checklist "Select patches for APK Version: $apkver-$apkvcode" 26 76 20)
for file in "patches/$apkver-$apkvcode/"*.patch; do
	filename=$(basename "$file")
	extension="${filename##*.}"
	filename="${filename%.*}"
	options+=($i "$filename" on)
	((i++))
done
choices=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

echo "deejayeye-modder version $ver" >> $log_file
echo "    Command patch_apk.sh $1 $timestamp" >> $log_file
echo "    ApkVersion     : $apkver" >> $log_file
echo "    ApkVersionCode : $apkvcode" >> $log_file
echo "    Active patches : " >> $log_file

cd $1
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
	
	echo "    $patch" >> ../$log_file
done

if [ -d ../patches/$apkver-$apkvcode/lang ]
then
cp -rf ../patches/$apkver-$apkvcode/lang/. res/
fi

dos2unix ../patches/$apkver-$apkvcode/origin
if [ -f ../patches/$apkver-$apkvcode/so2.bspatch ] 
then
bspatch lib/armeabi-v7a/libFREncrypt.so lib/armeabi-v7a/libFREncrypt-n.so ../patches/$apkver-$apkvcode/so2.bspatch
rm lib/armeabi-v7a/libFREncrypt.so
mv lib/armeabi-v7a/libFREncrypt-n.so lib/armeabi-v7a/libFREncrypt.so
fi
patch -l -p1 -N -r - < ../patches/$apkver-$apkvcode/origin
cd ..
echo "========================================"
echo "             Done patching              "
echo "========================================"

