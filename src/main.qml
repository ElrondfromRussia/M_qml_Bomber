import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2

ApplicationWindow {
    title: qsTr("MySAPER")
    id: main_page
    width: 26*size
    height: 26*size + 50
    visible: true
    //flags: Qt.FramelessWindowHint


    property int bombs: 10
    property int size: 9
    property int i_n: 0
    property int j: 0
    property int q: 0
    property int k : 0
    property int field_full: 0

    property var settings_page: null

    property int making: 0

    property string cll_text: ""

    signal check_cell_now(int ind, int filling)
    signal go_new()

    function start_new()
    {
        main_grid.enabled = true
        go_new()
        main_rec.focus = true
    }

    function on_hover_cell(a, st)
    {
        switch(st){
        case 0:
            sap_grid.set(a-1, {"st": "st1"})
            break
        case 1:
            sap_grid.set(a-1, {"st": "st5"})
            break
        }
    }

    function on_set_size(num)
    {
        sap_grid.clear()
        size = num
        for(q = 0; q < size*size; q++)
        {
            sap_grid.append({"a": q+1, "st":"st1" , "t":""})
        }

    }

    function on_set_bombs(num)
    {
        switch(num){
        case -1:
            bombs++;
            bomb_edit.text = bombs
            break
        case -2:
            bombs--;
            bomb_edit.text = bombs
            break
        default:
            bombs = num
            bomb_edit.text = num
            break
        }
    }

    function win()
    {
        for(j = 0; j < sap_grid.count; j++)
        {
            sap_grid.set(j, {"st": "st2"})
            sap_grid.set(j, {"t": ""})
        }
        winrect.visible = true
        main_grid.enabled = false
    }

    function on_reset()
    {
        loserect.visible = false
        winrect.visible = false
        for(j = 0; j < sap_grid.count; j++)
        {
            sap_grid.set(j, {"st": "st1"})
            sap_grid.set(j, {"t": ""})
        }
    }
    function looooser()
    {
        for(q = 0; q < sap_grid.count; q++)
        {
            sap_grid.set(q, {"st": "st3"})
            sap_grid.set(q, {"t": ""})
        }

        loserect.visible = true
        main_grid.enabled = false
    }

    function make_cell_blue(ind)
    {
        if(sap_grid.get(ind-1).st === "st1" || sap_grid.get(ind-1).st === "st5")
        {
            sap_grid.set(ind - 1, {"st": "st4"})
            on_set_bombs(-2)
            check_field()
        }
        else if(sap_grid.get(ind-1).st !== "st3" && sap_grid.get(ind-1).st !== "st2")
        {
            sap_grid.set(ind - 1, {"st": "st5"})
            on_set_bombs(-1)
            //check_field()
        }
    }

    function check_field()
    {
        field_full = 1
        for(q = 0; q < size*size; q++)
        {
            if(sap_grid.get(q).st === "st1")
            {
                field_full = 0
                break
            }
        }
        field_full = field_full*(bombs == 0)

        if(field_full)
            win()
    }

    function on_make_cell(sta, ind)
    {
        if(sta === -1)
        {
            sap_grid.set(ind - 1, {"st": "st3"})
            sap_grid.set(ind - 1, {"t": "*"})
            looooser()
        }
        else if(sta !== "0" )
        {
            sap_grid.set(ind - 1, {"st": "st2"})
            sap_grid.set(ind - 1, {"t": sta})
            check_field()
        }
        else
        {
            sap_grid.set(ind - 1, {"st": "st2"})
            fill_deap_cells(ind)
            check_field()
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////
    function check_right(index)
    {
        if(index % size !== 0)
        {
            check_cell(index + 1, 1)
            if(sap_grid.get(index + 1 - 1).st === "st2" && sap_grid.get(index + 1 - 1).t === "")
            {
                check_right(index + 1)
                check_right_up_dia(index + 1)
                check_right_down_dia(index + 1)
            }
        }
    }
    function check_right_up_dia(index)
    {
        if(index % size !== 0 && index > size)
        {
            check_cell(index - size + 1, 1)
            if(sap_grid.get(index - size + 1 - 1).st === "st2" && sap_grid.get(index - size + 1 - 1).t === "")
            {
                check_right_up_dia(index - size + 1)

                if(index - size + 1 + 1 - 1 > 0  && index - size + 1 + 1 - 1 < size*size)
                    if(sap_grid.get(index - size + 1 + 1 - 1).st === "st1")
                        check_right(index - size + 1)
                if(index - size + 1 - size - 1 > 0  && index - size + 1 - size - 1 < size*size)
                    if(sap_grid.get(index - size + 1 - size - 1).st === "st1")
                        check_up(index - size + 1)
                if(index - size + 1 + size - 1 > 0  && index - size + 1 + size - 1 < size*size)
                    if(sap_grid.get(index - size + 1 + size - 1).st === "st1")
                        check_down(index - size + 1)
                if(index - size + 1 + size + 1 - 1 > 0  && index - size + 1 + size + 1 - 1 < size*size)
                    if(sap_grid.get(index - size + 1 + size + 1  - 1).st === "st1")
                        check_right_down_dia(index - size + 1)
                if(index - size + 1 - size - 1 - 1 > 0  && index - size + 1 - size - 1 - 1 < size*size)
                    if(sap_grid.get(index - size + 1 - size - 1  - 1).st === "st1")
                        check_left_up_dia(index - size + 1)
            }
        }
    }
    function  check_left_up_dia(index)
    {
        if((index-1) % size !== 0 && index > size)
        {
            check_cell(index - size - 1, 1)
            if(sap_grid.get(index - size - 1 - 1).st === "st2" && sap_grid.get(index - size - 1 - 1).t === "")
            {
                check_left_up_dia(index - size - 1)

                if(index - size - 1 - 1 - 1 > 0  && index - size - 1 - 1 - 1 < size*size)
                    if(sap_grid.get(index - size - 1 - 1 - 1).st === "st1")
                        check_left(index - size - 1)
                if(index - size - 1 - size - 1 > 0  && index - size - 1 - size - 1 < size*size)
                    if(sap_grid.get(index - size - 1 - size - 1).st === "st1")
                        check_up(index - size - 1)
                if(index - size - 1 + size - 1 > 0  && index - size - 1 + size - 1 < size*size)
                    if(sap_grid.get(index - size - 1 + size - 1).st === "st1")
                        check_down(index - size - 1)
                if(index - size - 1 + size - 1 - 1 > 0  && index - size - 1 + size - 1 - 1 < size*size)
                    if(sap_grid.get(index - size - 1 + size - 1 - 1).st === "st1")
                        check_left_down_dia(index - size - 1)
                if(index - size - 1 - size + 1 - 1 > 0  && index - size - 1 - size + 1 - 1 < size*size)
                    if(sap_grid.get(index - size - 1 - size + 1 - 1).st === "st1")
                        check_right_up_dia(index - size - 1)
            }
        }
    }
    function check_left(index)
    {
        if((index-1) % size !== 0)
        {
            check_cell(index - 1, 1)
            if(sap_grid.get(index - 1 - 1).st === "st2" && sap_grid.get(index - 1 - 1).t === "")
            {
                check_left(index - 1)
                check_left_down_dia(index - 1)
                check_left_up_dia(index - 1)
            }
        }
    }
    function check_right_down_dia(index)
    {
        if(index % size !== 0 && index <= (size*(size -1)+1))
        {
            check_cell(index + size + 1, 1)
            if(sap_grid.get(index + size + 1 - 1).st === "st2" && sap_grid.get(index + size + 1 - 1).t === "")
            {
                check_right_down_dia(index + size + 1)

                if(index + size + 1 + 1 - 1 > 0  && index + size + 1 + 1 - 1 < size*size)
                    if(sap_grid.get(index + size + 1 + 1 - 1).st === "st1")
                        check_right(index + size + 1)
                if(index + size + 1 + size - 1 > 0  && index + size + 1 + size - 1 < size*size)
                    if(sap_grid.get(index + size + 1 + size - 1).st === "st1")
                        check_down(index + size + 1)
                if(index + size + 1 - size - 1 > 0  && index + size + 1 - size - 1 < size*size)
                    if(sap_grid.get(index + size + 1 - size - 1).st === "st1")
                        check_up(index + size + 1)
                if(index + size + 1 - size + 1 - 1 > 0  && index + size + 1 - size + 1 - 1 < size*size)
                    if(sap_grid.get(index + size + 1 - size + 1 - 1).st === "st1")
                        check_right_up_dia(index + size + 1)
                if(index + size + 1 + size - 1 - 1 > 0  && index + size + 1 + size - 1 - 1 < size*size)
                    if(sap_grid.get(index + size + 1 + size - 1 - 1).st === "st1")
                        check_left_down_dia(index + size + 1)
            }
        }
    }
    function  check_left_down_dia(index)
    {
        if((index-1) % size !== 0 && index <= (size*(size -1)+1))
        {
            check_cell(index + size - 1, 1)
            if(sap_grid.get(index + size - 1 - 1).st === "st2" && sap_grid.get(index + size - 1 - 1).t === "")
            {
                check_left_down_dia(index + size - 1)

                if(index + size - 1 - 1 - 1 > 0  && index + size - 1 - 1 - 1 < size*size)
                    if(sap_grid.get(index + size - 1 - 1 - 1).st === "st1")
                        check_left(index + size - 1)
                if(index + size - 1 + size - 1 > 0  && index + size - 1 + size - 1 < size*size)
                    if(sap_grid.get(index + size - 1 + size - 1).st === "st1")
                        check_down(index + size - 1)
                if(index + size - 1 - size - 1 > 0  && index + size - 1 - size - 1 < size*size)
                    if(sap_grid.get(index + size - 1 - size - 1).st === "st1")
                        check_up(index + size - 1)
                if(index + size - 1 - size - 1 - 1 > 0  && index + size - 1  - size - 1 - 1 < size*size)
                    if(sap_grid.get(index + size - 1  - size - 1 - 1).st === "st1")
                        check_left_up_dia(index + size - 1)
                if(index + size - 1 + size + 1 - 1 > 0  && index + size - 1  + size + 1 - 1 < size*size)
                    if(sap_grid.get(index + size - 1  + size + 1 - 1).st === "st1")
                        check_right_down_dia(index + size - 1)
            }
        }
    }
    function check_up(index)
    {
        if(index > size)
        {
            check_cell(index - size, 1)
            if(sap_grid.get(index - size - 1).st === "st2" && sap_grid.get(index - size - 1).t === "")
            {
                check_up(index - size)
                check_left_up_dia(index - size)
                check_right_up_dia(index - size)
            }
        }
    }
    function check_down(index)
    {
        if(index <= (size*(size -1)+1))
        {
            check_cell(index + size, 1)
            if(sap_grid.get(index + size - 1).st === "st2" && sap_grid.get(index + size - 1).t === "")
            {
                check_down(index  + size)
                check_right_down_dia(index  + size)
                check_left_down_dia(index  + size)
            }
        }
    }
    ////////////////////////////////////////////////////////////////////////////////////////////
    function on_fill_cellsss(sta, ind)
    {
        if(sta !== "0" )
        {
            sap_grid.set(ind - 1, {"st": "st2"})
            sap_grid.set(ind - 1, {"t": sta})
            check_field()
        }
        else
        {
            sap_grid.set(ind - 1, {"st": "st2"})
            check_field()
        }
    }
    function fill_deap_cells(index)
    {
        check_right(index)
        check_right_up_dia(index)
        check_up(index)
        check_left_up_dia(index)
        check_left(index)
        check_left_down_dia(index)
        check_down(index)
        check_right_down_dia(index)
    }

    function check_cell(index, filling)
    {
        check_cell_now(index, filling)
    }

    signal apply_settings(int size, int bombs)

    function setLevel()
    {
        var component = Qt.createComponent("settings.qml");
        if(component.status === Component.Ready)
        {
            var dialog = component.createObject(settings_page,{popupType:1});
            main_page.settings_page = dialog
            dialog.main_page = main_page
            dialog.show()
            dialog.set_current(size, bombs)
        }
    }

    property int pre_x: 0
    property int pre_y: 0

    menuBar: MenuBar {
        Menu {
            title: qsTr("&Game")
            MenuItem {
                text: qsTr("&New game")
                onTriggered: start_new()
            }
            MenuItem {
                text: qsTr("Settings")
                onTriggered: setLevel()
            }
            MenuItem {
                text: qsTr("E&xit")
                onTriggered: Qt.quit();
            }
        }
    }

    MouseArea{
        id: allArea
        anchors.fill: parent
        onPressed: {
            pre_x = mouseX
            pre_y = mouseY
        }
        onMouseXChanged: {
            var dx = mouseX - pre_x
            main_page.setX(main_page.x + dx)
        }
        onMouseYChanged: {
            var dy = mouseY - pre_y
            main_page.setY(main_page.y + dy)
        }
    }

    Rectangle{
        id:main_rec
        anchors.fill: parent
        color: "transparent"
        focus: true


        ListModel{
            id: sap_grid
            dynamicRoles : false
        }

        Component{
            id: sap_cell
            Item{
                id: it
                width: main_grid.cellWidth; height: main_grid.cellHeight
                Rectangle
                {
                    id: recc
                    width: main_grid.cellWidth; height: main_grid.cellHeight;
                    color: (state === "st2") ? "#008400" : ((state === "st3") ? "#ff0000"
                                                                              : ((state === "st4") ? "#0000ff" : "#bbbbbb"));
                    state: st
                    states:[State{name: "st2"},State{name: "st2"},State{name: "st3"},State{name: "st4"},State{name: "st5"}]
                    border.color: "#000000";
                    border.width: 1
                    radius: 4
                    opacity: state === "st5" ? 0.6 : 1
                    TextEdit{
                        id: txt
                        anchors.centerIn: parent
                        visible: parent.state === "st3" || parent.state === "st2"
                        color: "#000000"
                        text: t
                        font.bold: true
                        font.pointSize: parent.height/7*5
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        readOnly: true

                    }
                    MouseArea{
                        anchors.fill: parent;
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        hoverEnabled: true
                        onClicked:
                        {
                            if (mouse.button == Qt.RightButton)
                            {
                                make_cell_blue(a)
                            }
                            else
                            {
                                if(parent.state !== "st4" && parent.state !== "st2")
                                    check_cell(a, 0);
                            }
                        }
                        onHoveredChanged: {
                            if(parent.state === "st1")
                            {
                                on_hover_cell(a, 1)
                            }
                            else if(parent.state === "st5")
                            {
                                on_hover_cell(a, 0)
                            }
                        }
                    }
                }
            }
        }

        Rectangle{
            id: top_rec
            width: parent.width
            height: parent.height / 5
            color: "#eeeeee"
            Image{
                id: img_bomb
                height: parent.height/4*3
                width: parent.height/4*3
                anchors.right: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                source: "qrc:/bomb.png"
            }
            TextEdit{
                id: bomb_edit
                height: parent.height
                width: parent.height/4*3
                anchors.left: parent.horizontalCenter
                font.pointSize: parent.height/4
                font.bold: true
                readOnly: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                text: "0"
            }
            //}
        }

        GridView{
            id: main_grid
            anchors.bottom: parent.bottom
            width: parent.width
            height: parent.height / 5*4
            cellWidth: parent.width/size ;
            cellHeight: (parent.height)/ 5*4 / size
            model: sap_grid
            delegate: sap_cell
        }

        Rectangle{
            id: winrect
            height: parent.height/3
            width: parent.width
            anchors.centerIn: parent
            visible: false
            color: "#cccccc"
            opacity: 0.8
            TextEdit{
                id: win__edit
                height: parent.height
                width: parent.width
                font.pointSize: parent.width/11
                font.bold: true
                readOnly: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#000000"
                text: "You WIN!"
            }
        }
        Rectangle{
            id: loserect
            height: parent.height/3
            width: parent.width
            visible: false
            anchors.centerIn: parent
            color: "#cccccc"
            opacity: 0.8
            TextEdit{
                id: lose__edit
                height: parent.height
                width: parent.width
                font.pointSize: parent.width/11
                font.bold: true
                readOnly: true
                verticalAlignment: Text.AlignVCenter
                horizontalAlignment: Text.AlignHCenter
                color: "#000000"
                text: "You LOOSE!"
            }
        }
    }
}
