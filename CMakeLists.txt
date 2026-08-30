# aquarium-control — Qt 6.8 LTS baseline (built/tested against Qt 6.9.3 at /opt/qt)
cmake_minimum_required(VERSION 3.21)

project(aquarium-control VERSION 2.2 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.8 REQUIRED COMPONENTS
    Core
    Gui
    Qml
    Quick
    QuickControls2
    Bluetooth
    Svg
    Core5Compat
)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(aquarium-control
    main.cpp
    bt_rfcomm.cpp
    bt_rfcomm.h
    qml.qrc
)

target_link_libraries(aquarium-control PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Qml
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Bluetooth
    Qt6::Svg
    Qt6::Core5Compat
)

set_target_properties(aquarium-control PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
    QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
    QT_ANDROID_VERSION_CODE 3
    QT_ANDROID_VERSION_NAME "${PROJECT_VERSION}"
    QT_ANDROID_APP_ICON "@mipmap/ic_launcher"
    QT_ANDROID_APP_NAME "Aquarium control"
)

if(NOT ANDROID)
    include(GNUInstallDirs)
    install(TARGETS aquarium-control
        BUNDLE DESTINATION .
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    )
    install(FILES icons/icon.svg
        DESTINATION ${CMAKE_INSTALL_DATADIR}/icons
        RENAME aquarium-control.svg
    )
    install(FILES packaging/aquarium-control.desktop
        DESTINATION ${CMAKE_INSTALL_DATADIR}/applications
    )
endif()
