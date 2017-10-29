#!/bin/sh

INSTDIR=/usr/share/aquarium_control
mkdir -p $INSTDIR
cp -f aquarium-control $INSTDIR/
cp -f aquarium-control.desktop /usr/share/applications/
cp -f ../icons/icon.svg /usr/share/icons/aquarium-control.svg
chmod a+x $INSTDIR/aquarium-control
chmod a+r /usr/share/applications/aquarium-control.desktop
chmod a+r /usr/share/icons/aquarium-control.svg
