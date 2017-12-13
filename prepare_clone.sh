#!/bin/bash
#
# Prepare the app for cloning before repacking it. This will allow to install
# several versions in parallel on the same device
#
# Changing the package name from dji.go.v4 to new name will have side effects.
# List of know side effects :
#
# HereMap API keys is no longuer valid and the cloned app will switch to
# GoogleMap (if a valid Google Map API key has been provided as thirs argument)
#
# Script Arguments :
#
# First arg  : directory of the "decompile-out" to be prepared
# Second arg : name of clone package e.g. dji.go.v5
#            : script has only been tested with package name of same length
#			 : (char count) as the original one (9 chars)
# Third arg  : Google Map API key matching testkey fingerprint AND package name
#              those key can be obtained at the following URL : https://console.developers.google.com
# Fourth arg : Package label name
#
# More specifically, the following URL will automatically trigger generating
# an API key for the newpackagename packahe (replace in URL) matching testkey used for signing modded app
#
# example URL : !!! substitute newpackagename before using !!!
#
# https://console.developers.google.com/flows/enableapi?apiid=maps_android_backend&keyType=CLIENT_SIDE_ANDROID&r=61:ED:37:7E:85:D3:86:A8:DF:EE:6B:86:4B:D8:5B:0B:FA:A5:AF:81;newpackagename&pli=1
#
#
#
# e.g. command example :
#
# ./prepare_cloning.sh ijd.og.v5 decompile_out "AIzaSyB-ICOGgAOCBopE5MdBDJXEkljD27pBSiJ" "IJD OG 4.1.14 modded"

substitution_regex_packagename="s/dji.go.v4/$2/g"
substitution_regex_googleapi="s/AIzaSyB-ICOGgAOCBopE5MdBDJXEkljD27pBSiI/$3/g"

newfbnumber=$(cat /dev/urandom | tr -dc '0-9' | fold -w 16 | head -n 1)
substitution_regex_facebook="s/FacebookContentProvider1820832821495825/FacebookContentProvider$newfbnumber/g"
new_package_label=$(echo "$4"|sed -e 's/ /\\x20/g')
substitution_regex_label="s/DJI\x20GO\x204/$new_package_label/g"

#replace dji.go.v4 by new package name in all files
find $1 -type f -exec sed -i $substitution_regex_packagename {} +

#Change specific parts in AndroidManifest.xml
#
#	Google MAp API V2 key
#	Facebook provider number
#	Application Label
#
sed -i $substitution_regex_googleapi $1/AndroidManifest.xml
sed -i $substitution_regex_facebook $1/AndroidManifest.xml
sed -i $substitution_regex_label $1/AndroidManifest.xml

