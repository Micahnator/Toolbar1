/*
The MIT License (MIT)

Copyright (c) 2013 Micah Losli

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
*/


import QtQuick 2.0
import Ubuntu.Components 0.1
import "components"

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "com.ubuntu.developer.mlosli.Toolbar1"

    /*
     This property enables the application to change orientation
     when the device is rotated. The default is false.
    */
    //automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property int prev_depth
    property int count_up

    Timer {
        id: backDelay
        interval: 1
        onTriggered: pageStack.currentPage.tools.opened = true;
    }

    Timer {
        id: backDelay2
        interval: 2500
        onTriggered: pageStack.currentPage.tools.opened = false;
    }

    Timer {
        id: hintFader
        interval: 40
        onTriggered: {
            if(count_up) {
                hintB.opacity = hintB.opacity + 0.1
                hintFader.start()
            } else {
                hintB.opacity = hintB.opacity - 0.1
                hintFader.start()
            }

            if(hintB.opacity >= 0.7) {
                count_up = false;
            }

            if(hintB.opacity <= 0.0) {
                count_up = true;
                hintFader.stop()
            }
        }
    }

    PageStack {
        id: pageStack
        Component.onCompleted: {
            prev_depth = 1
            push(pageA)
        }

        onCurrentPageChanged: {
            if((prev_depth > pageStack.depth) && (pageStack.depth > 1)) {
                backDelay.start()
                backDelay2.start()
            }
            prev_depth = pageStack.depth

            if(currentPage == pageB) {
                hintFader.start()
            }
        }



        Page {
            id: pageA
            title: i18n.tr("Page A")
            visible: false

            Label {
                id: labelA
                anchors.centerIn: parent
                text: "This is page A!"
            }

            Label {
                id: labelA2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: labelA.bottom
            }

            Button {
                id: buttonA
                text: "Go to Page B"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: units.gu(9)
                onClicked: {
                    pageStack.push(pageB)
                }
            }

            //small and elevated bar toolbar hint
            UbuntuShape {
                id: hintA
                color: UbuntuColors.orange
                visible: (pageA.tools.opened) ? false : true

                width: units.gu(4)
                height: units.gu(0.5)

                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: units.gu(0.5)
            }

            tools: ToolbarItems {
                ToolbarButton {
                    action: Action {
                        text: "button"
                        iconSource: Qt.resolvedUrl("favorite-selected.svg")
                        onTriggered: labelA2.text = "Success!"
                    }
                }
            }
        }




        Page {
            id: pageB
            title: i18n.tr("Page B")
            visible: false

            onVisibleChanged: {
                if(pageB.visible == true) {

                }
            }

            Label {
                id: labelB
                anchors.centerIn: parent
                text: "This is page B!"
            }

            Label {
                id: labelB2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: labelB.bottom
            }

            Button {
                id: buttonB
                text: "Go to Page C"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: units.gu(9)
                onClicked: {
                    pageStack.push(pageC)
                }
            }

            //fading rectangle toolbar hint
            Rectangle {
                id: hintB
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                width: parent.width
                height: units.gu(1.5)

                color: UbuntuColors.orange

                Component.onCompleted: {
                    hintB.opacity = 0.0;
                    count_up = true;
                }
            }


            tools: ToolbarItems {
                ToolbarButton {
                    action: Action {
                        text: "button"
                        iconSource: Qt.resolvedUrl("favorite-selected.svg")
                        onTriggered: labelB2.text = "Success!"
                    }
                }
            }
        }





        Page {
            id: pageC
            title: i18n.tr("Page C")
            visible: false

            Label {
                id: labelC
                anchors.centerIn: parent
                text: "This is page C!"
            }

            Label {
                id: labelC2
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: labelC.bottom
            }

            //constant orange bar toolbar hint
            Rectangle {
                id: hintC
                anchors {
                    bottom: parent.bottom
                    left: parent.left
                    right: parent.right
                }
                width: parent.width
                height: units.gu(0.5)
                color: UbuntuColors.orange
            }

            tools: ToolbarItems {
                ToolbarButton {
                    action: Action {
                        text: "button"
                        iconSource: Qt.resolvedUrl("favorite-selected.svg")
                        onTriggered: labelC2.text = "Success!"
                    }
                }
            }
        }
    }
}
