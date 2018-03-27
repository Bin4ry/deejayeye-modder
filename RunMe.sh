#!/bin/bash
#
#   New version of the RunMe.sh with a "modular" construction
#   Can take arguments or default to old behaviour
#   ApkName = orig.apk 
#   Decompile directory = decompile_out
#   Select and apply patches
#   No cloning
#   No icon color change
#   Rebuild and sign to mod-ver.apk
#   remove every "temporary" directory at the end of process
#
#   First argument  : name of apk file in PutApkHere subdirectory
#   Second argument : 

# Check if we are running an OSX or Linux system
if [ $(uname) = "Linux" ]
then
    echo "========================================"
    echo "   Running script on an Linux system    "
    echo "========================================"
    SYSTEMTYPE=LINUX
    DISPLAYCMD="display"
else
    echo "========================================"
    echo "    Running script on an OSX system     "
    echo "========================================"
    SYSTEMTYPE=OSX
    DISPLAYCMD="open -W"
    GOPT_VER=$(getopt --version)
    if [[ ! "$GOPT_VER" =~ "enhanced" ]]
    then
        echo "you need to use gnu-getopt to run this script correctly on OSX"
        echo "this can be done with following commands if brew/homebrew package system is installed"
        echo "brew install gnu-getopt"
        echo "brew link --force gnu-getopt"
        echo "additionnal information about brew/homebrew package system can be found at : https://brew.sh/index_fr.html"
        echo "========================================"
        echo 
        exit
    fi
fi

function usage() {
    echo "
RunMeNg : script for patching some application

arguments syntax and default values:
    
  -h or --help
      display this message

  -a name.apk or --apk-name=name.apk
      name of pk from PutApkHere directory
      [default = orig.apk]

  -w workdir or --work-directory=workdir
      name of working decompile directory
      [default=decompile_out]

  -o out.apk or --output-apk=out.apk
      name of the modded apk filename
      [default=mod-ver.apk]

  -k true/false or --keep-temp=true/false
      flag to keep modded working directory at end of script
      [default=false]

  -d true/false or --decompile-step=true/false
      flag to do the decompiling step
      [default=true]

  -p true/false or --patch-step=true/false
      flag do the smali patching step
      [default=true]

  -c true/false or --clone-step=true/false
      flag to do the cloning step
      [default=false]

  -i true/false or --iconmod-step=true/false
      flag to do the icon color change step
      [default=false]

  -I true/false or --iconrep-step=true/false
      flag to change the application icon
      [default=false]

  -r true/false or --repack-step=true/false
      flag to do the repacking and signing step
      [default=true]

  -t true/false or --timestamp=true/false
      flag to add a timestamp to output modded apk
      [default=false]

  -f true/false or --defog=true/false
      flag to defog all files after patching
      this process MIGHT provide app speedup but will take a while
      keep in mind that is changing almost all files
      so patches on workdir after using this option might not work
      [default=false]
    "
}

err=0

# Check if all required packages are installed before continuing.
command -v dialog >/dev/null 2>&1 || { echo "I require dialog but it's not installed.  Aborting." >&2; err=1; }
command -v bspatch >/dev/null 2>&1 || { echo "I require bspatch but it's not installed.  Aborting." >&2; err=1; }
command -v patch >/dev/null 2>&1 || { echo "I require patch but it's not installed.  Aborting." >&2; err=1; }
command -v dos2unix >/dev/null 2>&1 || { echo "I require dos2unix but it's not installed.  Aborting." >&2; err=1; }
command -v getopt >/dev/null 2>&1 || { echo "I require getopt but it's not installed.  Aborting." >&2; err=1; }
command -v convert >/dev/null 2>&1 || { echo "I require convert (imagemagick package) but it's not installed.  Aborting." >&2; err=1; }
command -v dwebp >/dev/null 2>&1 || { echo "I require dwebp (webp package) but it's not installed.  Aborting." >&2; err=1; }
command -v xmlstarlet >/dev/null 2>&1 || { echo "I require xmlstarlet (xmlstarlet package) but it's not installed.  Aborting." >&2; err=1; }

if [ $SYSTEMTYPE == LINUX ] ; then
    command -v display >/dev/null 2>&1 || { echo "I require display (imagemagick package) but it's not installed.  Aborting." >&2; err=1; }
fi

if [ $SYSTEMTYPE == OSX ] ; then
    command -v gsed >/dev/null 2>&1 || { echo "I require gsed (gnu-sed package) but it's not installed.  Aborting." >&2; err=1; }
fi

if [ $err = 1 ]
then
    echo "Missing package. See detailled message above."
    echo "on your system, missing packages can be installed with a command like : "
    if [ $SYSTEMTYPE == OSX ]
    then
        echo "brew install missing_package_name"
        echo "additionnal information about brew/homebrew package system can be found at : https://brew.sh/index_fr.html"
    else
        echo "sudo apt-get install missing_package_name"
        echo "or"
        echo "sudo yum install missing_package_name"
        echo "or other command depending on your linux distribution and settingsÒ"
    fi
    exit 1
fi

# Read all script arguments
SPLIT_ARG_TEMP=`getopt -o ha:w:o:k:d:p:c:i:I:r:t:f: --longoptions help,apkname:,work-directory:,output-apk:,keep-temp:,decompile-step:,patch-step:,clone-step:,iconmod-step:,iconrep-step:,repack-step:,timestamp:,defog: -u -n 'RunMeNg.sh' -- "$@"`
# If an argument cannot be identified, stop the script with error status
if [ $? != 0 ] ; then echo "Problem while parsing arguments with getopt... terminating..." >&2 ; exit 1 ; fi
#  otherwise, let's go
eval set -- "$SPLIT_ARG_TEMP"

# Default selected options for output APK creation
keep_temp="false"
decompile_step="true"
patch_step="true"
clone_step="false"
iconmod_step="false"
iconrep_step="false"
repack_step="true"
add_timestamp="false"
source_defog="false"

# Init script internal variables
ver=`cat version.txt`
workdir="decompile_out"
config_file="Settings.xml"
outdir="__MODDED_APK_OUT__"
timestamp=$(date -u +"%Y-%m-%dT%R:%S")
log_file="$outdir/log-cfg-${timestamp//:/_}.txt"

# Init settings from config file Settings.xml
apkname="$( xmlstarlet sel -t -v '/config/apkname' "$config_file" )"
if [ "$apkname" = "" ] ; then apkname="orig.apk"; fi
moddedapkname="$( xmlstarlet sel -t -v '/config/moddedapkname' "$config_file" )"
if [ "$moddedapkname" = "" ] ; then moddedapkname="mod.apk"; fi
newapplabel="$( xmlstarlet sel -t -v '/config/newapplabel' "$config_file" )"
googleapikey="$( xmlstarlet sel -t -v '/config/googleapikey' "$config_file" )"
newpackagename="$( xmlstarlet sel -t -v '/config/newpackagename' "$config_file" )"

# Extract all script arguments from command line
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
        -I | --iconrep-step )
            iconrep_step="$2"
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
        -f | --defog )
            source_defog="$2"
            shift 2
            ;;
        * )
            break
            ;;
    esac
done

# Reformat script arguments (in lower case)
decompile_step=$(echo $decompile_step | tr '[:upper:]' '[:lower:]')
patch_step=$(echo $patch_step | tr '[:upper:]' '[:lower:]')
clone_step=$(echo $clone_step | tr '[:upper:]' '[:lower:]')
repack_step=$(echo $repack_step | tr '[:upper:]' '[:lower:]')
keep_temp=$(echo $keep_temp | tr '[:upper:]' '[:lower:]')
add_timestamp=$(echo $add_timestamp | tr '[:upper:]' '[:lower:]')
iconrep_step=$(echo $iconrep_step | tr '[:upper:]' '[:lower:]')
iconmod_step=$(echo $iconmod_step | tr '[:upper:]' '[:lower:]')
source_defog=$(echo $source_defog | tr '[:upper:]' '[:lower:]')

# Create outdir
mkdir $outdir &> /dev/null

# Create the log file
touch $log_file

apkbasename=$(basename "$moddedapkname")
apkbasename="${apkbasename%.*}"
# Set the name of the output APK package 
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
message=$message"Do IconRep Step        : $iconrep_step\\n"
message=$message"Do Repack Step         : $repack_step\\n"
message=$message"Do Source Defog        : $source_defog\\n"
message=$message"Add Timestamp          : $add_timestamp\\n"
message=$message"\\n"
message=$message"TimeStamp value        : $timestamp\\n"
message=$message"\\n"

printf '%b\n' "$message"
echo "Do you agree with steps above ?"
echo ""
if [ "$SYSTEMTYPE" = OSX ] ; then
    read -p "Agree (y/n) ? " -n 1 test_continue
else
    read -p "Agree (y/n) ? " -N 1 test_continue
fi
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
    if [ "$newpackagename" = "" ]
    then
        echo "Enter new package name (e.g. \"jdi.og.v4\")"
        read -r -p "New package name : " newpackagename
    else
        echo "Use provided package name :" $newpackagename
    fi
    echo ""
    if [ "$googleapikey" = "" ]
    then
        echo "Enter Google Map V2 API key :"
        echo "you can get one for the selected $newpackagename at following URL (right click to open link) :"
        echo "https://console.developers.google.com/flows/enableapi?apiid=maps_android_backend&keyType=CLIENT_SIDE_ANDROID&r=61:ED:37:7E:85:D3:86:A8:DF:EE:6B:86:4B:D8:5B:0B:FA:A5:AF:81;$newpackagename&pli=1"
        echo ""
        read -r -p "Google API key : " googleapikey
    else
        echo "Use provided Google API Key :" $googleapikey
    fi
    echo ""
    if [ "$newapplabel" = "" ]
    then
        echo "Enter the friendly name of clone application label (e.g. \"IDJ OG 4.x mod\")"
        read -r -p "Application friendly label : " newapplabel
    else
        echo "Use provided Application label :" $newapplabel
    fi
    echo ""
    ./prepare_clone.sh "$workdir" "$newpackagename" "$googleapikey" "$newapplabel"
fi

# Replace the application icon by the provided one. 
# If an invalid path or no path is enter, the original APK icon is used instead of.
if [ "$iconrep_step" = "true" ] || [ "$iconrep_step" = "y" ] || [ "$iconrep_step" = "1" ]
then
    # Check if a new icon path has been specified in the settings file.
    iconpath="$( xmlstarlet sel -t -v '/config/iconpath' "$config_file" )"
    while true; do
        # If no icon has been specified, allow user to select one.
        if [ "$iconpath" = "" ]
        then
            echo "Select new application icon"
            echo "Prefered Image format : PNG @ 152 x 152"
            echo ""
            echo "Press enter to use default APK icon or"
            read -r -p "Enter new icon path : " iconpath
            # If an empty path has been entered, use the default application icon.
            if [ "$iconpath" = "" ] ; then iconpath="$workdir/res/drawable/appicon40.png"; fi
        else
            echo "Use provided logo :" $iconpath
        fi
        # Does the path to the icon file valid?
        if [ -f $iconpath ]
        then
            echo ""
            echo "A window with image should open, when ready close it and choose to keep or select a new icon"
            display $iconpath
            echo ""
            if [ "$SYSTEMTYPE" = OSX ] ; then
                read -p "Keep this icon (y/n) ? " -n 1 iconok
            else
                read -p "Keep this icon (y/n) ? " -N 1 iconok
            fi
            echo ""
            iconok=$(echo $iconok | tr '[:upper:]' '[:lower:]')
            if [ "$iconok" == "y" ] ; then break; fi
        else
            echo "Invalid path: $iconpath. Please retry"
            echo ""
        fi
        iconpath=""
    done

    # Change the APK icon by the new one.
    ./change_appicons.sh $workdir $iconpath
    echo ""
fi

if [ "$iconmod_step" = "true" ] || [ "$iconmod_step" = "y" ] || [ "$iconmod_step" = "1" ]
then
    # If no icon has been specified, used the default application icon.
    if [ "$iconpath" = "" ] ; then iconpath="$workdir/res/drawable/appicon40.png"; fi
    # Check if a new icon color has been specified in the settings file.    
    hue_shift="$( xmlstarlet sel -t -v '/config/hue_shift' "$config_file" )"
    # Create unique temporary file.
    unique_rnd=$RANDOM$RANDOM$RANDOM
    cp $iconpath /tmp/test-$unique_rnd.png
    while true; do
        # If no icon color has been specified, allow user to select one.
        if [ "$hue_shift" = "" ]
            then
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
            echo "on OSX you have to close the windows with cmd+Q to return to script execution"
            convert /tmp/test-$unique_rnd.png -modulate 100,100,$hue_shift /tmp/test-$unique_rnd-out.png
            $DISPLAYCMD /tmp/test-$unique_rnd-out.png
            echo ""
            if [ "$SYSTEMTYPE" = OSX ] ; then
                read -p "Keep this color or try a new one (y/n) ? " -n 1 colorok
            else
                read -p "Keep this color or try a new one (y/n) ? " -N 1 colorok
            fi
            echo ""
            colorok=$(echo $colorok | tr '[:upper:]' '[:lower:]')
            if [ "$colorok" == "y" ] ; then break; fi
        else
            echo "Use provided color :" $hue_shift
            echo ""
            break
        fi
    done
    # Remove temporary files.
    rm -f /tmp/test-$unique_rnd.png
    rm -f /tmp/test-$unique_rnd-out.png
    # Apply new color to the application icon.
    ./change_appicons_color.sh $workdir $hue_shift
    echo ""
fi

if [ "$source_defog" = "true" ] || [ "$source_defog" = "y" ] || [ "$source_defog" = "1" ]
then
    echo "Source defog"
    # TODO: add key detection
    python defog_strings_ng.py 2 $workdir
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
