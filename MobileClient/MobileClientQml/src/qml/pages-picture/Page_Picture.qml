/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      23.10.2015                                        *
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
import "qrc:/qml/widgets"
import "qrc:/qml/pages-user"
import "qrc:/qml/pages-picture"

Item{
    id: page_Picture


    // Properties --------------------------

    property Navigator navigator
    property StackView stackView


    // Bind properties ---------------------

    property alias model: picturesModel


    // Navigation properties ---------------

    property string navigation_Title:                 ""
    property bool   navigation_BackButtonVisible:     true
    property bool   navigation_ContinueButtonVisible: false
    property bool   navigation_MenuButtonVisible:     false


    // Models ------------------------------

    PicturesModel{
        id: picturesModel
    }


    // Gui ---------------------------------

    ListView {
        id: listView
        anchors.fill: parent
        model: picturesModel

        delegate: PictureViewDelegate{

            onUserClicked: {
                stackView.push( {
                                   item       : Qt.resolvedUrl("qrc:/qml/pages-user/Page_User.qml"),
                                   properties : {
                                                  navigation_Title : role_UserUsername,
                                                  stackView        : stackView,
                                                  userId           : role_UserId
                                                }
                                } );
            }
//            onSpotClicked: {
//                stackView.push( {
//                                   item       : Qt.resolvedUrl("qrc:/qml/pages-spot/Page_Spot.qml"),
//                                   properties : {
//                                                  navigation_Title : role_SpotName,
//                                                  stackView        : stackView,
//                                                  spotId           : role_SpotId
//                                                }
//                                } );
//            }
        }
    }
}
