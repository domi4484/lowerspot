/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      01.04.2015                                        *
 *                                                                 *
 * Copiright (c) 2015 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Qt imports ------------------------------
import QtQuick 2.5
import QtQuick.Controls 1.3

// Project qml imports ---------------------
import "qrc:/qml/"
import "qrc:/qml/views"

Item{
    id: page_SpotsList

    // Navigation properties ---------------

    property string navigation_Title:                 ""
    property bool   navigation_BackButtonVisible:     true
    property bool   navigation_ContinueButtonVisible: false
    property bool   navigation_MenuButtonVisible:     false


    // Bind properties ---------------------

    property alias model                : listView.model
    property alias listView_YPosition   : listView.contentY
    property alias listView_Moving      : listView.moving


    // Signals -----------------------------

    signal spotClicked(int    spotId,
                       string spotName,
                       string spotDescription)

    signal signal_listView_atYBeginning()

    // Gui ---------------------------------

    ListView {
        id: listView
        anchors.fill: parent
        delegate: SpotOverviewDelegate{

            onSpotClicked: {
                page_SpotsList.spotClicked(role_SpotId,
                                           role_SpotName,
                                           role_SpotDescription);
            }
        }

        onAtYBeginningChanged:
        {
            if(atYBeginning === false)
                return;

            signal_listView_atYBeginning();
        }
    }
}

