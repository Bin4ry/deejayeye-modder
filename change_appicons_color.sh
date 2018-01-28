#!/bin/sh

# This script allow to change the color of the modded application icon before repacking it
# it needs following packages installed
#
# packages imagemagick webp
# sudo apt-get install imagemagick webp
#
# First arg is the "decompile_out" directory to look into
# Second argument is the hue shift value to apply, between 0 and 200
# 100 will not change color
# 0 and 200 are the same color (the HSV colorspace is cyclic)
# 0 - 10 ~ orange
# 15 - 20 ~ yellow
# 25 - 65 ~ green
# 70 - 85 ~ turquoise
# 95 - 120 ~ blue (100 is nominal blue color)
# 125 - 140 ~ violet
# 145 - 170 ~ pink
# 175 ~ 185 ~ red
# 190 ~ 200 ~ orange

#echo $1/appicon*
err=0
command -v convert >/dev/null 2>&1 || { echo "I require convert (imagemagick package) but it's not installed.  Aborting." >&2; err=1; }

if [ $err = 1 ]
then
echo "Missing package"
exit 1
fi

find $1 -name appicon* -exec convert {} -modulate 100,100,$2 {} \;

