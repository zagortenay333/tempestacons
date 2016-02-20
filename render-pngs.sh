#! /bin/bash


#======================================
#   ANSI colors
#======================================
ansi_reset='\e[0m'
blue='\e[34m'
yellow_b='\e[1;33m'
red_b='\e[1;31m'


#======================================
#   Global Variables
#======================================
INKSCAPE="/usr/bin/inkscape"
SOURCE="icons.svg"
SOURCE_TEMP="/tmp/icons.svg"
DEFAULT_COLOR="#4078c0"
DEFAULT_SIZE=32
INDEX="index.txt"


#======================================
#   User Input
#======================================
echo "Enter icon size (skip for default icon dimensions): "
read -r SIZE
echo "Enter 1 or more colors (space or tab separated): "
read -r -a ICON_COLORS


# If no colors given, add default color to array
if [ -z "$SIZE" ]; then
    SIZE=$DEFAULT_SIZE
fi

# If no colors given, add default color to array
if [ ${#ICON_COLORS[*]} -eq 0 ]; then
    ICON_COLORS[0]=$DEFAULT_COLOR
fi


#======================================
#   Loop through icon colors
#======================================
for color in ${ICON_COLORS[*]}; do

    # Create dir with color & size in
    mkdir -p "$color--$SIZE"


    # Trap copy
    trap 'rm $SOURCE_TEMP; exit' INT TERM


    # Make a temp copy of SOURCE
    cp "$SOURCE" "$SOURCE_TEMP"


    # Change color of temp copy
    if [ ! ${#ICON_COLORS[*]} -eq 1 ] || [ ! ${ICON_COLORS[0]} = $DEFAULT_COLOR ]; then
        sed -i "s/$DEFAULT_COLOR/$color/" "$SOURCE_TEMP"
    fi


    # Loop through index.txt & render png's
    while read -r i; do
        if [ -f "$color--$SIZE/$i.png" ]; then
            echo -e "${red_b}$color--$SIZE/$i.png exists.${ansi_reset}"
        else
            echo
            echo -e "${blue}Rendering ${yellow_b}$color--$SIZE/$i.png${ansi_reset}"
            "$INKSCAPE" --export-id="$i" \
                        --export-id-only \
                        --export-width="$SIZE" --export-height="$SIZE" \
                        --export-png="$color--$SIZE/$i.png" "$SOURCE_TEMP" &> /dev/null
        fi
    done < "$INDEX"


    # Remove copy before next iteration or EXIT
    rm "$SOURCE_TEMP"

done
exit 0
