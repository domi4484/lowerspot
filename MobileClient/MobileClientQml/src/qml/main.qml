/********************************************************************
 *                                                                 *
 * Lowerspot                                                       *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      13.12.2015                                        *
 *                                                                 *
 * Copiright (c) 2015 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Qt imports ------------------------------
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2
import QtPositioning 5.12
import QtLocation    5.12

// Project qml imports ---------------------
import "qrc:/qml/"
import "qrc:/qml/widgets"


ApplicationWindow {
    id: applicationWindow
    visible: true
    width: 340
    height: 500

    // Signals -----------------------------

    signal pushMainGui


    // Slots -------------------------------

    Component.onCompleted:
    {
      // Push the application main gui
      pushMainGui();
    }

    Connections{
        target: hc_Application
        onSignal_NewClientVersionAvailable:
        {
          messageDialog_NewClientVersionAvailable.text = qsTr('There is a new Lowerspot app version available for download (%1)! Get it on lowerspot.com!').arg(hc_Application.currentAvailableClientVersion())
          messageDialog_NewClientVersionAvailable.open();
        }
    }

    // Push the application main gui
    onPushMainGui: stackView.push({immediate : true,
                                   replace   : true,
                                   item      : Qt.resolvedUrl("qrc:/qml/TabWidgetBottom_Main.qml")});


    // Gui ---------------------------------
    StackView {
        id: stackView

        anchors.fill: parent

        initialItem: Image {
            id: image_Splash
            width : parent.width
            height: parent.height

            source: "qrc:/icon/icon/splash.png"
        }
    }


    // Message dialogs ---------------------
    MessageDialog{
        id: messageDialog_NewClientVersionAvailable
        title: qsTr('New version out!')

        onAccepted:
        {
            hc_Application.newerClientVersionAvailableGotIt();
        }
    }

    // Message dialogs ---------------------
    MessageDialog{
        id: messageDialog_SecretSpotClicked
        title: qsTr('Secret spot')
        text: qsTr('The precise location of a secret spot is not displayed. To find the spot try to ask some local skaters.')
    }



    Plugin {
        id: plugin_Osm
        name: "osm"
    }
}
