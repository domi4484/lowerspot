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

#ifndef PLATEFORMDETAIL_H
#define PLATEFORMDETAIL_H

// Qt includes -----------------------------
#include <QObject>

class PlateformDetail : public QObject
{
  Q_OBJECT
public:

  enum OS
  {
    OS_ANDROID,
    OS_IOS,
    OS_WINPHONE,
    OS_DESKTOP
  };

  explicit PlateformDetail(QObject *parent = 0);
  ~PlateformDetail();

  OS getOS() const;

signals:

public slots:

  bool isMobile();
  bool isIOS();

  QString name();

private:

  OS m_Os;

};

#endif // PLATEFORMDETAIL_H
