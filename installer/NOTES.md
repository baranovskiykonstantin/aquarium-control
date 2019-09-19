.. make clean ..
cd $BUILD_DIR\release
c:\Qt\5...\msvc...\bin\windeployqt.exe --qmldir z:\projects\aquarium-control\qml aquarium-control.exe
.. remove extra translations ..
c:\QtIFW...\bin\archivegen.exe release.7z *
mkdir z:\projects\aquarium-control\installer\packages\aquariumcontrol\data
move release.7z z:\projects\aquarium-control\installer\packages\aquariumcontrol\data\
cd /d z:\projects\aquarium-control\installer
c:\QtIFW...\bin\binarycreator.exe --config config\config.xml --packages packages aquarium-control-2.0-windows_x86.exe

