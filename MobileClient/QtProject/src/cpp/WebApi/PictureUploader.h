/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      03.11.2014                                        *
 *                                                                 *
 * Copiright (c) 2014 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

#ifndef COMMAND_UPLOAD_H
#define COMMAND_UPLOAD_H

// Project includes ------------------------
#include "WebApiError.h"
#include "WebApiCommand.h"

// Qt includes -----------------------------
#include <QPixmap>

class PictureUploader : public QObject
{

  Q_OBJECT

public:

  explicit PictureUploader(QObject *parent = 0);

public slots:

  QString lastErrorText() const { return m_LastErrorText; }

  void setNewSpot(bool newSpot);
  void setPictureFilePath(const QString &path);
  void setCameraPictureFilePath(const QString &path);
  void setCropPicture(const QString &source_url,
                      qreal crop_x,
                      qreal crop_y,
                      qreal crop_side);
  void setName(const QString &title);
  void setDescription(const QString &description);
  void setPosition(float latitude,
                   float longitude);

  bool execute();

signals:

  void signal_UploadFinished(bool success);

private slots:

  void slot_CommandUploadNewSpot_Finished(const WebApiError &error);
  void slot_CommandUploadPictureToSpot_Finished(const WebApiError &error);

private:

  static const QString C_NEW_SPOT;
  static const QString C_PICTURE_TO_SPOT;

  static const QString R_PARAM_ID_SPOT;
  static const QString R_PARAM_LATITUDE;
  static const QString R_PARAM_LONGITUDE;
  static const QString R_PARAM_NAME;
  static const QString R_PARAM_DESCRIPTION;

  static const QString A_PARAM_SUCCESSFUL;

  QString m_LastErrorText;

  QString m_Command;
  QPixmap m_Pixmap;

  float   m_Latitude;
  float   m_Longitude;

  int m_SpotId;

  QString m_Name;
  QString m_Description;

  WebApiCommand m_WebApiCommand_UploadNewSpot;
  WebApiCommand m_WebApiCommand_UploadPictureToSpot;

  bool uploadNewSpot();
  bool uploadPictureToSpot();
};

#endif // COMMAND_UPLOAD_H
