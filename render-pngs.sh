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

# If no colors given, add default color to array
if [ ${#ICON_COLORS[*]} -eq 0 ]; then
    ICON_COLORS[0]=$DEFAULT_COLOR
fi


#======================================
#   Loop through icon colors
#======================================
for color in ${ICON_COLORS[*]}; do

# Create dir with color name
    mkdir -p $color


# Trap copy
    trap "rm $SOURCE_TEMP; exit" INT TERM


# Make a temp copy of SOURCE
    cp $SOURCE $SOURCE_TEMP


# Change color of temp copy
    if [ ! ${#ICON_COLORS[*]} -eq 1 ] || [ ! ${ICON_COLORS[0]} = $DEFAULT_COLOR ]; then
        sed -i "s/$DEFAULT_COLOR/$color/" $SOURCE_TEMP
    fi


# Loop through index.txt & render png's
    while read i; do
        if [ -f $color/$i.png ]; then
            echo $color/$i.png exists.
        else
            echo
            echo Rendering $color/$i.png
            $INKSCAPE --export-id=$i \
                      --export-id-only \
                      --export-width=$SIZE \
                      --export-height=$SIZE \
                      --export-png=$color/$i.png $SOURCE_TEMP >/dev/null
        fi
    done < $INDEX


# Remove copy before next iteration or EXIT
    rm $SOURCE_TEMP

done
exit 0
