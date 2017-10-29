#!/bin/sh

sudo checkinstall -D \
    --default \
    --install=no \
    --pkgname=aquarium-control \
    --pkgversion=1.0\
    --pkgarch=amd64 \
    --pkgrelease=1 \
    --pkglicense=GPLv3 \
    --pkggroup=utils \
    --pkgsource=http://github.com/baranovskiykonstantin/aquarium-control \
    --maintainer='"Baranovskiy Konstantin <baranovskiykonstantin@gmail.com>"' \
    --requires="libqt5quick5","libqt5svg5","libqt5widgets5","libqt5gui5","libqt5qml5","libqt5network5","libqt5bluetooth5","libqt5core5a","libqt5dbus5" \
    --nodoc \
    --backup=no \
    ./install.sh
