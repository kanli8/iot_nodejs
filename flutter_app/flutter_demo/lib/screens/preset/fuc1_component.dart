import 'dart:typed_data';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smart_cook/models/device_status.dart';
import 'package:smart_cook/models/ws_data.dart';
import 'package:smart_cook/constant/constant.dart';
import 'package:convert/convert.dart';

import 'package:smart_cook/main.dart';
import 'package:smart_cook/util/commandPass/pass_command.dart';

class PresetFunc1Component extends StatefulWidget {
  final int mod = 1;
  final String deviceId;
  const PresetFunc1Component({
    Key? key,
    required this.deviceId,
  }) : super(key: key);

  @override
  State<PresetFunc1Component> createState() => _PresetFunc1ComponentState();
}

////
///需要二次确认
////////
class _PresetFunc1ComponentState extends State<PresetFunc1Component> {
  //[22:25:29.249]收←◆
  //[22:27:18.499]发→◇

  String _msgText = '';

  final _editorController = TextEditingController();
  Map<String, dynamic> defaultMap = {
    "mod": 1,
  };
  //variable  ◆  ◇
  @override
  initState() {
    super.initState();
  }

  void _sendMsg() {
    debugPrint(_msgText + "\n" + _editorController.text);

    List<int> deviceList = [];
    List<int> dataList = [];
    String hexStr = _editorController.text.replaceAll(' ', '').trim();
    if (hexStr.isEmpty) {
      return;
    }
    try {
      deviceList = hex.decode(widget.deviceId.trim());
      dataList = hex.decode(hexStr);
    } catch (e) {
      _editorController.clear();
    }

    // WsData.getInstance().sendData(ul);
    //complate msg
    //hex string to uint array

    int len = dataList.length + 12;
    Uint8List list = Uint8List(len);
    list[0] = 0x50;
    list[1] = 0x01;

    for (int i = 0; i < deviceList.length && i < 8; i++) {
      list[2 + i] = deviceList[i];
    }

    //Todo : copy datalist to list
    for (int i = 0; i < dataList.length && i < 8; i++) {
      list[10 + i] = dataList[i];
    }

    //clac crc
    int crc = 0;
    for (int i = 0; i < len - 2; i++) {
      crc += list[i];
    }
    list[len - 2] = crc & 0xff;
    list[len - 1] = 0x0d;

    WsData.getInstance().sendData(list);
    var now = DateTime.now();
    var formatter = DateFormat('HH:mm:ss.SSS');
    String formattedDate = formatter.format(now);
    String sendMsg = '\n[' + formattedDate + ']发→◇' + _editorController.text;

    setState(() {
      _msgText = _msgText + "\n" + sendMsg;
    });
    _editorController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    var txt = TextEditingController();
    txt.text = _msgText;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Consumer<Map>(
        builder: (context, Map wsData, child) {
          if (wsData.isNotEmpty) {
            debugPrint("wsData: " + wsData.toString());
            var now = DateTime.now();
            var formatter = DateFormat('HH:mm:ss.SSS');
            String formattedDate = formatter.format(now);
            String rev =
                '\n[' + formattedDate + ']收←◆' + wsData['data'].toString();
            _msgText = _msgText + rev;
            txt.text = _msgText;
          }

          DeviceStatus ds = DeviceStatus.getInstance();
          if (ds.action == actionWaitUserConfirm) {}
          return SingleChildScrollView(
              child: Column(
            children: <Widget>[
              Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 20,
                      enabled: false, //or null
                      controller: txt,
                      decoration: const InputDecoration.collapsed(
                          hintText: "no message"),
                    ),
                  )),
              Card(
                  color: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 4, //or null
                      controller: _editorController,

                      decoration: const InputDecoration.collapsed(
                          hintText: "Enter your text here"),
                    ),
                  )),
              Center(
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  ElevatedButton(
                    style: style,
                    onPressed: _sendMsg,
                    child: const Text('     send     '),
                  ),
                ]),
              )
            ],
          ));
        },
      ),
    );
  }
}
