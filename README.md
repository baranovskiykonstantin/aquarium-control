# Aquarium-control
This application was designed specially to setup the [aquarium controller](https://github.com/baranovskiykonstantin/aquarium).

![app](https://raw.github.com/baranovskiykonstantin/aquarium-control/master/screenshots/app.gif)

# Packages
* Android: [aquarium-control-1.2-armeabi-v7a.apk](https://drive.google.com/open?id=1oMw0taMNseJIvx_3hUQxOoBZSXMGo6xo)
* Archlinux: [aquarium-control-1.2-1-x86_64.pkg.tar.xz](https://drive.google.com/open?id=1o-2jZ1J10cIlbJuy0R8971tv77lr7II_)
* Debian: [aquarium-control_1.2-1_amd64.deb](https://drive.google.com/open?id=1YNEpKNlSwRB40UwRes4PgvsIbnG-j9Vq)

# Available translations
* English
* Russian
* Ukrainian

# Build dependencies (Ubuntu 18.04)
* Qt
```
sudo apt install qtcreator qt5-default qtdeclarative5-dev qtconnectivity5-dev libqt5svg5-dev qml-module-qtbluetooth qml-module-qtquick-controls2 qml-module-qt-labs-settings
```
* Android
```
sudo apt install openjdk-8-jdk
export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
export PATH=$PATH:$JAVA_HOME/bin
sudo apt install libstdc++6:i386 libgcc1:i386 zlib1g:i386 libncurses5:i386 libsdl1.2debian:i386
... install Android SDK to /opt/android_sdk (platforms;android-21, build-tools:21.1.2, system-images;android-24;default;armeabi-v7a)
... install Android NDK (r16) to /opt/android_ndk_r16
export ANDROID_SDK_ROOT=/opt/android_sdk
export ANDROID_NDK_ROOT=/opt/android_ndk_r16
... build qt-everywhere-opensource-src:
./configure -xplatform android-clang -opensource -confirm-license --disable-rpath -nomake tests -nomake examples -no-warnings-are-errors -android-arch armeabi-v7a -android-ndk-platform android-21 -prefix /opt/android-qt5
sudo make
sudo make install
... configure emulator:
tools/bin/avdmanager create avd --force --name nexus4 --package 'system-images;android-24;default;armeabi-v7a' --abi armeabi-v7a --device 'Nexus 4' --sdcard 128M
emulator/emulator -avd nexus4 -skin 768x1280 -no-audio -no-window -verbose &
```
