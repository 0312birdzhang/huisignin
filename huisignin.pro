QT += qml quick sql
TARGET = huisignin

OPTIONS += roboto

include(src/src.pri)
include(deployment.pri)
include(material/material.pri)

OTHER_FILES += qml/main.qml

RESOURCES += resources.qrc


android: {
    DISTFILES += \
        android/AndroidManifest.xml \
        android/gradle/wrapper/gradle-wrapper.jar \
        android/gradlew \
        android/res/values/libs.xml \
        android/build.gradle \
        android/gradle/wrapper/gradle-wrapper.properties \
        android/gradlew.bat

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

}


ios: {
    QMAKE_INFO_PLIST = $$PWD/huisignin-Info.plist
    QTPLUGIN +=  qsvg
    OTHER_FILES += huisignin-Info.plist

    icons.files += android/res/drawable-hdpi/icon.png
    app_launch_images.files = $$PWD/ios/LaunchScreen.storyboard $$files($$PWD/ios/LaunchScreen*.png)
    QMAKE_BUNDLE_DATA += icons \
                        app_launch_images
}

windows: {
    RC_FILE = icons.rc
}

android: {

    DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    
    deployment.files += signin.sqlite
    deployment.path = /assets
    INSTALLS += deployment

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
}

DISTFILES += \
    qml/getrandomTip.js \
    qml/settingPage.qml \
    qml/FirstPage.qml \
    qml/storage.js \
    qml/SwipeArea.qml




