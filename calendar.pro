QT += qml quick sql
TARGET = calendar

!contains(sql-drivers, sqlite): QTPLUGIN += qsqlite

include(src/src.pri)
include(../shared/shared.pri)

OTHER_FILES += qml/main.qml

RESOURCES += resources.qrc

DISTFILES += \
    android/AndroidManifest.xml \
    android/gradle/wrapper/gradle-wrapper.jar \
    android/gradlew \
    android/res/values/libs.xml \
    android/build.gradle \
    android/gradle/wrapper/gradle-wrapper.properties \
    android/gradlew.bat \
    qml/getrandomTip.js \
    qml/settingPage.qml \
    qml/FirstPage.qml \
    qml/storage.js

deployment.files += signin.sqlite
deployment.path = /assets
INSTALLS += deployment

ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
