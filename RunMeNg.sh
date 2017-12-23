#!/bin/bash
#
#	New version of the RunMe.sh with a "modular" construction
#	Can take arguments or default to old behaviour
#	ApkName = orig.apk 
#	Decompile directory = decompile_out
#	Select and apply patches
#	No cloning
#	No icon color change
#	Rebuild and sign to mod-ver.apk
#	remove every "temporary" directory at the end of process
#
#	First argument  : name of apk file in PutApkHere subdirectory
#	Second argument : 

function usage() {
	echo "RunMeNg : script for patching some application"
	echo ""
	echo "arguments syntax and default values:"
	echo ""
	echo "-h or --help"
	echo "     display this message"
	echo ""
	echo "-a name.apk or --apk-name=name.apk"
	echo "     name of pk from PutApkHere directory"
	echo "     [default = orig.apk]"
	echo ""
	echo "-w workdir or --work-directory=workdir"
	echo "     name of working decompile directory"
	echo "     [default=decompile_out]"
	echo ""
	echo "-o out.apk or --output-apk=out.apk"
	echo "     name of the modded apk filename"
	echo "     [default=mod-ver.apk]"
	echo ""
	echo "-k true/false or --keep-temp=true/false"
	echo "     flag to keep modded working directory at end of script"
	echo "     [default=false]"
	echo ""
	echo "-d true/false or --decompile-step=true/false"
	echo "     flag to do the decompiling step"
	echo "     [default=true]"
	echo ""
	echo "-p true/false or --patch-step=true/false"
	echo "     flag do the smali patching step"
	echo "     [default=true]"
	echo ""
	echo "-c true/false or --clone-step=true/false"
	echo "     flag to do the cloning step"
	echo "     [default=false]"
	echo ""
	echo "-i true/false or --iconmod-step=true/false"
	echo "	   flag to do the icon color change step"
	echo "     [default=false]"
	echo ""
	echo "-r true/false or --repack-step=true/false"
	echo "     flag to do the repacking and signing step"
	echo "     [default=true]"
	echo ""
	echo "-t true/false or --timestamp=true/false"
	echo "     flag to add a timestamp to output modded apk"
	echo "     [default=false]"
	echo ""
#	echo "-u true/false or --user-interactive=true/false"
#	echo "     flag to select interactive mode (when applicable)"
#	echo "     [default=true]"
#	echo ""
}

command -v dialog >/dev/null 2>&1 || { echo "I require dialog but it's not installed.  Aborting." >&2; err=1; }
command -v bspatch >/dev/null 2>&1 || { echo "I require bspatch but it's not installed.  Aborting." >&2; err=1; }
command -v patch >/dev/null 2>&1 || { echo "I require patch but it's not installed.  Aborting." >&2; err=1; }
command -v dos2unix >/dev/null 2>&1 || { echo "I require dos2unix but it's not installed.  Aborting." >&2; err=1; }
command -v getopt >/dev/null 2>&1 || { echo "I require getopt but it's not installed.  Aborting." >&2; err=1; }
command -v convert >/dev/null 2>&1 || { echo "I require convert (imagemagick package) but it's not installed.  Aborting." >&2; err=1; }
command -v dwebp >/dev/null 2>&1 || { echo "I require dwebp (webp package) but it's not installed.  Aborting." >&2; err=1; }
command -v display >/dev/null 2>&1 || { echo "I require display (imagemagick package) but it's not installed.  Aborting." >&2; err=1; }

if [ $err = 1 ]
then
echo "Missing package. See detailled message above."
exit 1
fi

SPLIT_ARG_TEMP=`getopt -o ha:w:o:k:d:p:c:i:r:t: --longoptions help,apkname:,work-directory:,output-apk:,keep-temp:,decompile-step:,patch-step:,clone-step:,iconmod-step:,repack-step:,timestamp: -u -n 'RunMeNg.sh' -- "$@"`

if [ $? != 0 ] ; then echo "Problem while parsing arguments with getopt... terminating..." >&2 ; exit 1 ; fi

eval set -- "$SPLIT_ARG_TEMP"

apkname=orig.apk
workdir=decompile_out
moddedapkname=mod.apk
keep_temp="false"
decompile_step="true"
patch_step="true"
clone_step="false"
iconmod_step="false"
repack_step="true"
add_timestamp="false"

while true; do
	case "$1" in
		-h | --help )
			usage
			exit 1
			break;
			;;
		-a | --apkname )
			apkname="$2"
			shift 2
			;;
		-w | --work-directory )
			workdir="$2"
			shift 2
			;;
		-o | --output-apk )
			moddedapkname="$2"
			shift 2
			;;
		-k | --keep-temp )
			keep_temp="$2"
			shift 2
			;;
		-d | --decompile-step )
			decompile_step="$2"
			shift 2
			;;
		-p | --patch-step )
			patch_step="$2"
			shift 2
			;;
		-c | --clone-step )
			clone_step="$2"
			shift 2
			;;
		-i | --iconmod-step )
			iconmod_step="$2"
			shift 2
			;;
		-r | --repack-step )
			repack_step="$2"
			shift 2
			;;
		-t | --timestamp )
			add_timestamp="$2"
			shift 2
			;;
		* )
			break
			;;
	esac
done

decompile_step=$(echo $decompile_step | tr '[:upper:]' '[:lower:]')
patch_step=$(echo $patch_step | tr '[:upper:]' '[:lower:]')
clone_step=$(echo $clone_step | tr '[:upper:]' '[:lower:]')
repack_step=$(echo $repack_step | tr '[:upper:]' '[:lower:]')
keep_temp=$(echo $keep_temp | tr '[:upper:]' '[:lower:]')
add_timestamp=$(echo $add_timestamp | tr '[:upper:]' '[:lower:]')
iconmod_step=$(echo $iconmod_step | tr '[:upper:]' '[:lower:]')

ver=`cat version.txt`
outdir="__MODDED_APK_OUT__"

timestamp=$(date -u +"%Y-%M-%dT%R:%S")

log_file="$outdir/log-cfg-$timestamp.txt"

touch $log_file

apkbasename=$(basename "$moddedapkname")
apkbasename="${apkbasename%.*}"

if [ "$add_timestamp" = "true" ] || [ "$add_timestamp" = "0" ]
then
	moddedapkname="$apkbasename-v$ver-$timestamp.apk"
else
	moddedapkname="$apkbasename-v$ver.apk"
fi

message="\\n"
message=$message"========================================\\n"
message=$message"         Configuration Summary\\n"
message=$message"========================================\\n"
message=$message""
message=$message"Input Apk Name         : $apkname\\n"
message=$message"Working Directory      : $workdir\\n"
message=$message"Output Modded Apk Name : $moddedapkname\\n"
message=$message"Keep Work Dir          : $keep_temp\\n"
message=$message"Do Decompile Step      : $decompile_step\\n"
message=$message"Do Patch Step          : $patch_step\\n"
message=$message"Do Clone Step          : $clone_step\\n"
message=$message"Do IconMod Step        : $iconmod_step\\n"
message=$message"Do Repack Step         : $repack_step\\n"
message=$message"Add Timestamp          : $add_timestamp\\n"
message=$message"\\n"
message=$message"TimeStamp value        : $timestamp\\n"
message=$message"\\n"

printf '%b\n' "$message"
echo "Do you agree with steps above ?"
echo ""
read -p "Agree (y/n)" -N 1 test_continue
echo ""

test_continue=$(echo $test_continue | tr '[:upper:]' '[:lower:]')


if [ "$test_continue" = "y" ]
then
	printf '%b\n' "$message" >> $log_file
else
	echo "User stopped script"
	exit 1
fi

apkname=$(basename "$apkname")

if [ "$decompile_step" = "true" ] || [ "$decompile_step" = "y" ] || [ "$decompile_step" = "1" ]
then
	./decompile_apk.sh $apkname $workdir $timestamp
fi

if [ "$patch_step" = "true" ] || [ "$patch_step" = "y" ] || [ "$patch_step" = "1" ]
then
	./patch_apk.sh $workdir $timestamp
fi

if [ "$clone_step" = "true" ] || [ "$clone_step" = "y" ] || [ "$clone_step" = "1" ]
then
	echo "Enter new package name (e.g. jdi.og.v4) :"
	read -r -p "New package name : " newpackagename
	echo ""
	echo "Enter Google Map V2 API key :"
	echo "you can get one for the selected $newpackagename at following URL (right click to open link) :"
	echo "https://console.developers.google.com/flows/enableapi?apiid=maps_android_backend&keyType=CLIENT_SIDE_ANDROID&r=61:ED:37:7E:85:D3:86:A8:DF:EE:6B:86:4B:D8:5B:0B:FA:A5:AF:81;$newpackagename&pli=1"
	echo ""
	read -r -p "Google API key : " googleapikey
	echo ""
	echo "Enter the friendly name of clone application label (e.g. \"IDJ OG 4.x mod\")"
	echo ""
	read -r -p "Application friendly label name : " applabel
	echo ""
	./prepare_clone.sh "$workdir" "$newpackagename" "$googleapikey" "$applabel"
fi

if [ "$iconmod_step" = "true" ] || [ "$iconmod_step" = "y" ] || [ "$iconmod_step" = "1" ]
then
	unique_rnd=$RANDOM$RANDOM$RANDOM
	cp $workdir/res/drawable/appicon40.png /tmp/test-$unique_rnd.png
	while true; do
		echo "Choose a color shift (hue shift in HSV colorspace) for the app icon"
		echo "Value must be between 0 and 200"
		echo "100 will not change color"
		echo ""
		echo "0 and 200 are the same color (the HSV colorspace is cyclic)"
		echo "0 - 10 ~ orange"
		echo "15 - 20 ~ yellow"
		echo "25 - 65 ~ green"
		echo "70 - 85 ~ turquoise"
		echo "95 - 120 ~ blue (100 is nominal blue color)"
		echo "125 - 140 ~ violet"
		echo "145 - 170 ~ pink"
		echo "175 ~ 185 ~ red"
		echo "190 ~ 200 ~ orange"
		echo ""
		read -r -p "Enter value betwen 0 and 200 : " hue_shift
		echo ""
		echo "A window with image should open, when ready close it and choose to keep or try a new color value"
		convert /tmp/test-$unique_rnd.png -modulate 100,100,$hue_shift /tmp/test-$unique_rnd-out.png
		display /tmp/test-$unique_rnd-out.png
		echo ""
		read -p "Keep this color or try a new one (y/n) ? " colorok
		echo ""
		colorok=$(echo $colorok | tr '[:upper:]' '[:lower:]')
		if [ "$colorok" == "y" ]
		then
		break
		fi
	done
	rm -f /tmp/test-$unique_rnd.png
	rm -f /tmp/test-$unique_rnd-out.png
	./change_appicons_color.sh $workdir $hue_shift
fi

if [ "$repack_step" = "true" ] || [ "$repack_step" = "y" ] || [ "$repack_step" = "1" ]
then
	echo Rebuilding apk
	rm -rf $outdir/build
	java -jar tools/apktool.jar b -o $outdir/$moddedapkname $workdir
	echo Signing with testkey
	java -jar tools/apksigner/apksigner.jar sign --key tools/apksigner/testkey.pk8 --cert tools/apksigner/testkey.x509.pem $outdir/$moddedapkname
fi

if [ "$keep_temp" = "false" ] || [ "$keep_temp" = "n" ] || [ "$keep_temp" = "0" ]
then
	echo "Removing work directory $workdir"
	rm -rf $workdir
fi

