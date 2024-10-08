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
import QtQuick.Controls 1.2
import QtQuick.Dialogs 1.2

// Project imports -------------------------
import "qrc:/qml/"

Item{
    id: upload_AddToExistingSpot


    // Navigation properties ---------------

    property string navigation_Title:                 qsTr("Add picture to spot")
    property bool   navigation_BackButtonVisible:     true
    property bool   navigation_ContinueButtonVisible: false
    property bool   navigation_MenuButtonVisible:     false


    // Message boxes -----------------------

    MessageDialog{
        id: messageDialog_Error
        title: qsTr('Upload error')
    }


    // Connections -------------------------


    Component.onCompleted: {
        text_SpotName.text    = wa_PictureUploader.name();
        text_Description.text = wa_PictureUploader.description();
    }

    Connections{
        target: wa_PictureUploader
        onSignal_UploadFinished:
        {
            if(wa_PictureUploader.isNewSpot())
            {
                return;
            }

            button_UploadPicture.enabled = true;

            if(success == false)
            {
                messageDialog_Error.text = wa_PictureUploader.lastErrorText();
                messageDialog_Error.visible = true;
                return;
            }

            // Change view to Home
            stackView.pop(page_Upload_SourceSelection);
            tabWidget_Main.setCurrentItem(panel_Home);
            panel_Home.tabWidget_CurrentTabReclicked();

            wa_PictureUploader.resetDefaults()
        }
    }


    // Gui ---------------------------------

    Column{
        id: column
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.topMargin: 5
        width: parent.width / 1.1
        spacing: 5

        Text{
            text: qsTr("Spot name:")
        }

        Text{
            id: text_SpotName
            width: parent.width
        }

        Text{
            text: qsTr("Spot description:")
        }
    }
    Text{
        id: text_Description
        width: parent.width / 1.1
        anchors.top: column.bottom
        anchors.bottom: button_UploadPicture.top
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Button{
        id: button_UploadPicture
        width: parent.width / 1.1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        anchors.horizontalCenter: parent.horizontalCenter

        text: qsTr("Upload picture")

        onClicked: {
            if(wa_PictureUploader.execute() === false)
            {
                messageDialog_Error.text = wa_PictureUploader.lastErrorText();
                messageDialog_Error.visible = true;
                return;
            }

            enabled = false;
        }
    }
}

