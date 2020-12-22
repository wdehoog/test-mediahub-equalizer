import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0

import MediaHubHelper 1.0

MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'testequalizer.wdehoog'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    property var equalizerBands: [0,0,0,0,0,0,0,0,0,0]
    property var modifiedBands: [0,0,0,0,0,0,0,0,0,0]

    property int counter: 0 // signal to update the sliders

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('Test Equalizer')
        }

        ColumnLayout {
            spacing: units.gu(2)
            anchors {
                margins: units.gu(2)
                top: header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            Item {
                Layout.fillHeight: true
            }

            Repeater {
                id: repeater
                model: 10
                Row {         
                    Label {
                        id: label
                        anchors.verticalCenter: parent.verticalCenter
                        text: "" + index
                    }
                    Slider {
                        anchors.verticalCenter: parent.verticalCenter
                        minimumValue: -24
                        maximumValue: 12
                        value: equalizerBands[index]
                        onValueChanged: modifiedBands[index] = value
                        Connections {
                            target: root
                            onCounterChanged: {
                              repeater.itemAt(index).children[1].value = equalizerBands[index]
                            }
                        }
                    }
                }
            }
            Row {
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: i18n.tr('Read')
                    onClicked: {
                        var bandsJson = MediaHubHelper.getEqualizerBands()
                        console.log(bandsJson)
                        var bands = JSON.parse(bandsJson)
                        for(var i=0;i<10;i++) {
                            equalizerBands[i] = bands.bands[i].gain
                            modifiedBands[i] = equalizerBands[i]
                            console.log("read gain[" + i + "]: " + equalizerBands[i])
                        }
                        // counter++
                    }
                }
                Button {
                    Layout.alignment: Qt.AlignHCenter
                    text: i18n.tr('Write')
                    onClicked: {
                        for(var i=0;i<10;i++) {
                            if(equalizerBands[i] != modifiedBands[i]) {
                                console.log("set equalizer band[" + i + "] to " + modifiedBands[i])
                                MediaHubHelper.setEqualizerBand(i, modifiedBands[i])
                                equalizerBands[i] = modifiedBands[i]
                            }
                        }
                    }
                }
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Connections {
        target: MediaHubHelper 
        onEqualizerBandChanged: {
            console.log("onEqualizerBandChanged: " + band + ", " + gain)
            if(band < 0 || band >= 10)
               return
                 
            equalizerBands[band] = gain
            modifiedBands[band] = gain
            counter++
        }
    }

    /*function mydump(arr,level) {
      var dumped_text = "";
      if(!level) level = 0;

      var level_padding = "";
      for(var j=0;j<level+1;j++) level_padding += "    ";

      if(typeof(arr) == 'object') {  
        for(var item in arr) {
          var value = arr[item];

          if(typeof(value) == 'object') { 
            dumped_text += level_padding + "'" + item + "' ...\n";
            dumped_text += mydump(value,level+1);
          } else {
            dumped_text += level_padding + "'" + item + "' => \"" + value + "\"\n";
          }
        }
      } else { 
        dumped_text = "===>"+arr+"<===("+typeof(arr)+")";
      }
      return dumped_text;
    }*/
}
