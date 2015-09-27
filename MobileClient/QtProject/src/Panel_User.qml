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
import QtQuick 2.2
import QtQuick.Controls 1.1

// Project imports -------------------------
import "qrc:/views"
import "qrc:/pages-user"

Rectangle {

    // Pages -------------------------------
    Page_Settings {
        id: page_Settings
        visible: false
    }

    // Slots -------------------------------
    onVisibleChanged: {
        if(visible == false)
            return;


        if(wa_User.isConnected() === false)
        {
            var page_SignIn = Qt.resolvedUrl("qrc:/pages-user/Page_SignIn.qml");
            stackView.push( {item: page_SignIn,
                             immediate: true,
                             replace: false,
                             properties:{width:stackView.width,
                                         height:stackView.height,
                                         stackView:stackView,
                                         navigator:navigator}} );
        }
    }

    Component{
        id: page_ProfileView
        Page_User {

            menuButtonVisible: true

            width: parent.width
            height: parent.height
            stackView:stackView
            navigator: navigator

            onVisibleChanged: {
                if(visible == false)
                    return;

                userId = wa_User.id
            }
        }
    }

    // Gui ---------------------------------
    Navigator{
        id: navigator
        anchors.top: parent.top
        backButtonVisible: stackView.depth > 1

        onPreviousPage: {
            if(stackView.depth > 1)
                stackView.pop();
        }

        onMenuClicked: {
            stackView.push(page_Settings);
            backButtonVisible = true;
        }
    }

    StackView {
        id: stackView
        anchors.top: navigator.bottom
        anchors.bottom: parent.bottom
        // Implements back key navigation
        focus: true
        Keys.onReleased: if (event.key === Qt.Key_Back && stackView.depth > 1) {
                             stackView.pop();
                             event.accepted = true;
                         }
        initialItem: page_ProfileView

        onVisibleChanged: {
            if(visible == true)
            {
                navigator.title = wa_User.username;
            }
        }


        onCurrentItemChanged: {
            if(currentItem == null)
                return;

            navigator.continueButtonVisible = false;
            navigator.menuButtonVisible     = true;
        }
    }
}
