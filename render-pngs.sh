#! /bin/bash

#======================================
#   Global Variables
#======================================
INKSCAPE="/usr/bin/inkscape"
SOURCE="icons.svg"
SOURCE_TEMP="/tmp/icons.svg"
DEFAULT_COLOR="#4078c0"
INDEX="index.txt"


#======================================
#   User Input
#======================================
echo "Enter icon size (this is the width and height): "
read SIZE
echo "Enter 1 or more colors (space or tab separated): "
read -a ICON_COLORS


#======================================
#   Loop over icon colors
#======================================
for color in ${ICON_COLORS[*]}
do

# Create dir with color name
    if [ ! -d $color ] && [ ! -z "$ICON_COLORS" ]; then
        mkdir $color
    else
        mkdir $DEFAULT_COLOR
    fi


# Trap copy
    trap "rm $SOURCE_TEMP; exit" INT TERM


# Make a temp copy of SOURCE
    cp $SOURCE $SOURCE_TEMP


# Change color of temp copy
    if [ ! -z "ICON_COLORS" ]; then
        sed -i "s/$DEFAULT_COLOR/$color/" $SOURCE_TEMP
    fi


# Loop over SVG folder & render png's
    while read i; do
        i2=${i##*/}  i2=${i2%.*}

        if [ -f $color/$i2.png ]; then
                echo $color/$i2.png exists.
        else
            echo
            echo Rendering $color/$i2.png
            $INKSCAPE --export-id=$i \
                      --export-id-only \
                      --export-width=$SIZE \
                      --export-height=$SIZE \
                      --export-png=$color/$i2.png $SOURCE_TEMP >/dev/null
        fi
    done < $INDEX


# Remove copy before next iteration or EXIT
    rm $SOURCE_TEMP

done
exit 0
