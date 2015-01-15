/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      11.01.2015                                        *
 *                                                                 *
 * Copiright (c) 2015 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Files includes --------------------------
#include "PlateformDetail.h"

// Project includes ------------------------
#include "Logger.h"

//-----------------------------------------------------------------------------------------------------------------------------

PlateformDetail::PlateformDetail(QObject *parent) :
  QObject(parent),
  m_Os(OS_OTHER)
{
#ifdef Q_OS_ANDROID
  m_Os = OS_ANDROID;
#endif
#ifdef Q_OS_IOS
  m_Os = OS_IOS;
#endif
#ifdef Q_OS_WINPHONE
  m_Os = OS_WINPHONE;
#endif

  Logger::info(QString("Plateform: %1").arg(name()));
}

//-----------------------------------------------------------------------------------------------------------------------------

PlateformDetail::~PlateformDetail()
{

}

//-----------------------------------------------------------------------------------------------------------------------------

bool PlateformDetail::isMobile()
{
  return m_Os != OS_OTHER;
}

//-----------------------------------------------------------------------------------------------------------------------------

QString PlateformDetail::name()
{
  switch (m_Os) {
  case OS_ANDROID:
    return "Android";
  break;
  case OS_IOS:
    return "IOs";
  break;
  case OS_WINPHONE:
    return "Windows phone";
  break;
  case OS_OTHER:
    return "Desktop";
  break;
  }

  return QString();
}

