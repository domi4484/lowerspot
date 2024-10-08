/********************************************************************
 *                                                                 *
 * Lowerspot                                                       *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      30.12.2014                                        *
 *                                                                 *
 * Copiright (c) 2014 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Qt imports ------------------------------
import QtQuick 2.5
import QtQuick.Controls 1.2
import QtQuick.Dialogs  1.2
import QtPositioning    5.15
import QtLocation       5.15

// Project qml imports ---------------------
import "qrc:/qml/"
import "qrc:/qml/component"

Item{
    id: upload_LocationCheck
    visible: false

    // Navigation properties ---------------

    property string navigation_Title:                 qsTr("Spot location")
    property bool   navigation_BackButtonVisible:     true
    property bool   navigation_ContinueButtonVisible: true
    property bool   navigation_MenuButtonVisible:     false

    // Gui ---------------------------------

    Map {
        id: map
        anchors.fill: parent

        plugin: plugin_Osm;
        zoomLevel: 17

        Component.onCompleted: {
            center = hc_LocationManager.coordinate

            mapQuickItem_SpotLocation.coordinate = hc_LocationManager.coordinate

            spotsModel_NearbySpotSelection.updateBy_Location(hc_LocationManager.coordinate);
        }

        onVisibleChanged: {
            if(visible === false)
                return;

            center = hc_LocationManager.coordinate
        }

        MouseArea {
            anchors.fill: parent
            onClicked: {
                // Set cursor location
                mapQuickItem_SpotLocation.coordinate = map.toCoordinate(Qt.point(mouseX, mouseY), false);

                // Update the nearby spot model
                spotsModel_NearbySpotSelection.updateBy_Location(mapQuickItem_SpotLocation.coordinate);
            }
        }

        Component_CurrentLocationIndicator {
        }

        MapQuickItem {
          id: mapQuickItem_SpotLocation

          anchorPoint.x: image_SpotLocation.width *0.5
          anchorPoint.y: image_SpotLocation.height

          sourceItem:Image {

              id: image_SpotLocation;
              width:  40
              height: 40
              source: "qrc:/icon/icon/find-location.png"
          }
        }
    }


    Button{
        id: button_Continue
        text: qsTr("Continue")

        width: parent.width / 1.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

        onClicked: {
            wa_PictureUploader.coordinate = mapQuickItem_SpotLocation.coordinate;
            stackView.push({item: Qt.resolvedUrl("qrc:/qml/pages-upload/Upload_NearbySpotSelection.qml"),
                            properties:{stackView        : stackView}});
        }
    }


    function navigator_ContinueButtonClicked()
    {
        wa_PictureUploader.coordinate = mapQuickItem_SpotLocation.coordinate;
        stackView.push({item: Qt.resolvedUrl("qrc:/qml/pages-upload/Upload_NearbySpotSelection.qml"),
                        properties:{stackView        : stackView}});
    }
}
