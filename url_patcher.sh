#!/bin/bash
#
# Patch the app for unwanted urls by replacing them by localhost address
# uses 2 files for fogged and clear urls found in the app
#
# For each of the 2 files, the last column is
# 0 if the url is not to be changed
# 1 if the url must be replaced 
#
# Script Arguments :
#
# First arg  : directory of the "decompile-out" to be prepared

subst_clear='"http://127.0.0.1"'
subst_clear_esc=$(echo $subst_clear|sed -e 's/[\/&]/\\&/g')
subst_fogged='"MV49Ml1xdlVrHWdySW53VQ=="'

echo "==================== Replacing url from fogged_urls.txt ======================="
echo "values marked with 1 (first column) in the file get replaced by"
echo "MV49Ml1xdlVrHWdySW53VQ== wich stands for http://127.0.0.1"
echo "==============================================================================="
echo ""

subst_str=""
out_dir=./__MODDED_APK_OUT__/urls/$1
first=0
while read line
do
	#tokens=( $(echo $line|tr '#' ' ') )
	tokens=( $(echo $line) )
	if [ ${tokens[0]} = 1 ]
	then
		url_fog=${tokens[2]}
		url_clear=${tokens[1]}
		echo "Replacing "$url_clear" by "$subst_clear" in fogged to fogged fashion"
		url_fog=$(echo $url_fog|sed -e 's/[\/&]/\\&/g')
		if [ $first = 0 ]
		then
			first=1
			subst_str=s/$url_fog/$subst_fogged/g
		else
			subst_str=$subst_str";"s/$url_fog/$subst_fogged/g
		fi
	fi
done <$out_dir/fogged_urls.txt

echo "=================== Replacing url from unfogged_urls.txt ======================"
echo "values marked with 1 (first column) in the file get replaced by http://127.0.0.1"
echo "==============================================================================="
echo ""
while read line
do
	tokens=( $(echo $line|tr ';' ' ') )
	if [ ${tokens[0]} = 1 ]
	then
		url_clear=${tokens[1]}
		echo "Replacing "$url_clear" by "$subst_clear" in clear to clear fashion"
		url_clear=$(echo $url_clear|sed -e 's/[\/&]/\\&/g')
		if [ $first = 0 ]
		then
			first=1
			subst_str=s/$url_clear/$subst_clear_esc/g
		else
			subst_str=$subst_str";"s/$url_clear/$subst_clear_esc/g
		fi
	fi
done <$out_dir/unfogged_urls.txt

echo ""
echo "==============================================================================="
echo "======== actual find and sed command execution... may take a while... ========="
echo "==============================================================================="

if [ ${#subst_str} -eq 0 ]
then
	echo "no url to patch"
else
	while read filename
	do
		echo "replacing in "$filename
		sed -i $subst_str $1/$filename
	done <$out_dir/files_with_urls.txt
fi

#echo $subst_str

