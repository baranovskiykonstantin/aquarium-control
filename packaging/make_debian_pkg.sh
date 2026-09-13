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
    --pkgversion=2.2\
    --pkgarch=$ARCH \
    --pkgrelease=1 \
    --pkglicense=GPLv3 \
    --pkggroup=utils \
    --pkgsource=http://github.com/baranovskiykonstantin/aquarium-control \
    --maintainer='"Baranovskiy Konstantin <baranovskiykonstantin@gmail.com>"' \
    --requires="libqt6quick6","libqt6gui6","libqt6qml6","libqt6serialport6","libqt6core6","libqt6svg6","libqt6core5compat6","qml6-module-qtquick","qml6-module-qtquick-controls","qml6-module-qtquick-window","qml6-module-qtcore","qml6-module-qt5compat-graphicaleffects" \
    --nodoc \
    --backup=no \
    ./install.sh
