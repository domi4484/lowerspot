/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      19.05.2014                                        *
 *                                                                 *
 * Copiright (c) 2014 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Files includes --------------------------
#include "WebApi.h"

// Project includes ------------------------
#include "../HelperClasses/Logger.h"
#include "WebApiCommand.h"
#include "WebApiError.h"

// Qt includes -----------------------------
#include <QDebug>
#include <QFile>
#include <QJsonParseError>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QUrlQuery>
#include <QHttpMultiPart>

//-----------------------------------------------------------------------------------------------------------------------------

// Location of the web service
const QString WebApi::URL_DEVELOPMENT ("http://localhost/Symfony/web/app_dev.php/webservice");
const QString WebApi::URL_PRODUCTION  ("http://spots.lowerclassclothing.com/web/webservice");


const QString WebApi::CONST::GENERAL_PARAMS::COMMAND    ("command");
const QString WebApi::CONST::GENERAL_PARAMS::ERROR      ("error");

const char *WebApi::PROPERTY_COMMAND_ID = "command_id";

// Commands
const QString WebApi::C_LOGIN                      ("login");
const QString WebApi::C_LOGOUT                     ("logout");
const QString WebApi::C_REGISTER                   ("register");
const QString WebApi::C_CANREGISTER                ("canregister");
const QString WebApi::C_GET_CURRENT_CLIENT_VERSION ("getCurrentClientVersion");
const QString WebApi::C_GET_SPOTS_BY_DISTANCE      ("getSpotsByDistance");
const QString WebApi::C_GET_SPOTS_BY_USER_ID       ("getSpotsByUserId");

const QString WebApi::C_GET_PICTURES_BY_SPOT_ID    ("getPicturesBySpotId");
const QString WebApi::C_GET_PICTURES_BY_USER_ID    ("getPicturesByUserId");
const QString WebApi::C_GET_PICTURES_BY_NEWEST     ("getPicturesByNewest");

const QString WebApi::C_UPLOAD_NEW_SPOT            ("uploadNewSpot");
const QString WebApi::C_UPLOAD_PICTURE_TO_SPOT     ("uploadPictureToSpot");


// Request parameters
const QString WebApi::R_PARAM_APPLICATION_VERSION ("version");

const QString WebApi::R_PARAM_USER_ID  ("id_user");
const QString WebApi::R_PARAM_USERNAME ("username");
const QString WebApi::R_PARAM_PASSWORD ("password");
const QString WebApi::R_PARAM_EMAIL    ("email");

const QString WebApi::R_PARAM_SPOT_ID ("id_spot");

const QString WebApi::R_PARAM_LATITUDE       ("latitude");
const QString WebApi::R_PARAM_LONGITUDE      ("longitude");
const QString WebApi::R_PARAM_MAX_DISTANCE_KM("maxDistance_km");

const QString WebApi::R_PARAM_SECRET_SPOT("spot_secretSpot");

const QString WebApi::R_PARAM_NAME        ("name");
const QString WebApi::R_PARAM_DESCRIPTION ("description");

// Answer parameters
const QString WebApi::A_PARAM_AUTHENTICATION ("authentication");
const QString WebApi::A_PARAM_REGISTERED     ("registered");
const QString WebApi::A_PARAM_ID_USER        ("id_user");
const QString WebApi::A_PARAM_VERSION        ("version");

const QString WebApi::A_ARRAY_SPOTS ("spots");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_ID            ("id");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_NAME          ("name");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_DESCRIPTION   ("description");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_SECRET_SPOT   ("secretSpot");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_LATITUDE      ("latitude");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_LONGITUDE     ("longitude");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_DISTANCE_KM   ("distance_km");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_PICTURE_URL_1 ("pictureUrl1");
const QString WebApi::A_ARRAY_SPOTS_ELEMENT_PICTURE_URL_2 ("pictureUrl2");

const QString WebApi::A_ARRAY_PICTURES ("pictures");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_ID          ("id");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_ID_USER     ("id_user");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_ID_SPOT     ("id_spot");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_URL         ("url");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_USERNAME    ("username");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_NAME        ("name");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_DESCRIPTION ("description");
const QString WebApi::A_ARRAY_PICTURES_ELEMENT_CREATED     ("created");

const QString WebApi::A_PARAM_SUCCESSFUL  ("successful");

//-----------------------------------------------------------------------------------------------------------------------------

WebApi *WebApi::s_Instance(NULL);

//-----------------------------------------------------------------------------------------------------------------------------

WebApi::WebApi() :
  QObject(),
  m_Url(URL_PRODUCTION),
  m_QNetworkAccessManager(),
  m_CommandsIdCounter(0),
  m_RunningCommands()
{
}

//-----------------------------------------------------------------------------------------------------------------------------

WebApi::~WebApi()
{
}

//-----------------------------------------------------------------------------------------------------------------------------

WebApi *WebApi::instance()
{
  if(s_Instance == NULL)
    s_Instance = new WebApi();

  return s_Instance;
}

//-----------------------------------------------------------------------------------------------------------------------------

void WebApi::destroy()
{
  if(s_Instance == NULL)
    return;

  delete s_Instance;
  s_Instance = NULL;
}

//----------------------------------------------------------------------------------------------------------------------------

void WebApi::setUrl(const QString url)
{
  m_Url.setUrl(url);
}

//----------------------------------------------------------------------------------------------------------------------------

void WebApi::slot_QNetworkReply_uploadProgress(qint64 received,
                                               qint64 total)
{
  // Retrieve command
  QNetworkReply *reply = dynamic_cast<QNetworkReply *>(sender());
  QNetworkReply::NetworkError replyNetworkError = reply->error();
  unsigned int commandId = reply->property(PROPERTY_COMMAND_ID).toUInt();
  WebApiCommand *command = m_RunningCommands.value(commandId, NULL);

  // Command id not found
  if(command == NULL)
  {
    Logger::error(tr("Command with id '%1' not found in command list.").arg(commandId));
    return;
  }

  // Network error
  if ( replyNetworkError != QNetworkReply::NoError )
  {
    Logger::error(QString("Network error %1").arg(replyNetworkError));
    command->setResult(WebApiError(WebApiError::NETWORK),
                       QJsonObject());
    return;
  }

  if(   received != 0
     && total    != 0)
  {
    Logger::trace(QString("%1/%2").arg(received)
                  .arg(total));
    command->setProgress(received,
                         total);
    return;
  }

  // Delete reply
  reply->deleteLater();

  // Received data
  QByteArray data = reply->readAll();
  QString dataText = data;
  Logger::trace(QString("Received: %1").arg(dataText));

  // Parse received JSON
  QJsonParseError jsonParseError;
  QJsonDocument jsonDocument = QJsonDocument::fromJson(data,
                                                       &jsonParseError);

  if(jsonParseError.error != QJsonParseError::NoError)
  {
      Logger::error(tr("Parse Json error: %1").arg(jsonParseError.errorString()));
      command->setResult(WebApiError(WebApiError::SERVER),
                         jsonDocument.object());
      return;
  }

  if(jsonDocument.object().isEmpty())
  {
      Logger::error(tr("Server error: received an empty answer").arg(jsonParseError.errorString()));
      command->setResult(WebApiError(WebApiError::SERVER),
                         jsonDocument.object());
      return;
  }

  // Command error
  QString errorText = jsonDocument.object().value(CONST::GENERAL_PARAMS::ERROR).toString();
  if(errorText.isEmpty() == false)
  {
    Logger::error("Error: " + errorText);
    command->setResult(WebApiError(WebApiError::COMMAND,
                                   errorText),
                       jsonDocument.object());
    return;
  }

  command->setResult(WebApiError(WebApiError::NONE),
                     jsonDocument.object());
}

//----------------------------------------------------------------------------------------------------------------------------

void WebApi::slot_QNetworkReply_downloadProgress(qint64 received,
                                                 qint64 total)
{
  // Retrieve command
  QNetworkReply *reply = dynamic_cast<QNetworkReply *>(sender());
  QNetworkReply::NetworkError replyNetworkError = reply->error();
  unsigned int commandId = reply->property(PROPERTY_COMMAND_ID).toUInt();
  WebApiCommand *command = m_RunningCommands.value(commandId, NULL);

  // Command id not found
  if(command == NULL)
  {
    Logger::error(tr("Command with id '%1' not found in command list.").arg(commandId));
    return;
  }

  // Network error
  if ( replyNetworkError != QNetworkReply::NoError )
  {
    Logger::error(QString("Network error %1").arg(replyNetworkError));
    command->setResult(WebApiError(WebApiError::NETWORK),
                       QJsonObject());
    return;
  }

  if(received != total)
  {
    Logger::trace(QString("%1/%2").arg(received)
                                  .arg(total));
    command->setProgress(received,
                         total);
    return;
  }

  // Delete reply
  reply->deleteLater();

  // Received data
  command->setRawResult(WebApiError(WebApiError::NONE),
                        reply->readAll());
}

//----------------------------------------------------------------------------------------------------------------------------

void WebApi::slot_QNetworkReply_finished()
{
  // Retrieve command and data
  QNetworkReply *reply = dynamic_cast<QNetworkReply *>(sender());
  QNetworkReply::NetworkError replyNetworkError       = reply->error();
  QString                     replyNetworkErrorString = reply->errorString();
  unsigned int commandId = reply->property(PROPERTY_COMMAND_ID).toUInt();
  WebApiCommand *command = m_RunningCommands.value(commandId, NULL);
  reply->deleteLater();

  // Command id not found
  if(command == NULL)
  {
    Logger::error(tr("Command with id '%1' not found in command list.").arg(commandId));
    return;
  }

  // Network error
  if ( replyNetworkError != QNetworkReply::NoError )
  {   
    Logger::error(QString("Network error %1 (%2)").arg(replyNetworkError)
                                                  .arg(replyNetworkErrorString));
    command->setResult(WebApiError(WebApiError::NETWORK),
                       QJsonObject());
    return;
  }

  // Received data
  QByteArray data = reply->readAll();
  QString dataText = data;
  Logger::trace(QString("Received: %1").arg(dataText));

  // Parse received JSON
  QJsonParseError jsonParseError;
  QJsonDocument jsonDocument = QJsonDocument::fromJson(data,
                                                       &jsonParseError);

  if(jsonParseError.error != QJsonParseError::NoError)
  {
      Logger::error(tr("Parse Json error: %1").arg(jsonParseError.errorString()));
      command->setResult(WebApiError(WebApiError::SERVER),
                         jsonDocument.object());
      return;
  }

  if(jsonDocument.object().isEmpty())
  {
      Logger::error(tr("Server error: received an empty answer").arg(jsonParseError.errorString()));
      command->setResult(WebApiError(WebApiError::SERVER),
                         jsonDocument.object());
      return;
  }

  // Command error
  QString errorText = jsonDocument.object().value(CONST::GENERAL_PARAMS::ERROR).toString();
  if(errorText.isEmpty() == false)
  {
    Logger::error("Error: " + errorText);
    command->setResult(WebApiError(WebApiError::COMMAND,
                                   errorText),
                       jsonDocument.object());
    return;
  }

  command->setResult(WebApiError(WebApiError::NONE),
                     jsonDocument.object());
}

//----------------------------------------------------------------------------------------------------------------------------

void WebApi::postRequest(WebApiCommand *abstractCommand,
                         const QList<QueryItem> &qList_QueryItems)
{
  int commandId = m_CommandsIdCounter++;
  m_RunningCommands.insert(commandId, abstractCommand);

  QNetworkRequest request(m_Url);
  request.setHeader(QNetworkRequest::ContentTypeHeader,
                    "application/x-www-form-urlencoded");

  QUrlQuery params;
  params.addQueryItem(CONST::GENERAL_PARAMS::COMMAND,    abstractCommand->command());
  foreach(QueryItem item, qList_QueryItems)
  {
    params.addQueryItem(item.first(), item.second());
  }

  QNetworkReply *reply = m_QNetworkAccessManager.post(request, params.query(QUrl::FullyEncoded).toUtf8());
  reply->setProperty(PROPERTY_COMMAND_ID, commandId);
  connect(reply,
          SIGNAL(finished()),
          SLOT  (slot_QNetworkReply_finished()));
}

//-----------------------------------------------------------------------------------------------------------------------------

void WebApi::multipartRequest(WebApiCommand *abstractCommand,
                              const QList<QueryItem> &qList_QueryItems,
                              QIODevice *device)
{
  int commandId = m_CommandsIdCounter++;
  m_RunningCommands.insert(commandId, abstractCommand);

  QHttpMultiPart *multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);

  // Command
  {
    QHttpPart textPart;
    textPart.setHeader(QNetworkRequest::ContentDispositionHeader,
                       QVariant(QString("application/x-www-form-urlencoded; name=\"%1\";").arg(CONST::GENERAL_PARAMS::COMMAND)));
    textPart.setBody(abstractCommand->command().toUtf8());

    multiPart->append(textPart);
  }

  // Text part
  foreach (QueryItem queryItem, qList_QueryItems)
  {
    QHttpPart textPart;
    textPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant(QString("application/x-www-form-urlencoded; name=\"%1\";").arg(queryItem.first())));
    textPart.setBody(queryItem.second().toUtf8());

    multiPart->append(textPart);
  }

  // Image part
  QHttpPart imagePart;
  imagePart.setHeader(QNetworkRequest::ContentTypeHeader,
                      QVariant("image/jpeg"));
  imagePart.setHeader(QNetworkRequest::ContentDispositionHeader,
                      QVariant(  "application/x-www-form-urlencoded; name=\"image\"; filename=\"ilmiobelfile.jpg\""));
  device->open(QIODevice::ReadOnly);
  imagePart.setBodyDevice(device);
  device->setParent(multiPart); // we cannot delete the device now, so delete it with the multiPart

  multiPart->append(imagePart);

  QNetworkRequest request(m_Url);

  QNetworkReply *reply = m_QNetworkAccessManager.post(request, multiPart);
  reply->setProperty(PROPERTY_COMMAND_ID, commandId);

  multiPart->setParent(reply); // delete the multiPart with the reply

  connect(reply,
          SIGNAL(uploadProgress(qint64, qint64)),
          SLOT  (slot_QNetworkReply_uploadProgress(qint64, qint64)));
}

//-----------------------------------------------------------------------------------------------------------------------------

void WebApi::downloadRequest(WebApiCommand *abstractCommand,
                             const QString &url)
{
  int commandId = m_CommandsIdCounter++;
  m_RunningCommands.insert(commandId, abstractCommand);

  QNetworkRequest request(url);

  QNetworkReply *reply = m_QNetworkAccessManager.get(request);
  reply->setProperty(PROPERTY_COMMAND_ID, commandId);

  connect(reply,
          SIGNAL(downloadProgress(qint64, qint64)),
          SLOT  (slot_QNetworkReply_downloadProgress(qint64, qint64)));
}

//-----------------------------------------------------------------------------------------------------------------------------







