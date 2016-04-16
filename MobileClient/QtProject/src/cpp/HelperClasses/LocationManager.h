/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      28.01.2015                                        *
 *                                                                 *
 * Copiright (c) 2015 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

#ifndef LOCATIONMANAGER_H
#define LOCATIONMANAGER_H

// Qt includes -----------------------------
#include <QObject>
#include <QGeoPositionInfoSource>

// Forward declarations --------------------
class Settings;
class PlateformDetail;

class LocationManager : public QObject
{
  Q_OBJECT

  Q_PROPERTY(QGeoCoordinate coordinate  READ coordinate  NOTIFY signal_Coordinate_changed )

public:
  explicit LocationManager(Settings *settings,
                           PlateformDetail *plateformDetail,
                           QObject *parent = 0);
  ~LocationManager();

signals:

  void update(bool timeout);

  void signal_RequestLocation();

  void signal_Coordinate_changed();

public slots:

  void setFakePosition(double latitude,
                       double longitude);

  void requestLocation();

  bool isValid();

  double latitude();
  double longitude();

  QGeoCoordinate coordinate();

  qreal computeDistance(const QPointF &point1,
                        const QPointF &point2);

  void openLocationOnNativeMapsApp(double latitude,
                                   double longitude,
                                   const QString &label = "");

private slots:
  void slot_GeoPositionInfoSource_positionUpdated(QGeoPositionInfo geo_position_info);
  void slot_GeoPositionInfoSource_UpdateTimeout();
  void slot_GeoPositionInfoSource_error(QGeoPositionInfoSource::Error error);
private:

  // Link to Settings
  Settings *m_Settings;

  // Link to PlateformDetail
  PlateformDetail *m_PlateformDetail;

//  QGeoPositionInfoSource *m_GeoPositionInfoSource;

  bool m_Valid;

  double m_Latitude;
  double m_Longitude;

  QGeoCoordinate m_QGeoCoordinate;

};

#endif // LOCATIONMANAGER_H
