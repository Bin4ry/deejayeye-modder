#!/bin/sh

# This script allow to change the modded application icon before repacking it
# It needs following packages installed
#
# packages imagemagick webp
# sudo apt-get install imagemagick webp
#
# First arg is the "decompile_out" directory to work into
# Second argument is the application icon to be used in PNG format 

err=0
command -v cwebp >/dev/null 2>&1 || { echo "I require cwebp (webp package) but it's not installed.  Aborting." >&2; err=1; }

if [ $err = 1 ]
then
echo "Missing package"
exit 1
fi

find $1 -name appicon*.png -exec cp $2 {} \;
find $1 -name appicon*.webp -exec cwebp $2 -o {} \;
