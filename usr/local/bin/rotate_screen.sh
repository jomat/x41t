#!/bin/sh
output="LVDS1"

# Calibrate by putting the tablet in horizontal position and 
# fill in the absolute values
XZ=462
YZ=495

# get actual positions POSX and POSY
POSV=`cat /sys/devices/platform/hdaps/position| tr -d '[=-=][:blank:][=(=][=)=]'`
POSX=`echo $POSV|awk -v FS="," '{print $1}'`
POSY=`echo $POSV|awk -v FS="," '{print $2}'`

# get positional deltas DX and DY
DX=$(($POSX-$XZ))
DY=$(($POSY-$YZ))


# get absolute positional differences DXA and DYA
if [ $DX -lt 0 ]
then
	DXA=$((0 - $DX))
else
	DXA=$DX
fi
if [ $DY -lt 0 ]
then
	DYA=$((0 - $DY))
else
	DYA=$DY
fi

# See who's the strongest candidate
if [ $DXA -gt $DYA ]
then
	if [ $POSX -lt $XZ ]
	then
		wacom=ccw;xrandr=left
	else
		wacom=cw;xrandr=right
	fi
else
	if [ $POSY -lt $YZ ]
        then
		wacom=half;xrandr=inverted
        else
		wacom=none;xrandr=normal
        fi
fi

#echo Wacom: $wacom
#echo DXA: $DXA - XZ: $XZ
#echo DYA: $DYA - YZ: $YZ

xrandr --output $output --rotate $xrandr
xsetwacom --set 'Serial Wacom Tablet' Rotate $wacom
