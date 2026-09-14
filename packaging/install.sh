#!/bin/sh

INSTDIR=/usr
#INSTDIR=/usr/local
mkdir -p $INSTDIR/bin
mkdir -p $INSTDIR/share/icons
mkdir -p $INSTDIR/share/applications
cp -f aquarium-control $INSTDIR/bin/
cp -f ../icons/icon.svg $INSTDIR/share/icons/aquarium-control.svg
cp -f aquarium-control.desktop $INSTDIR/share/applications/
chmod a+x $INSTDIR/bin/aquarium-control
chmod a+r $INSTDIR/share/icons/aquarium-control.svg
chmod a+r $INSTDIR/share/applications/aquarium-control.desktop
