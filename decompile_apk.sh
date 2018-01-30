#!/bin/bash
#
# Part of original RunMe.sh script that handles decompiling the apk found
# in subdirectory PutApkHere
#
# script is modified to take 2 arguments
#
# First argument  : name of the apk from ./PutApkHere/ subdirectory e.g. orig.apk
# Second argument : name of the output directory e.g. decompile_out
# Third argument  : timestamp for generating the logs with autogeneration if empty

# Check if we are running an OSX or Linux system
if [ $(uname) = "Linux" ]
then
    SYSTEMTYPE=LINUX
else
    SYSTEMTYPE=OSX
fi

if [ ! -f tools/apktool.jar ] 
then
echo "apktool.jar not found, run download_tools.sh!"
exit 1
fi

ver=`cat version.txt`
outdir="__MODDED_APK_OUT__"
mkdir -p $outdir

if [ "$3" = "" ]
then
	timestamp=$(date -u +"%Y-%M-%dT%R:%S")
else
	timestamp=$3
fi

log_file="$outdir/log-cfg-$timestamp.txt"

while true; do
if [ -e PutApkHere/$1 ]
then
break
else
echo "PutApkHere/$1 not found! Please put the $1 file into the \"PutApkHere\" folder"
read -p "Press any key to continue... "
fi
done

if [ -e $2 ]
then
echo "Output directory $2 already exist. Now you have to make a choice.

(1) delete existing directory and overwrite
(2) skip decompilation script
"
if [ $SYSTEMTYPE = OSX ]
then
	read -n 1 -p "Enter your choice : " overwrite_choice
else
	read -N 1 -p "Enter your choice : " overwrite_choice
fi
echo ""
else
overwrite_choice="1"
fi

case $overwrite_choice in
	"1")
	echo "removing $2 and decompiling PutApkHere/$1 in subdirectory $2
"
	java -jar tools/apktool.jar d -f -o $2 PutApkHere/$1



	;;
	*)
	echo "exiting to let you make a new call with new arguments
"
	exit 1
	;;
esac

echo "deejayeye-modder version $ver" >> $log_file
echo "    Command decompile_apk.sh $1 $2 $timestamp" >> $log_file
echo "    Decompiling PutApkHere/$1 into $2" >> $log_file

echo done "decompiling PutApkHere/$1 in subdirectory $2
"

