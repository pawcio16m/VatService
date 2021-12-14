import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Window 2.15

import Models 1.0

Window {
    width: 440
    height: 700
    minimumWidth: 440
    minimumHeight: 400
    visible: true
    title: qsTr("Vat Calculator")

    Row {
        id: productDetail

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.right: parent.right
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.topMargin: 10
        spacing: 5

        height: 50

        TextField {
            id: productName
            placeholderText: "Product"
            width: 140
            selectByMouse: true
        }

        TextField {
            id: price
            placeholderText: "Price"
            width: 80
            selectByMouse: true
            validator: DoubleValidator {}
        }

        TextField {
            id: vat
            placeholderText: "VAT [%]"
            width: 80
            selectByMouse: true
            validator: IntValidator {}
        }

        Button {
            text: "Add"
            width: 100

            onClicked: {
                productModel.addProduct(productName.text, price.text, vat.text)
            }
        }
    }


    ProductModel {
        id: productModel
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: productDetail.bottom
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
        anchors.topMargin: 10

        color: "lightgreen"
        height: parent.height - productDetail.height

        ListView {
            id: cart
            anchors.fill: parent

            highlight: Rectangle { color: "lightsteelblue"; radius: 5 }
            clip: true
            snapMode: ListView.SnapToItem
            boundsBehavior: Flickable.StopAtBounds

            ScrollBar.vertical: ScrollBar {
                visible: cart.contentHeight > cart.height ? true : false
            }

            footer: Rectangle {
                color: "yellow"

                height: 30
                width: parent.width
                z: 10
                Text {
                    font.pointSize: 12
                    font.bold: true
                    text: "Total VAT: " + productModel.totalVat.toFixed(4)
                }
            }

            footerPositioning: ListView.OverlayFooter
            headerPositioning: ListView.OverlayHeader
            focus: true

            model: productModel
            delegate: Item {
                height: 20
                width: parent.width

                Row {
                    Text {
                        text: modelData_ProductName
                        width: 200
                    }
                    Text {
                        text: modelData_Price.toFixed(2)
                        width: 100
                    }
                    Text {
                        text: modelData_VatValue.toFixed(4)
                        width: 100
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: cart.currentIndex = index
                }
            }

            header:  Rectangle {
                color: "yellow"
                height: 30
                width: parent.width
                z: 10

                Row {
                    anchors.fill: parent

                    Text {
                        text: "Product"
                        width: 200
                        font.pointSize: 12
                    }
                    Text {
                        text: "Price"
                        width: 100
                        font.pointSize: 12
                    }
                    Text {
                        text: "VAT"
                        width: 100
                        font.pointSize: 12
                    }
                }
            }
        }
    }
}
