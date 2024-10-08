/********************************************************************
 *                                                                 *
 * InstaSpots                                                      *
 *                                                                 *
 * Author:       Damiano Lombardi                                  *
 * Created:      05.01.2015                                        *
 *                                                                 *
 * Copiright (c) 2015 Damiano Lombardi                             *
 *                                                                 *
********************************************************************/

// Qt imports ------------------------------
import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

// Project imports -------------------------
import "qrc:/qml/"

Item{
    id: upload_CropPicture
    visible: false

    // Navigation properties ---------------

    property string navigation_Title:                  qsTr("Edit")
    property bool   navigation_BackButtonVisible:      true
    property bool   navigation_ContinueButtonVisible:  true
    property bool   navigation_MenuButtonVisible:      false
    property string navigator_customButtonRightSource: "qrc:/icon/icon/object-rotate-right.png"


    // Properties --------------------------

    property alias cropX:    flick.cropX
    property alias cropY:    flick.cropY
    property alias cropSide: flick.cropSide

    property alias sourceSize: image.sourceSize

    property int   transparentMargin      : 10
    property real  displayAspectRatio     : height / width
    property bool  displayPortrait        : displayAspectRatio > 1.0
    property bool  displayLandscape       : !displayPortrait
    property real  displayUsableSide      : displayPortrait  ? width - 2*transparentMargin : height - 2*transparentMargin
    property int   displayUsablePositionX : displayLandscape ? (width - displayUsableSide)/2  : transparentMargin
    property int   displayUsablePositionY : displayPortrait  ? (height - displayUsableSide)/2 : transparentMargin

    property real  imageAspectRatio   : sourceSize.height / sourceSize.width
    property bool  imagePortrait      : imageAspectRatio > 1.0
    property bool  imageLandscape     : !imagePortrait
    property int   imageDisplayWidth  : imagePortrait  ? displayUsableSide : displayUsableSide / imageAspectRatio
    property int   imageDisplayHeight : imageLandscape ? displayUsableSide : displayUsableSide * imageAspectRatio


    // Signals -----------------------------

    signal cropFinished()


    // Message boxes -----------------------

    MessageDialog{
      id: messageDialog_Error

      title: qsTr('Error')
    }

    // Gui ---------------------------------

    Flickable {
      id: flick

      x: imagePortrait  ? displayUsablePositionX : 0
      y: imageLandscape ? displayUsablePositionY : 0

      width:  imagePortrait  ? displayUsableSide : parent.width
      height: imageLandscape ? displayUsableSide : parent.height

      contentWidth:  imagePortrait  ? imageDisplayWidth  : imageDisplayWidth  + 2 * displayUsablePositionX
      contentHeight: imageLandscape ? imageDisplayHeight : imageDisplayHeight + 2 * displayUsablePositionY


      property real cropX: imagePortrait  ? 0 : contentX / displayUsableSide * sourceSize.height
      property real cropY: imageLandscape ? 0 : contentY / displayUsableSide * sourceSize.width

      property real cropSide: imagePortrait ? sourceSize.width : sourceSize.height

      Image {
        id:image

        x: imagePortrait  ? 0 : displayUsablePositionX
        y: imageLandscape ? 0 : displayUsablePositionY

        width:  imageDisplayWidth
        height: imageDisplayHeight

        cache:    false
        fillMode: Image.Stretch

        MouseArea {
          anchors.fill: parent
          onDoubleClicked: {
            flick.contentWidth  = flick.minimumWidth
            flick.contentHeight = flick.minimumHeight
          }
        }

        Component.onCompleted:
        {
          image.source = wa_PictureUploader.sourcePictureFilename();
        }
      }

//        PinchArea {
//            id: pinchArea
//            width: Math.max(flick.contentWidth, flick.width)
//            height: Math.max(flick.contentHeight, flick.height)

//            function distance(p1, p2) {
//                var dx = p2.x-p1.x;
//                var dy = p2.y-p1.y;
//                return Math.sqrt(dx*dx + dy*dy);
//            }

//            property real initialDistance
//            property real initialContentWidth
//            property real initialContentHeight

//            onPinchStarted: {
//                initialDistance = distance(pinch.point1, pinch.point2);
//                initialContentWidth = flick.contentWidth;
//                initialContentHeight = flick.contentHeight;
//            }

//            onPinchUpdated: {
//                flick.contentX += pinch.previousCenter.x - pinch.center.x
//                flick.contentY += pinch.previousCenter.y - pinch.center.y

//                var currentDistance = distance(pinch.point1, pinch.point2);
//                if(currentDistance < 5)
//                    return;
//                var scale = currentDistance/initialDistance;

//                var newHeight = initialContentHeight*scale
//                var newWidth = initialContentWidth*scale

//                flick.resizeContent(newWidth, newHeight, pinch.center)
//            }

//            onPinchFinished: {
//                var finalWidth = Math.max(flick.contentWidth, flick.minimumWidth)
//                var finalHeight = Math.max(flick.contentHeight, flick.minimumHeight)

//                //Reasure the maximum Scale
//                finalWidth = Math.min(finalWidth, image.sourceSize.width)
//                finalHeight = Math.min(finalHeight, image.sourceSize.height)

//                flick.resizeContent(finalWidth, finalHeight, pinch.center)

//                flick.returnToBounds()
//            }
//        }
    }

    // Semitransparent rectangles
    Rectangle{
      id: rectangle_Semitransparent_Top

      anchors.left:   parent.left
      anchors.right:  parent.right
      anchors.top:    parent.top

      height: displayUsablePositionY

      color:   "gray"
      opacity: 0.8
    }
    Rectangle{
      id: rectangle_Semitransparent_Left

      anchors.left:   parent.left
      anchors.top:    rectangle_Semitransparent_Top.bottom
      anchors.bottom: parent.bottom

      width: displayUsablePositionX

      color:   "gray"
      opacity: 0.8
    }
    Rectangle{
      id: rectangle_Semitransparent_Right

      anchors.right:  parent.right
      anchors.top:    rectangle_Semitransparent_Top.bottom
      anchors.bottom: parent.bottom

      width: displayUsablePositionX

      color:   "gray"
      opacity: 0.8
    }
    Rectangle{
      id: rectangle_Semitransparent_Bottom

      anchors.left:   rectangle_Semitransparent_Left.right
      anchors.right:  rectangle_Semitransparent_Right.left
      anchors.bottom: parent.bottom

      height: displayUsablePositionY

      color:   "gray"
      opacity: 0.8
    }

    Button {
      id: button_Crop
      width: parent.width / 1.1
      anchors.bottom: parent.bottom
      anchors.bottomMargin: 5
      anchors.horizontalCenter: parent.horizontalCenter

      text: qsTr("Crop")

      onClicked: {
        // Set crop image
        if(wa_PictureUploader.setCropPicture(cropX,
                                             cropY,
                                             cropSide)
            === false)
        {
          messageDialog_Error.text = wa_PictureUploader.lastErrorText();
          messageDialog_Error.visible = true;
          return;
        }

        // Push location check page
        stackView.push({item: Qt.resolvedUrl("qrc:/qml/pages-upload/Upload_LocationCheck.qml"),
                         properties:{stackView        : stackView}});
      }
    }

    function navigator_ContinueButtonClicked()
    {
      // Set crop image
      if(wa_PictureUploader.setCropPicture(cropX,
                                           cropY,
                                           cropSide)
          === false)
      {
        messageDialog_Error.text = wa_PictureUploader.lastErrorText();
        messageDialog_Error.visible = true;
        return;
      }

      // Push location check page
      stackView.push({item: Qt.resolvedUrl("qrc:/qml/pages-upload/Upload_LocationCheck.qml"),
                       properties:{stackView        : stackView}});
    }

    function navigator_CustomButtonRightClicked()
    {
      // Rotate picture
      if(wa_PictureUploader.rotatePicture(90) == false)
      {
        messageDialog_Error.text = wa_PictureUploader.lastErrorText();
        messageDialog_Error.visible = true;
        return;
      }

      // Workaround to make the picture reload
      image.source = "qrc:/icon/icon/Wheel-29x29.png";

      // Set new image
      image.source = wa_PictureUploader.sourcePictureFilename();
    }
}

