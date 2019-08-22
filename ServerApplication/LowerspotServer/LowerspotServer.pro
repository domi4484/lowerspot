#-------------------------------------------------
#
# Project Lowerspot
#
# (C) 2014-2019 Damiano Lombardi
#
#-------------------------------------------------

TEMPLATE = app

TARGET = LowerspotServer

QT += network
QT -= gui

CONFIG += c++11 console
CONFIG -= app_bundle

INCLUDEPATH += \
  src \

include($$PWD/../../Library/Library.pri)


SOURCES += \
  src/Main/main.cpp \
  src/Main/Application.cpp \
  src/CommandReceiver/ServerApplicationCommandReceiver.cpp \
  src/Settings/Settings.cpp

HEADERS += \
  src/Main/Application.h \
  src/CommandReceiver/ServerApplicationCommandReceiver.h \
  src/Settings/Settings.h

