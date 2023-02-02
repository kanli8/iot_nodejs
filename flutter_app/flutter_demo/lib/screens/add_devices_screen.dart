import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rive/rive.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:google_fonts/google_fonts.dart';

//TEST PAGE
class AddDeviceScreen extends StatefulWidget {
  static const routeName = '/add_device';

  const AddDeviceScreen({Key? key}) : super(key: key);

  @override
  State<AddDeviceScreen> createState() => AddDeviceScreenState();
}

class AddDeviceScreenState extends State<AddDeviceScreen> {
  static const _toJavaPlatform = MethodChannel('com.ankemao.provision');

  static const _todartPlatform = EventChannel('com.ankemao.provision.event');

  String wifiSsid = "";
  String wifiPassword = "";

  // List<Map<String,String>> _scanRes = List<>(12);
  String espLog = "";
  Map<String, String> deviceMap = {};
  Future<void> _scanBle() async {
    try {
      final String result =
          await _toJavaPlatform.invokeMethod('startScanBletoothDevice');
      setState(() {
        espLog = espLog + "\n" + "开始扫描蓝牙" + result;
      });
      //  setState(() {
      //     deviceMap =result as Map<String, String>;
      //   });
    } on PlatformException catch (e) {
      setState(() {
        espLog = espLog + "\n" + "Failed to get scanBle level: '${e.message}'.";
      });
    }
  }

  ///
  /// 输入wifi账号密码
  Future<void> inputwifiInfo() async {
    Map<String, String>? res = await showDialog<Map<String, String>>(
        context: context,
        builder: (BuildContext context) {
          String ssid = "";
          String password = "";
          return SimpleDialog(title: const Text('请输入wifi信息'), children: [
            TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'ssid',
                ),
                onChanged: (String? value) {
                  ssid = value!;
                }),
            TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'password',
                ),
                onChanged: (String? value) {
                  password = value!;
                }),
            TextButton(
                onPressed: () {
                  Map<String, String> info = {};
                  info["ssid"] = ssid;
                  info["password"] = password;
                  Navigator.pop(context, info);
                },
                child: const Text('OK'))
          ]);
        });
    debugPrint("res::::" + res!.toString());
    wifiSsid = res["ssid"] ?? "";
    wifiPassword = res["password"] ?? "";
  }

  /// 自动配网
  // Future<void> _doProving(String uuid) async {
  //     //连接蓝牙
  //     final String result = await
  //     _toJavaPlatform.invokeMethod('connectBleDevices',{"uuid":uuid});
  //     //发送PIN码
  //     await _toJavaPlatform.invokeMethod('sendPINtoBle');
  //     //发送wifi信息
  //     await _sendWifiInfo() ;
  //     setState(() {
  //       espLog=espLog +"\n"+ result ;
  //     });

  // }

  Future<void> _connectBle(String uuid) async {
    final String result =
        await _toJavaPlatform.invokeMethod('connectBleDevices', {"uuid": uuid});
    setState(() {
      espLog = espLog + "\n" + result;
    });
  }

  Future<void> _sendPIN() async {
    await _toJavaPlatform.invokeMethod('sendPINtoBle');
    // setState(() {
    //   espLog=espLog +"\n"+ result ;
    // });
  }

  Future<void> _sendWifiInfo() async {
    await _toJavaPlatform.invokeMethod(
        'sendWifiConfig', {'ssid': "bigtree3", 'password': 'haodayikeshu'});
    // setState(() {
    //   espLog=espLog +"\n"+ result ;
    // });
  }

  @override
  void initState() {
    super.initState();
    _todartPlatform.receiveBroadcastStream().listen(flutterMethod);

    rootBundle.load('assets/rive/ocr-card.riv').then(
      (data) async {
        // Load the RiveFile from the binary data.

        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
      },
    );

    //扫描蓝牙
    _scanBle();
  }

  void flutterMethod(dynamic callData) {
    debugPrint("flutterMethod..." + callData.toString());
    Map callMap = Map<String, Object>.from(callData);
    switch (callMap["methodName"]) {
      case 'deviceListChange':
        setState(() {
          deviceMap = Map<String, String>.from(callMap["data"]);
        });
        setState(() {
          espLog = espLog + "\n" + "原生Android调用了deviceListChange方法！！！";
        });
        break;
      case 'addLog':
        setState(() {
          // espLog=espLog +"\n"+ methodCall.arguments.toString();
          espLog = callMap["data"].toString();
        });
        break;
      case 'stepChange':
        break;
    }
  }

  List<Widget> _listView() {
    List<Widget> res = [];
    deviceMap.forEach((key, value) {
      String name = "连接蓝牙:" + value;
      res.add(
          ElevatedButton(onPressed: () => _connectBle(key), child: Text(name)));
    });
    return res;
    // return  List<Widget>.from(deviceList.asMap().keys.map((e) => Text(list[e]["name"])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topLeft,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("添加设备222",
              textScaleFactor: 3,
              style: TextStyle(
                color: Color.fromARGB(245, 0, 0, 0),
              )),
          const Text("自动搜寻附加设备"),
          ElevatedButton(onPressed: inputwifiInfo, child: const Text("dialog")),

          const Text("请长按设备上的WIFI按键至少5秒"),
          //扫描中的特效
          const SizedBox(
              height: 250,
              child: Center(
                child: RiveAnimation.asset(
                  'assets/rive/ocr-card.riv',
                  // fit: BoxFit.cover,
                  // animations: const ['idle'],
                  // controllers: [SpeedController('curves', speedMultiplier: 3)],
                ),
              )),
          //扫描列表
          SizedBox(height: 100, child: Column(children: _listView())),
          //连接进度
          Center(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isFirst: true,
                  indicatorStyle: const IndicatorStyle(
                    width: 20,
                    color: Color(0xFF27AA69),
                    padding: EdgeInsets.all(6),
                  ),
                  endChild: const _RightChild(
                    asset: 'assets/images/order_placed.png',
                    title: 'Order Placed',
                    message: 'We have received your order.',
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Color(0xFF27AA69),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  indicatorStyle: const IndicatorStyle(
                    width: 20,
                    color: Color(0xFF27AA69),
                    padding: EdgeInsets.all(6),
                  ),
                  endChild: const _RightChild(
                    asset: 'assets/images/order_confirmed.png',
                    title: 'Order Confirmed',
                    message: 'Your order has been confirmed.',
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Color(0xFF27AA69),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  indicatorStyle: const IndicatorStyle(
                    width: 20,
                    color: Color(0xFF2B619C),
                    padding: EdgeInsets.all(6),
                  ),
                  endChild: const _RightChild(
                    asset: 'assets/images/order_processed.png',
                    title: 'Order Processed',
                    message: 'We are preparing your order.',
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Color(0xFF27AA69),
                  ),
                  afterLineStyle: const LineStyle(
                    color: Color(0xFFDADADA),
                  ),
                ),
                TimelineTile(
                  alignment: TimelineAlign.manual,
                  lineXY: 0.1,
                  isLast: true,
                  indicatorStyle: const IndicatorStyle(
                    width: 20,
                    color: Color(0xFFDADADA),
                    padding: EdgeInsets.all(6),
                  ),
                  endChild: const _RightChild(
                    disabled: true,
                    asset: 'assets/images/ready_to_pickup.png',
                    title: 'Ready to Pickup',
                    message: 'Your order is ready for pickup.',
                  ),
                  beforeLineStyle: const LineStyle(
                    color: Color(0xFFDADADA),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  Widget build2(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topCenter,
            child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
              const SizedBox(height: 20, child: Text("Prefix:PROV")),
              const SizedBox(height: 20, child: Text("devices:")),
              SizedBox(height: 100, child: Column(children: _listView())),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: _scanBle, child: const Text("扫描蓝牙"))),
              const SizedBox(height: 20, child: Text("")),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: _sendPIN, child: const Text("发送PIN码"))),
              SizedBox(
                  height: 50,
                  child: ElevatedButton(
                      onPressed: _sendWifiInfo,
                      child: const Text("传输wifi账号密码"))),
              SizedBox(height: 600, child: Text(espLog)),
            ])));
  }
}

class SpeedController extends SimpleAnimation {
  final double speedMultiplier;

  SpeedController(
    String animationName, {
    double mix = 1,
    this.speedMultiplier = 1,
  }) : super(animationName, mix: mix);

  @override
  void apply(RuntimeArtboard artboard, double elapsedSeconds) {
    if (instance == null || !instance!.keepGoing) {
      isActive = false;
    }
    instance!
      ..animation.apply(instance!.time, coreContext: artboard, mix: mix)
      ..advance(elapsedSeconds * speedMultiplier);
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key? key,
    required this.asset,
    required this.title,
    required this.message,
    this.disabled = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            child: Image.asset(asset, height: 50),
            opacity: disabled ? 0.5 : 1,
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                title,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFBABABA)
                      : const Color(0xFF636564),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                message,
                style: GoogleFonts.yantramanav(
                  color: disabled
                      ? const Color(0xFFD5D5D5)
                      : const Color(0xFF636564),
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
