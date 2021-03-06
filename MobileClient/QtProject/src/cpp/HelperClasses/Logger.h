/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:                                                         *
 * Created:      --.--.----                                        *
 *                                                                 *
********************************************************************/

#ifndef _LOGGER_H
#define _LOGGER_H

// Qt includes -----------------------------
#include <QObject>
#include <QString>

// Forward declarations --------------------
class QMutex;

//-----------------------------------------------------------------------------------------------------------------------------

/*!
 * \brief The Logger class provides methods to log messages of different severity levels.
 *
 * There is a log level property (see getLogLevel()/setLogLevel()) that defines the minimum severity level of a message to be actually logged.
 * The time when the message is issued is logged also.
 * \note All methods of this class are thread-safe.
 * \todo Reimplement using the database.
 */
class Logger : public QObject
{
  Q_OBJECT
public:

  class _CONST
  {
  public:
    static const int MAX_LOG_LINES;
  };

   /*!
    * \brief The LOG_LEVEL enum denotes the severity level of a log message.
    */
   enum LOG_LEVEL
   {
      LOG_ERROR    = 0,   //!< An (unrecoverable) error has occurred. User intervention is mandatory.
      LOG_WARNING  = 1,   //!< An error has occurred, which does not stop the device from operation. User intervention is optional.
      LOG_INFO     = 2,    //!< A normal operation event has occurred.
      LOG_TRACE    = 3,    //!< A detailed operation event has occurred.
      LOG_DEBUG    = 4,    //!< A more detailed operation event has occurred.
      LOG_VERBOSE  = 5     //!< A verbose operation (i.e. device command, SQL) has occurred.
   };
   Q_ENUMS(LOG_LEVEL)

   explicit Logger(LOG_LEVEL logLevel,
                   QObject *parent = 0);
   virtual ~Logger();

   static void instanziate(LOG_LEVEL logLevel);
   static void destroy();
   static Logger *instance() { return s_Logger; }

   QStringList getLogEntries() const { return m_QStringList_LogEntries; }


   /*!
    * \brief Convert the given log level to a QString.
    * \param log_level The log level to convert.
    * \return A QString representing the given log level.
    */
   static QString toString (LOG_LEVEL log_level);

   /*!
    * \brief Log a message with LOG_ERROR level.
    * \param text The message to log.
    */
   static void error (const QString &text);

   /*!
    * \brief Log a message with LOG_WARNING level.
    * \param text The message to log.
    */
   static void warning (const QString &text);

   /*!
    * \brief Log a message with LOG_INFO level.
    * \param text The message to log.
    */
   static void info (const QString &text);

   /*!
    * \brief Log a message with LOG_TRACE level.
    * \param text The message to log.
    */
   static void trace (const QString &text);

   /*!
    * \brief Log a message with LOG_DEBUG level.
    * \param text The message to log.
    */
   static void debug (const QString &text);

   /*!
    * \brief Log a message with LOG_VERBOSE level.
    * \param text The message to log.
    */
   static void verbose (const QString &text);

public slots:

   // Log level
   void setLogLevel(LOG_LEVEL log_level);
   LOG_LEVEL getLogLevel();

   void slot_error   (const QString &text);
   void slot_warning (const QString &text);
   void slot_info    (const QString &text);
   void slot_trace   (const QString &text);
   void slot_debug   (const QString &text);
   void slot_verbose (const QString &text);

private:

   static Logger *s_Logger;

   static QMutex *const s_Mutex;

   LOG_LEVEL     m_LogLevel;

   QStringList m_QStringList_LogEntries;

   void write (LOG_LEVEL log_level, const QString &text);
};

#endif
