#!/bin/bash
#
# Script Arguments :
#
# First arg  : directory of the "decompile-out" to be prepared
str_http_fog="MV49"
str_http_clear="\"http"
out_dir=__MODDED_APK_OUT__/urls/$1
mkdir -p ./$out_dir/

unfogged_url_file=../$out_dir/unfogged_urls.txt
fogged_url_file=../$out_dir/fogged_urls.txt
files_with_urls=../$out_dir/files_with_urls.txt
tmp_fogged_urls_file=../$out_dir/tmp_fogged_urls.txt
tmp_unfogged_urls_file=../$out_dir/tmp_unfogged_urls.txt

declare -A listOfFilesWithUrl assoc
declare -A foggedUrlsList assoc
declare -A unfoggedUrlsList assoc

parse_fogged_url_files () {
while read line
do
	tokens=( $( echo $line ) )

	filename=${tokens[0]}
	if [[ $filename == *".smali" ]]
	then
		if ! [[ ${listOfFilesWithUrl[$filename]} ]]
		then
			listOfFilesWithUrl[$filename]=$filename
			echo "$filename" >> $files_with_urls
		fi

		for token in ${tokens[@]}
		do
			if [[ $token == *$str_http_fog* ]]
			then
				if ! [[ ${foggedUrlsList[$token]} ]]
				then
					defog=$( ../defog_one_string.py 2 "$token")
					foggedUrlsList[$token]=$defog
					echo -e "0\t\"$defog\"\t$token" >> $fogged_url_file
				fi
			fi
		done
	fi
done < $1
}

parse_unfogged_url_files () {
while read line
do
	tokens=( $( echo $line ) )

	filename=${tokens[0]}
	if [[ $filename == *".smali" ]]
	then
		if ! [[ ${listOfFilesWithUrl[$filename]} ]]
		then
			listOfFilesWithUrl[$filename]=$filename
			echo "$filename" >> $files_with_urls
		fi

		for token in ${tokens[@]}
		do
			if [[ $token == *$str_http_clear* ]]
			then
				if ! [[ ${unfoggedUrlsList[$token]} ]]
				then
					unfoggedUrlsList[$token]=$token
					echo -e "0\t$token" >> $unfogged_url_file
				fi
			fi
		done
	fi
done < $1
}

cd $1

if [ -e $unfogged_url_file ] || [ -e $fogged_url_file ] || [ -e $files_with_urls ]
then
	echo "File needs to be deleted manually before regenerating"
	exit 0
fi

rm -f $tmp_fogged_urls_file
rm -f $tmp_unfogged_urls_file


grep -T -r "\"MV49MhRk" >> $tmp_fogged_urls_file
grep -T -r "\"MV49Ml1x" >> $tmp_fogged_urls_file
grep -T -r "\"http://" >> $tmp_unfogged_urls_file
grep -T -r "\"https://" >> $tmp_unfogged_urls_file


parse_fogged_url_files $tmp_fogged_urls_file
parse_unfogged_url_files $tmp_unfogged_urls_file

echo "==============================================================================="
echo " generated files MUST be edited manually before applying url_patcher.sh        "
echo " LAN adresses must remain disabled as well as some others like http://         "
echo " or https://                                                                   "
echo " you are welcome to share you config files...                                  "
echo " files are in $out_dir                                                         "
echo " default config DO NOT DISABLE any url                                         "
echo "==============================================================================="
