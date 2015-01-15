#-------------------------------------------------
#
# Project InstaSpots
#
# (C) 2014 Damiano Lombardi
#
#-------------------------------------------------

TEMPLATE = app

TARGET = InstaSpots

MOC_DIR            = build
RCC_DIR            = build
UI_DIR             = build
!win32:OBJECTS_DIR = build

DESTDIR = bin

QT += qml quick widgets script positioning multimedia

CONFIG   += console debug

SOURCES += src/cpp/main.cpp \
    src/cpp/WebApi/Command_CanRegister.cpp \
    src/cpp/WebApi/Command_Register.cpp \
    src/cpp/WebApi/Picture.cpp \
    src/cpp/WebApi/PictureBase.cpp \
    src/cpp/WebApi/QueryItem.cpp \
    src/cpp/WebApi/Spot.cpp \
    src/cpp/WebApi/User.cpp \
    src/cpp/WebApi/WebApi.cpp \
    src/cpp/WebApi/WebApiCommand.cpp \
    src/cpp/WebApi/WebApiError.cpp \
    src/cpp/HelperClasses/Logger.cpp \
    src/cpp/HelperClasses/StringHelper.cpp \
    src/cpp/WebApi/NewsModel.cpp \
    src/cpp/WebApi/PictureUploader.cpp \
    src/cpp/WebApi/NearbySpotsModel.cpp \
    src/cpp/HelperClasses/PlateformDetail.cpp

RESOURCES += src/qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    src/cpp/WebApi/Command_Register.h \
    src/cpp/WebApi/Command_CanRegister.h \
    src/cpp/WebApi/Picture.h \
    src/cpp/WebApi/PictureBase.h \
    src/cpp/WebApi/QueryItem.h \
    src/cpp/WebApi/Spot.h \
    src/cpp/WebApi/User.h \
    src/cpp/WebApi/WebApi.h \
    src/cpp/WebApi/WebApiCommand.h \
    src/cpp/WebApi/WebApiError.h \
    src/cpp/HelperClasses/Logger.h \
    src/cpp/HelperClasses/StringHelper.h \
    src/cpp/WebApi/NewsModel.h \
    src/cpp/WebApi/PictureUploader.h \
    src/cpp/WebApi/NearbySpotsModel.h \
    src/cpp/HelperClasses/PlateformDetail.h

DISTFILES += \
    ../WebService/api.php \
    ../WebService/index.php \
    ../WebService/lib.php
