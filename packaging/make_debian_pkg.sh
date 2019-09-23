#!/bin/bash

if [ "$(uname -m)" == "x86_64" ]; then
    ARCH="amd64"
else
    ARCH="i386"
fi

sudo checkinstall -D \
    --default \
    --install=no \
    --pkgname=aquarium-control \
    --pkgversion=2.0\
    --pkgarch=$ARCH \
    --pkgrelease=1 \
    --pkglicense=GPLv3 \
    --pkggroup=utils \
    --pkgsource=http://github.com/baranovskiykonstantin/aquarium-control \
    --maintainer='"Baranovskiy Konstantin <baranovskiykonstantin@gmail.com>"' \
    --requires="libqt5quick5","libqt5gui5","libqt5qml5","libqt5bluetooth5","libqt5core5a","libqt5network5","libqt5dbus5","qml-module-qtquick2","qml-module-qtquick-window2","qml-module-qt-labs-settings","qml-module-qtquick-controls2","qml-module-qtgraphicaleffects" \
    --nodoc \
    --backup=no \
    ./install.sh
