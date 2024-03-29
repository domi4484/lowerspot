/********************************************************************
 *                                                                 *
 * Lowerspot                                                       *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      11.11.2015                                        *
 *                                                                 *
 * Copiright (c) 2015 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Qt imports ------------------------------
import QtQuick 2.5
import QtQuick.Controls 1.3

// Project c++ imports ---------------------
import PicturesModel 1.0

// Project qml imports ---------------------
import "qrc:/qml/"
import "qrc:/qml/views"
import "qrc:/qml/widgets"

Item{
    id: component_PicturesGrid


    // Bind properties ---------------------

    property alias model: gridView_Pictures.model


    // Signals -----------------------------

    signal pictureClicked(int    pictureId,
                          string spotName)


    // Gui ---------------------------------

    GridView{
        id: gridView_Pictures

        anchors.horizontalCenter: parent.horizontalCenter
        width:  parent.width + 2
        height: parent.height

        cellWidth:  width / 2
        cellHeight: cellWidth

        delegate: component_Picture


    }


    // Components --------------------------

    Component {
        id: component_Picture

        Item {
            width:  gridView_Pictures.cellWidth
            height: gridView_Pictures.cellHeight

            CachedPicture {
                id: image_Picture

                anchors.centerIn: parent
                width:  parent.width  - 2
                height: parent.height - 2

                sourceUrl: role_PictureUrl
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        component_PicturesGrid.pictureClicked(role_PictureId,
                                                              role_SpotName);
                    }
                }
            }
        }
    }
}

