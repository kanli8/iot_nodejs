import 'dart:async';
import 'dart:typed_data';
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/widgets.dart';
import 'package:smart_cook/models/device_status.dart';
import 'package:smart_cook/constant/constant.dart';
import 'package:smart_cook/sql/appwirte/client.dart';
import 'package:smart_cook/util/commandPass/pass_command.dart';
import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

///指令解析模板

class WsData {
  static final WsData _instance = WsData._internal();
  bool isAuth = false;
  Map lastRevData = {};
  DeviceStatus deviceStatus = DeviceStatus.getInstance();

  late WebSocketChannel channel;

  WsData._internal();

  static WsData getInstance() {
    return _instance;
  }

  void sendData(dynamic data) {
    if (data is String) {
      // List<int> list =utf8.encode(data);
      List<int> list = data.codeUnits;
      Uint8List bytes = Uint8List.fromList(list);
      channel.sink.add(bytes);
    } else {
      channel.sink.add(Uint8List.fromList(data));
    }
  }

  final controller = StreamController<Map>();

  onData(event) {
    // Map<String, dynamic> map = PassCommand.toMap(event as Uint8List);
    // String temp = "$event \n $map ";
    //如果是应答则修改应答标识，原路返回
    debugPrint("收←◆" + event.toString());
    // deviceStatus.setParams(map);
    // if (map["ask"] == 0x02) {
    //   sendData(PassCommand.toReachUint8List(event));
    // }
    Map<String, dynamic> map = {};
    map['data'] = event;
    controller.sink.add(map);
  }

  onError(err) {
    debugPrint("消息错误$err");
  }

  onDone() {
    isAuth = false;
    //延迟5s 重试
    debugPrint("socket..关闭");
    Future.delayed(const Duration(seconds: 5), connectIot);
  }

  connectIot() {
    // if(true){
    //   return;
    // }

    if (!isAuth) {
      if (userId == '' || sessionId == '') {
        Future.delayed(const Duration(milliseconds: 30), connectIot);
        // Timer(const Duration(seconds: 30), connectIot());
        return;
      }

      channel = WebSocketChannel.connect(
        Uri.parse(iotFontUrl),
        protocols: ["echo-protocol"],
      );

      var mapData = {"user_id": userId, "session_id": sessionId};
      isAuth = true;
      channel.sink.add(json.encode(mapData));
      channel.stream.listen(onData, onError: onError, onDone: onDone);
    }
  }

  Map get lastState {
    return {};
  }

  Stream<Map> get wsData {
    if (!isAuth) {
      connectIot();
    }

    return controller.stream;
  }
}
