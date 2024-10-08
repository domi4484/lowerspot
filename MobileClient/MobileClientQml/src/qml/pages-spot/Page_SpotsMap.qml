/********************************************************************
 *                                                                 *
 * Lowerspot                                                       *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      11.04.2016                                        *
 *                                                                 *
 * Copiright (c) 2016 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Qt imports ------------------------------
import QtQuick 2.5
import QtPositioning 5.12
import QtLocation    5.12

// Project qml imports ---------------------
import "qrc:/qml/component"

Item {
    id: page_SpotsMap

    // Navigation properties ---------------

    property string navigation_Title:                 ""
    property bool   navigation_BackButtonVisible:     true
    property bool   navigation_ContinueButtonVisible: false
    property bool   navigation_MenuButtonVisible:     false


    // Properties

    property variant map_visibleRegion: QtPositioning.rectangle(map.toCoordinate(Qt.point(0, 0), true),
                                                                map.toCoordinate(Qt.point(width, height), true))


    // Bind properties ---------------------

    property alias model: mapItemView.model

    property alias map_center:        map.center
    property alias map_zoomLevel:     map.zoomLevel

    // Signals -----------------------------

    signal spotClicked(int    spotId,
                       string spotName,
                       string spotDescription)


    // Gui ---------------------------------

    Map {
        id: map
        anchors.fill: parent

        plugin: plugin_Osm;
        zoomLevel: 8

        Component.onCompleted: {
            center = hc_LocationManager.coordinate
        }

        Component_CurrentLocationIndicator {
        }

        MapItemView {
            id: mapItemView

            delegate: MapQuickItem {

                coordinate.latitude:   role_SpotLatitude
                coordinate.longitude:  role_SpotLongitude

                anchorPoint.x: image.width * 0.5
                anchorPoint.y: image.height

                sourceItem: Column {

                    visible: !role_SpotSecretSpot

                    Image {
                        id: image;
                        width:  Math.min(5 * map.zoomLevel, 40)  // default 40px at zoomLevel 8
                        height: Math.min(5 * map.zoomLevel, 40)
                        source: "qrc:/icon/icon/find-location.png"

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                    page_SpotsMap.spotClicked(role_SpotId,
                                                              role_SpotName,
                                                              role_SpotDescription);
                            }
                        }
                    }
                    Text {
                        text: role_SpotName;
                        font.bold: true
                        visible: map.zoomLevel > 15
                    }
                }
            }
        }

        onCenterChanged: {
          var coordinateTopLeft           = map.toCoordinate(Qt.point(0, 0),          true);
          var coordinateBottomRight       = map.toCoordinate(Qt.point(width, height), true);

          map_visibleRegion = QtPositioning.rectangle(coordinateTopLeft, coordinateBottomRight);
        }

        onZoomLevelChanged: {
          var coordinateTopLeft           = map.toCoordinate(Qt.point(0, 0),          true);
          var coordinateBottomRight       = map.toCoordinate(Qt.point(width, height), true);

          map_visibleRegion = QtPositioning.rectangle(coordinateTopLeft, coordinateBottomRight);
        }
    }
}
