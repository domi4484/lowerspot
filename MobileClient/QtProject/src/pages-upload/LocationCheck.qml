/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      30.12.2014                                        *
 *                                                                 *
 * Copiright (c) 2014 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Qt imports ------------------------------
import QtQuick 2.0
import QtQuick.Controls 1.2
import QtPositioning 5.2

// Project imports -------------------------
import "qrc:/"

BasicPage{
    id: locationCheck
    visible: false

    // Location ----------------------------
    property PositionSource positionSource

    // BasiPage properties -----------------
    title: qsTr("Location")
    continueButtonVisible: false

    // Signals -----------------------------
    signal locationAccepted()

    onVisibleChanged: {
        if(visible == false)
            return;

        textField_Latitude.text = positionSource.position.coordinate.latitude;
        textField_Longitude.text = positionSource.position.coordinate.longitude;
    }

    // Gui ---------------------------------
    Item{
        id: item_Latitude

        width: parent.width / 1.2
        height: 40
        anchors.top: parent.top
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

        Text{
            id: text_Latitude
            height: parent.height
            width: parent.width/2
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Latitude: ")
        }

        TextField{
            id: textField_Latitude
            anchors.left: text_Latitude.right
            height: text_Latitude.height
            width: text_Latitude.width
        }
    }

    Item{
        id: item_Longitude

        width: parent.width / 1.2
        height: 40
        anchors.top: item_Latitude.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

        Text{
            id: text_Longitude
            height: parent.height
            width: parent.width/2
            verticalAlignment: Text.AlignVCenter
            text: qsTr("Longitude: ")
        }

        TextField{
            id: textField_Longitude
            anchors.left: text_Longitude.right
            height: text_Longitude.height
            width: text_Longitude.width
        }
    }

    Button{
        id: button_UpdateLocation
        text: qsTr("Update location")

        width: parent.width / 1.1
        anchors.top: item_Longitude.bottom
        anchors.topMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

    }

    Button{
        id: button_Continue
        text: qsTr("Continue")

        width: parent.width / 1.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            wa_PictureUploader.setPosition(textField_Latitude.text,
                                           textField_Longitude.text);
            locationAccepted();
        }
    }
} // page_Location
