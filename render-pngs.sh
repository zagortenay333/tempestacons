#! /bin/bash

INKSCAPE="/usr/bin/inkscape"

#--------------------------------------------------

echo "Enter icon size (this is the width and height): "
read SIZE
echo "Enter icon-color (leave empty for default): "
read ICON_COLOR

#--------------------------------------------------

ICONS_DIR="PNG-"$SIZE
SOURCE="icons.svg"
DEFAULT_COLOR="#4078c0"

if [ -z "$ICON_COLOR" ]; then
    ICON_COLOR=$DEFAULT_COLOR
fi

#--------------------------------------------------

if [ ! -d $ICONS_DIR ]; then
    mkdir $ICONS_DIR
fi

#--------------------------------------------------

SOURCE_TEMP="/tmp/"$SOURCE

trap "rm $SOURCE_TEMP; exit" EXIT

cp $SOURCE $SOURCE_TEMP

sed -i "s/$DEFAULT_COLOR/$ICON_COLOR/" $SOURCE_TEMP

for i in `cat index.txt`
do
if [ -f $ICONS_DIR/$i.png ]; then
        echo $ICONS_DIR/$i.png exists.
else
    echo
    echo Rendering $ICONS_DIR/$i.png
    $INKSCAPE --export-id="$i" \
              --export-id-only \
              --export-width=$SIZE \
              --export-height=$SIZE \
              --export-png=$ICONS_DIR/$i.png $SOURCE_TEMP >/dev/null
fi
done
exit 0
