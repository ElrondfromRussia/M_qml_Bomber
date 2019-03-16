import QtQuick 2.0
import QtQuick.Window 2.2
import QtQuick.Layouts 1.2
import QtQuick.Controls 1.4

Window {
    id: settings_page
    width: 200
    height: 200

    property var main_page: null
    property int bombs: 10
    property int size: 9

    function set_current( sizez,  bombss)
    {
        spinBox2.value = sizez
        bombs = bombss
        size = sizez
        spinBox1.value = bombss
    }

    Rectangle {
        id: rectangle1
        color: "#ffffff"
        anchors.fill: parent

        Rectangle {
            id: rect_lay
            anchors.fill: parent

            RowLayout {
                id: rowLayout1
                height: parent.height/3
                width: parent.width
                anchors.top: parent.top

                Label {
                    id: label1
                    text: qsTr("Поле")
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    width: parent.width/2
                    height: parent.height
                    font.bold: true
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                SpinBox {
                    id: spinBox2
                    anchors.right: parent.right
                    height: parent.height
                    minimumValue: 9
                    maximumValue: 30
                    width: parent.width/2
                    font.pointSize: 12
                    value: 9
                }
            }

            RowLayout {
                id: rowLayout2
                height: parent.height/3
                width: parent.width
                anchors.bottom: btn_apply.top
                anchors.top: rowLayout1.bottom

                Label {
                    id: label2
                    text: qsTr("Бомбы")
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    width: parent.width/2
                    height: parent.height
                    font.bold: true
                    font.pointSize: 12
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                }

                SpinBox {
                    id: spinBox1
                    anchors.right: parent.right
                    height: parent.height
                    minimumValue: 10
                    maximumValue: 668
                    width: parent.width/2
                    font.pointSize: 12
                    value: 10
                }
            }

            Rectangle{
                id: btn_apply
                height: parent.height/3
                anchors.bottom: parent.bottom
                width: parent.width
                radius: 5
                color: "#cccccc"
                TextEdit{
                    id: txt
                    anchors.centerIn: parent
                    color: "#000000"
                    text: "Apply"
                    font.bold: true
                    font.pointSize: 16
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    readOnly: true
                }
                MouseArea{
                    anchors.fill: parent;
                    onClicked:
                    {
                        //присвоить значения
                        size = spinBox2.value
                        bombs = spinBox1.value
                        main_page.apply_settings(size,  bombs)
                        settings_page.close()
                    }
                }
            }
        }
    }
}
