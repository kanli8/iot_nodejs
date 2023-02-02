import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:convert' as convert;

///
///此版本 - version 字段无效
///
class PassCommand {
  static const int headerIndex = 0;
  static const int headerLength = 1;

  static const int versionIndex = 1;
  static const int versionLength = 1;

  static const int deviceIdIndex = 2;
  static const int deviceIdLength = 4;

  static const int funcIndex = 6;
  static const int funcLength = 2;

  static const int serialsIndex = 8;
  static const int serialsLength = 2;

  static const int reservedIndex = 10;
  static const int reservedLength = 2;

  static const int lengthIndex = 12;
  static const int lengthLength = 2;

  static int downSerialNum = 0;

  static const int dataHeaderLength = 14;

  static List<Map<String, dynamic>> modelList = [];

  static void loadModelJson() async {
    String jsonListStr =
        await rootBundle.loadString('assets/model/modelList.json');
    List<dynamic> jsonList = convert.jsonDecode(jsonListStr);
    const JsonDecoder decoder = JsonDecoder();
    for (String fileName in jsonList) {
      String jsonStr = await rootBundle.loadString('assets/model/' + fileName);
      final Map<String, dynamic> map = decoder.convert(jsonStr);
      modelList.add(map);
    }
  }

  static Map<String, dynamic> getModel(int version, int modelId) {
    if (modelList.isEmpty) {
      loadModelJson();
    }
    for (var item in modelList) {
      if (item["version"] == version && item["model_id"] == modelId) {
        return item;
      }
    }
    return {};
  }

  static int byteArrayToInt(Uint8List data, int startIndex, int len) {
    int sum = 0;
    for (int i = 0; i < len; i++) {
      sum = sum + (data[startIndex + i] << (8 * (len - i - 1)));
    }
    return sum;
  }

  //过短len 会被截取掉
  static Uint8List intTobyteArray(int ii, int len) {
    List<int> tlist = List.filled(len, 0);
    Uint8List list = Uint8List.fromList(tlist);
    for (int i = 0; i < len; i++) {
      int mv = (len - 1 - i) * 8;
      list[i] = ii >> mv;
    }
    return list;
  }

  ///
  ///
  ///
  static Map<String, dynamic> toMap(Uint8List data) {
    ///
    ///固定头0 0x50|版本号1 1byte|模板号2 1byte|消息序号3 2byte|
    ///iot预留5 2byte|消息长度(2位)7 2byte|消息体9 nbyte|校验位 1byte|固定尾0X4C
    ///
    ///
    //头尾校验
    if (data[headerIndex] != 0x50 || data[data.length - 1] != 0x4C) {
      debugPrint("header or last is error");
      return {"err": "header or last is error", "rData": data.toString()};
    }

    //长度校验
    int len = byteArrayToInt(data, lengthIndex, lengthLength);
    if (len != data.length) {
      debugPrint("len error: $len ${data.length}");
      return {
        "err": "len error: $len ${data.length}",
        "rData": data.toString()
      };
    }

    //校验位校验
    int sum = 0;
    for (int i = 0; i < data.length - 2; i++) {
      sum = sum + data[i];
    }
    sum = Uint8List.fromList([sum])[0];
    if (sum != data[data.length - 2]) {
      debugPrint(
          "check value is error, sum is $sum -- cv is ${data[data.length - 2]}");
      // return {"rData":data.toString()};
    }

    //加载模板json
    int version = data[versionIndex];
    int modelId = byteArrayToInt(data, funcIndex, funcLength);
    Map<String, dynamic> model = getModel(version, modelId);
    Map<String, dynamic> params = model["params"] ?? {};
    Map<String, dynamic> reMap = {};

    //填充值
    params.forEach((key, value) {
      //  " start_index":4 ,
      //       "length":1
      int startIndex = (value["start_index"] ?? 0) + dataHeaderLength;
      int length = value["length"] ?? 0;
      int nv = byteArrayToInt(data, startIndex, length);
      reMap[key] = nv;
    });
    //deviceId 填充
    int deviceId = byteArrayToInt(data, 2, 4);
    reMap['deviceId'] = deviceId;
    //消息类型填充
    //应答标识
    int ask = (data[11] & 0x03);
    reMap['ask'] = ask;
    //答复标识
    bool isReach = ((data[11] & 0x04) > 0);
    reMap['isReach'] = isReach;
    return reMap;
  }

  static Uint8List toReachUint8List(Uint8List data) {
    //修改
    data[11] = 0x04;
    return data;
  }

  static Uint8List assembleUint8List(String deviceId, Uint8List data) {
    int len = data.length + 10;
    Uint8List list = Uint8List(len);
    //header
    list[0] = 0x50;
    //data

    //cv

    return data;
  }

  /// 复用下行指令
  /// {mod: 2, p1: 99, p2: 1024, t1: 88, t2: 369, rid: 10001, step: 4,
  /// pg: 35, rt: 1200, progess_time: 1662280593, status: 1}
  ///
  ///
  static Uint8List toUint8List(
      int version, int modelId, Map<String, dynamic> map, int msgType) {
    Map<String, dynamic> model = getModel(version, modelId);

    int len = model["command_len"];
    //初始化
    List<int> tlist = List.filled(len, 0);
    Uint8List list = Uint8List.fromList(tlist);

    //header
    list[headerIndex] = 0x50;

    //ver
    list[versionIndex] = 0x01;
    //device_id 先固定为1
    list[deviceIdIndex] = 0x00;
    list[deviceIdIndex + 1] = 0x00;
    list[deviceIdIndex + 2] = 0x00;
    list[deviceIdIndex + 3] = 0x01;
    //fid 固定为2
    list[funcIndex] = 0x00;
    list[funcIndex + 1] = 0x02;
    //serial 固定为1
    downSerialNum++;
    if (downSerialNum >= 65535) {
      downSerialNum = 0;
    }
    Uint8List serailUi8 = intTobyteArray(downSerialNum, 2);
    list[serialsIndex] = serailUi8[0];
    list[serialsIndex + 1] = serailUi8[1];
    //预留 固定为0
    list[reservedIndex] = 0x00;
    //消息类型
    list[reservedIndex + 1] = msgType;

    //len 固定为36
    Uint8List lenUi8 = intTobyteArray(len, lengthLength);
    list[lengthIndex] = lenUi8[0];
    list[lengthIndex + 1] = lenUi8[1];

    //last
    list[len - 1] = 0x4C;
    Map<String, dynamic> params = model["params"] ?? {};
    //填充值
    params.forEach((key, value) {
      //  " start_index":4 ,
      //       "length":1
      int startIndex = (value["start_index"] ?? 0) + dataHeaderLength;
      int length = value["length"] ?? 0;
      if (map[key] == null) {
        return;
      }
      int rel = map[key];

      Uint8List v = intTobyteArray(rel, length);
      for (int i = 0; i < length; i++) {
        list[startIndex + i] = v[i];
      }
    });

    //校验位
    int sum = 0;
    for (int i = 0; i < list.length; i++) {
      sum = sum + list[i];
    }

    Uint8List cvUi8 = intTobyteArray(sum, 3);
    list[list.length - 2] = cvUi8[2];

    return list;
  }
}
