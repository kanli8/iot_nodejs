import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rive/rive.dart';
import 'package:smart_cook/theme/MySize.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:smart_cook/sql/appwirte/database.dart';
import 'dart:typed_data';

const routeRequestPermissionPage = 'request_permission';
const routeDeviceHowToPage = 'device_howto';
const routeFindDevicePage = 'find_devices';
const routeInputWifiInfoPage = 'input_wifi_info';
const routeProvFlowPage = 'prov_flow';
const routeDeviceSetupFinishedPage = 'finished';

const _toJavaPlatform = MethodChannel('com.ankemao.provision');

const _todartPlatform = EventChannel('com.ankemao.provision.event');

@immutable
class AddDeviceFlow extends StatefulWidget {
  static const routeName = '/add_device_flow';

  static AddDeviceFlowState of(BuildContext context) {
    return context.findAncestorStateOfType<AddDeviceFlowState>()!;
  }

  const AddDeviceFlow({
    Key? key,
    required this.setupPageRoute,
  }) : super(key: key);

  final String setupPageRoute;

  @override
  AddDeviceFlowState createState() => AddDeviceFlowState();
}

class AddDeviceFlowState extends State<AddDeviceFlow> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  String deviceKey = "";
  String deviceName = "";
  String wifiSsid = "";
  String wifiPassword = "";

  @override
  void initState() {
    super.initState();
  }

  void _onRequestPermission() {
    _navigatorKey.currentState!.pushNamed(routeDeviceHowToPage);
  }

  void _onDeviceHowTo() {
    _navigatorKey.currentState!.pushNamed(routeFindDevicePage);
  }

  void _onDeviceSelected(Map<String, String> deviceInfo) {
    deviceKey = deviceInfo['key'] ?? "";
    deviceName = deviceInfo['value'] ?? "";
    _navigatorKey.currentState!.pushNamed(routeInputWifiInfoPage);
  }

  void _onInputWifiInfo(Map<String, String> wifiInfo) {
    wifiSsid = wifiInfo["ssid"] ?? "";
    wifiPassword = wifiInfo["password"] ?? "";
    _navigatorKey.currentState!.pushNamed(routeProvFlowPage);
  }

  void _onFinish() {
    _exitSetup();
  }

  Future<void> _onExitPressed() async {
    final isConfirmed = await _isExitDesired();

    if (isConfirmed && mounted) {
      _exitSetup();
    }
  }

  Future<bool> _isExitDesired() async {
    return await showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Are you sure?'),
                content: const Text(
                    'If you exit device setup, your progress will be lost.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text('Leave'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('Stay'),
                  ),
                ],
              );
            }) ??
        false;
  }

  void _exitSetup() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _isExitDesired,
      child: Scaffold(
        appBar: _buildFlowAppBar(),
        body: Navigator(
          key: _navigatorKey,
          initialRoute: widget.setupPageRoute,
          onGenerateRoute: _onGenerateRoute,
        ),
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case routeRequestPermissionPage:
        page = RequestPermissionPage(
          onRequestPermission: _onRequestPermission,
        );
        break;
      case routeDeviceHowToPage:
        page = DeviceHowToPage(
          onDeviceHowTo: _onDeviceHowTo,
        );
        break;
      case routeFindDevicePage:
        page = FindDevicePage(
          onDeviceSelected: _onDeviceSelected,
        );
        break;
      case routeInputWifiInfoPage:
        page = InputWifiInfoPage(
          onInputWifiInfo: _onInputWifiInfo,
        );
        break;
      case routeProvFlowPage:
        page = ProvFlowPage(
          onFinish: _onFinish,
          deviceKey: deviceKey,
          deviceName: deviceName,
          wifiPassword: wifiPassword,
          wifiSsid: wifiSsid,
        );
        break;
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }

  PreferredSizeWidget _buildFlowAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _onExitPressed,
        icon: Icon(
          Icons.chevron_left,
          color: MySize.purpleDark,
        ),
      ),
      title: Text('设备配网', style: TextStyle(color: MySize.purpleDark)),
      elevation: 0,
    );
  }
}

///
///请求权限 start///////////////
///
class RequestPermissionPage extends StatefulWidget {
  final VoidCallback onRequestPermission;
  const RequestPermissionPage({
    Key? key,
    required this.onRequestPermission,
  }) : super(key: key);

  @override
  State<RequestPermissionPage> createState() => _RequestPermissionPageState();
}

class _RequestPermissionPageState extends State<RequestPermissionPage> {
  bool hasPPermissions = false;

  String statusText = "正在检查权限....";
  @override
  void initState() {
    super.initState();
    _todartPlatform.receiveBroadcastStream().listen(flutterMethod);
    _checkPermissions();
  }

  Widget buildBottomSheetWidget(
      BuildContext context, String text, VoidCallback onOk) {
    //弹框中内容  310 的调试
    return SizedBox(
      height: MySize.size64 - 100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: Theme.of(context).textTheme.headline6,
          ),
          ElevatedButton(
            onPressed: onOk,
            child: const Text(
              'OK',
              style: TextStyle(
                fontSize: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void flutterMethod(dynamic callData) {
    debugPrint("flutterMethod..." + callData.toString());
    Map callMap = Map<String, Object>.from(callData);
    switch (callMap["methodName"]) {
      case 'openBleCallback':
        setState(() {
          statusText = "openBleCallback..." + callMap["data"].toString();
        });
        break;
    }
  }

  //请求定位权限
  Future<void> _requestLocalPermissions() async {
    final status = await Permission.location.request();
    if (status == PermissionStatus.granted) {
      //检查蓝牙是否打开
      _enableBluetooth();
    } else {
      setState(() {
        statusText = "无法获得定位权限，系统无法进行配网操作，您可以前往设置，手动打开定位权限后，点击返回并重试";
      });
    }
  }

  //请求打开蓝牙
  Future<void> _enableBluetooth() async {
    if (!await _toJavaPlatform.invokeMethod("checkblutoothStatus")) {
      bool isOpen = await _toJavaPlatform.invokeMethod("requestOpenBluetooth");
      debugPrint("_enableBluetooth isOpen:::" + isOpen.toString());
      if (isOpen) {
        widget.onRequestPermission();
      } else {
        setState(() {
          statusText = "无法打开蓝牙，系统无法进行配网操作，您可以前往设置，手动打开蓝牙后，点击返回并重试";
        });
      }
    } else {
      //符合权限，跳转到扫描
      widget.onRequestPermission();
    }
  }

  Future<void> _checkPermissions() async {
    // await Future<dynamic>.delayed(const Duration(seconds: 4));
    //  final bool result = await _to_java_platform.invokeMethod('checkLocalPermission');
    //  print("checkLocalPermission result:::" + result.toString()) ;

    if (!await Permission.location.isGranted) {
      String textLocal = """
     在使用本应用前，需要您授权定位权限，以便系统能够进行设备配网操作。
      """;
      showModalBottomSheet(
          builder: (BuildContext context) {
            //构建弹框中的内容
            return buildBottomSheetWidget(
                context, textLocal, _requestLocalPermissions);
          },
          context: context);
    } else {
      _enableBluetooth();
    }

    //检查蓝牙状态
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 32),
              Text(statusText),
            ],
          ),
        ),
      ),
    );
  }
}

///
///请求权限end///////////////
///

///
///设备侧操作教程 start///////////////
///
class DeviceHowToPage extends StatefulWidget {
  const DeviceHowToPage({
    Key? key,
    required this.onDeviceHowTo,
  }) : super(key: key);
  final VoidCallback onDeviceHowTo;
  @override
  State<DeviceHowToPage> createState() => _DeviceHowToPageState();
}

class _DeviceHowToPageState extends State<DeviceHowToPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/device_how_to_1.png'),
              const Text("请打开设备，将手机靠近设备，然后点击下一步"),
              ElevatedButton(
                onPressed: () {
                  widget.onDeviceHowTo();
                },
                child: const Text(
                  '下一步',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DeviceHowTo2Page extends StatefulWidget {
  const DeviceHowTo2Page({
    Key? key,
    required this.onDeviceHowTo,
  }) : super(key: key);
  final VoidCallback onDeviceHowTo;
  @override
  State<DeviceHowTo2Page> createState() => _DeviceHowTo2PageState();
}

class _DeviceHowTo2PageState extends State<DeviceHowTo2Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/device_how_to_2.png',
                  width: MySize.size60,
                  height: MySize.size60,
                  fit: BoxFit.fill),
              const Text("请长按设备上的“WIFI”键，直到设备上的“WIFI”键开始闪烁，然后点击下一步"),
              ElevatedButton(
                onPressed: () {
                  widget.onDeviceHowTo();
                },
                child: const Text(
                  '下一步',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

///
///设备侧操作教程end///////////////
///

///
///搜索设备start
///
class FindDevicePage extends StatefulWidget {
  final void Function(Map<String, String>) onDeviceSelected;
  const FindDevicePage({
    Key? key,
    required this.onDeviceSelected,
  }) : super(key: key);

  @override
  State<FindDevicePage> createState() => _FindDevicePageState();
}

class _FindDevicePageState extends State<FindDevicePage> {
  Map<String, String> deviceMap = {};
  bool isScanComplate = false;
  @override
  void initState() {
    super.initState();
    //添加监听
    _todartPlatform.receiveBroadcastStream().listen(flutterMethod);
    //开始扫描蓝牙
    _scanBle();
  }

  //扫描蓝牙
  Future<void> _scanBle() async {
    try {
      await _toJavaPlatform.invokeMethod('startScanBletoothDevice');
    } on PlatformException catch (e) {
      debugPrint(e.message);
    }
  }

  //监听蓝牙回调
  void flutterMethod(dynamic callData) {
    debugPrint("flutterMethod..." + callData.toString());
    Map callMap = Map<String, Object>.from(callData);
    switch (callMap["methodName"]) {
      case 'deviceListChange':
        setState(() {
          deviceMap = Map<String, String>.from(callMap["data"]);
          isScanComplate = true;
        });
        break;
      case 'scanCompleted':
        setState(() {
          isScanComplate = true;
        });
        break;
    }
  }

  Widget loading(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topLeft,
            child: Center(
              child: Column(children: const [
                Text("自动搜寻附加设备"),
                SizedBox(
                    height: 250,
                    child: Center(
                      child: RiveAnimation.asset(
                        'assets/rive/ocr-card.riv',
                        // fit: BoxFit.cover,
                        // animations: const ['idle'],
                        // controllers: [SpeedController('curves', speedMultiplier: 3)],
                      ),
                    )),
              ]),
            )));
  }

  List<Widget> _listView() {
    List<Widget> res = [];
    deviceMap.forEach((key, value) {
      String name = "连接蓝牙:" + value;
      res.add(ElevatedButton(
          onPressed: () {
            Map<String, String> select = {};
            select["key"] = key;
            select["value"] = value;
            widget.onDeviceSelected(select);
          },
          child: Text(name)));
    });
    return res;
    // return  List<Widget>.from(deviceList.asMap().keys.map((e) => Text(list[e]["name"])));
  }

  Widget showResultList(BuildContext context) {
    return deviceMap.isEmpty
        ? noDevice(context)
        : Scaffold(
            body: Container(
                alignment: Alignment.topLeft,
                child: Center(
                  child: Column(children: _listView()),
                )));
  }

  Widget noDevice(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topLeft,
            child: Center(
              child: Column(children: [
                const Text("未找到设备，你可以点击按钮后重新扫描"),
                ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isScanComplate = false;
                      });
                      _scanBle();
                    },
                    child: const Text("重新扫描"))
              ]),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return isScanComplate ? showResultList(context) : loading(context);
  }
}

///
///搜索设备end///////////////////////////
///

///

///
///wifi 信息输入 start///////////////
///
class InputWifiInfoPage extends StatefulWidget {
  final void Function(Map<String, String>) onInputWifiInfo;
  const InputWifiInfoPage({
    Key? key,
    required this.onInputWifiInfo,
  }) : super(key: key);

  @override
  State<InputWifiInfoPage> createState() => _InputWifiInfoPageState();
}

class _InputWifiInfoPageState extends State<InputWifiInfoPage> {
  String ssid = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            alignment: Alignment.topLeft,
            child: Center(
              child: Column(children: [
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
                      widget.onInputWifiInfo(info);
                    },
                    child: const Text('下一步'))
              ]),
            )));
  }
}

///
///wifi 信息输入end///////////////
///

///
///配网进度 start///////////////
///
class ProvFlowPage extends StatefulWidget {
  final VoidCallback onFinish;

  final String deviceKey;
  final String deviceName;
  final String wifiSsid;
  final String wifiPassword;

  const ProvFlowPage({
    Key? key,
    required this.onFinish,
    required this.deviceKey,
    required this.deviceName,
    required this.wifiSsid,
    required this.wifiPassword,
  }) : super(key: key);

  @override
  State<ProvFlowPage> createState() => _ProvFlowPageState();
}

class _ProvFlowPageState extends State<ProvFlowPage> {
  static const int eventDeviceConnected = 1;
  static const int eventDeviceConnectionFailed = 2;
  static const int eventDeviceDisconnected = 3;

  static const int createSessionFailed = 1;
  static const int wifiConfigSent = 2;
  static const int wifiConfigFailed = 3;
  static const int wifiConfigApplied = 4;
  static const int wifiConfigApplyFailed = 5;

  static const int provisioningFailedAuthFailed = 6;
  static const int provisioningFailedNetworkNotFound = 7;
  static const int provisioningFailedDeviceDisconnected = 8;
  static const int provisioningFailedUnknown = 9;

  static const int deviceProvisioningSuccess = 10;
  static const int onProvisioningFailed = 11;

  int _provStep = 0;
  String connectText = "";
  String wifiText = "";
  String checkText = "";
  String addDeviceText = "";
  Uint8List _dataByte = Uint8List(0);
  bool isFinish = false;

  ///
  ///步骤流程
  /// step 1: 连接蓝牙
  /// step 2: 发送pin码
  /// step 2.1: get device id and peer code
  /// step 3： 发送wifi信息
  /// step 3.1: wifi信息被接收
  /// step 3.2: 应用wifi配置
  /// step 3.3: 网络配置失败即原因
  /// step 3.4: 网络配置成功
  /// step 4.1: get device online status
  ///
  ///

  @override
  void initState() {
    super.initState();
    _todartPlatform.receiveBroadcastStream().listen(flutterMethod);
    connectBle();
  }

  ///
  ///连接蓝牙
  ///
  void connectBle() async {
    await _toJavaPlatform
        .invokeMethod('connectBleDevices', {"uuid": widget.deviceKey});
  }

  ///
  ///发送PIN码
  ///
  void sendPIN() async {
    await _toJavaPlatform.invokeMethod('sendPINtoBle');
  }

  ///get peer code and device id
  void getDeviceIdAndPeerCode() async {
    await _toJavaPlatform.invokeMethod<String>('getPeerCode');
  }

  ///send wifi config
  void sendWifiConfig() {
    _toJavaPlatform.invokeMethod('sendWifiConfig',
        {'ssid': widget.wifiSsid, 'password': widget.wifiPassword});
  }

  void _insertDevice() async {
    //insert into appwrite
    debugPrint("insert into appwrite");
    debugPrint("dataByte: $_dataByte");
    if (_dataByte.isEmpty) {
      return;
    }
    //deviceId byte array
    Uint8List deviceId = _dataByte.sublist(0, 8);
    //model byte array
    Uint8List model = _dataByte.sublist(8, 12);
    //change model high and low byte
    Uint8List modelChange = Uint8List(4);
    modelChange[0] = model[3];
    modelChange[1] = model[2];
    modelChange[2] = model[1];
    modelChange[3] = model[0];

    //deviceId byte array to hex string
    String deviceIdHex =
        deviceId.buffer.asByteData().getUint64(0).toRadixString(16);
    //model byte array to int
    int modelInt = modelChange.buffer.asByteData().getUint32(0);

    String id = deviceIdHex;
    int modelId = modelInt;
    debugPrint("id: $id");
    debugPrint("modelId: $modelId");
    addnewUserDevice(id, modelId, onLoading: () {
      setState(() {
        addDeviceText = "正在添加设备";
      });
    }, onSuccess: () {
      setState(() {
        addDeviceText = "添加设备成功";
        _provStep = 4;
        isFinish = true;
      });
    }, onError: (msg) {
      debugPrint("add device error: $msg");
      setState(() {
        addDeviceText = "添加设备失败:" + msg;
      });
    });
  }

  ///
  ///事件监听
  ///
  void flutterMethod(dynamic callData) {
    Map callMap = Map<String, Object>.from(callData);
    debugPrint('flutterMethod...' + callMap.toString());
    if (_provStep >= 3) {
      return;
    }
    switch (callMap["methodName"]) {
      case 'bleConnectCallback':
        int reCode = callMap["data"];
        if (reCode == eventDeviceConnected) {
          //开始传输PIN

          setState(() {
            connectText = "蓝牙连接成功";
            _provStep = 1;
          });
          Future.delayed(const Duration(seconds: 2), sendPIN);
          // sendPIN();
        } else if (reCode == eventDeviceConnectionFailed) {
          //连接失败
          setState(() {
            connectText = "蓝牙连接失败,请返回并重试";
          });
        } else if (reCode == eventDeviceDisconnected) {
          //连接被断开
          setState(() {
            connectText = "蓝牙异常中断,请返回并重试";
          });
        }
        break;
      case 'sendPinCallback':
        int reCode = callMap["data"];
        if (reCode == 0) {
          //SUCCESS
          getDeviceIdAndPeerCode();
          // Future.delayed(const Duration(seconds: 2), getDeviceIdAndPeerCode);
          //sendWifiConfig();
        } else {
          //FAIL
          setState(() {
            connectText = "无法识别的蓝牙设备,请返回并重试";
          });
          // Future.delayed(const Duration(seconds :2),sendWifiConfig);
          // sendWifiConfig();
        }
        break;
      case "getPeerCallback":
        Uint8List dataByte = callMap["data"];

        if (dataByte.isEmpty) {
          setState(() {
            connectText =
                "device communication is error ,please go back and try agan";
          });
        }

        setState(() {
          _dataByte = dataByte;
          _provStep = 2;
          connectText = 'device info: ' + dataByte.toString();
        });
        debugPrint('device info: ' + dataByte.toString());
        sendWifiConfig();
        break;
      case 'sendWifiCallback':
        int reCode = callMap["data"];
        switch (reCode) {
          case createSessionFailed:
            setState(() {
              connectText = "蓝牙通讯失败,请返回并重试";
            });
            break;
          case wifiConfigSent:
            setState(() {
              wifiText = "wifi信息发送已发送";
            });
            break;
          case wifiConfigFailed:
            setState(() {
              wifiText = "wifi信息发送失败,请返回并重试";
            });
            break;
          case wifiConfigApplied:
            setState(() {
              wifiText = "wifi信息已被接收";
            });
            break;
          case wifiConfigApplyFailed:
            setState(() {
              wifiText = "wifi信息接收失败";
            });
            break;
          case provisioningFailedAuthFailed:
            setState(() {
              wifiText = "ssid密码错误";
            });
            break;
          case provisioningFailedNetworkNotFound:
            setState(() {
              wifiText = "未找到指定网络";
            });
            break;
          case provisioningFailedDeviceDisconnected:
            setState(() {
              wifiText = "wifi异常断开";
            });
            break;
          case provisioningFailedUnknown:
            setState(() {
              wifiText = "未知错误，请返回重试";
            });
            break;
          case deviceProvisioningSuccess:
            setState(() {
              connectText = "配网成功";
              _provStep = 3;
            });
            _insertDevice();
            break;
          case onProvisioningFailed:
            setState(() {
              wifiText = "配网失败";
            });
            break;
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.topLeft,
      child: ListView(shrinkWrap: true, children: <Widget>[
        //蓝牙连接
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isFirst: true,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: (_provStep == 0
                ? const Color(0xFF2B619C)
                : _provStep > 0
                    ? const Color(0xFF27AA69)
                    : const Color(0xFFD8D8D8)),
            padding: const EdgeInsets.all(6),
          ),
          endChild: _RightChild(
            asset: 'assets/images/bluetooth_peer.png',
            title: '蓝牙配对',
            message: connectText,
            isDoing: _provStep == 0,
          ),
          // beforeLineStyle: const LineStyle(
          //   color: Color(0xFF27AA69),
          // ),
          afterLineStyle: LineStyle(
            color: _provStep > 0
                ? const Color(0xFF27AA69)
                : const Color(0xFFDADADA),
          ),
        ),
        //wifi配网
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: (_provStep == 1
                ? const Color(0xFF2B619C)
                : _provStep > 1
                    ? const Color(0xFF27AA69)
                    : const Color(0xFFD8D8D8)),
            padding: const EdgeInsets.all(6),
          ),
          endChild: _RightChild(
            asset: 'assets/images/order_confirmed.png',
            title: '发送wi-fi 信息',
            message: wifiText,
            isDoing: _provStep == 1,
          ),
          beforeLineStyle: LineStyle(
            color: _provStep > 0
                ? const Color(0xFF27AA69)
                : const Color(0xFFDADADA),
          ),
          afterLineStyle: LineStyle(
            color: _provStep > 1
                ? const Color(0xFF27AA69)
                : const Color(0xFFDADADA),
          ),
        ),
        //配网成功
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: (_provStep == 2
                ? const Color(0xFF2B619C)
                : _provStep > 2
                    ? const Color(0xFF27AA69)
                    : const Color(0xFFD8D8D8)),
            padding: const EdgeInsets.all(6),
          ),
          endChild: _RightChild(
            asset: 'assets/images/checkWifi.png',
            title: '检查配网状态',
            message: checkText,
            isDoing: _provStep == 2,
          ),
          beforeLineStyle: LineStyle(
            color: _provStep > 1
                ? const Color(0xFF27AA69)
                : const Color(0xFFDADADA),
          ),
          afterLineStyle: LineStyle(
            color: _provStep > 2
                ? const Color(0xFF27AA69)
                : const Color(0xFFDADADA),
          ),
        ),
        //添加设备
        TimelineTile(
          alignment: TimelineAlign.manual,
          lineXY: 0.1,
          isLast: true,
          indicatorStyle: IndicatorStyle(
            width: 20,
            color: (_provStep == 3
                ? const Color(0xFF2B619C)
                : _provStep > 3
                    ? const Color(0xFF27AA69)
                    : const Color(0xFFD8D8D8)),
            padding: const EdgeInsets.all(6),
          ),
          endChild: _RightChild(
            disabled: true,
            asset: 'assets/images/addDevice.png',
            title: '添加设备到列表',
            message: addDeviceText,
            isDoing: _provStep == 3,
          ),
          beforeLineStyle: LineStyle(
            color: _provStep > 2
                ? const Color(0xFF27AA69)
                : const Color(0xFFDADADA),
          ),
        ),
        //test button
        // Container(
        //   margin: EdgeInsets.only(top: 20),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        //     children: <Widget>[
        //       ElevatedButton(
        //         child: Text('发送wifi信息'),
        //         onPressed: () {
        //           sendWifiConfig();
        //         },
        //       ),
        //       ElevatedButton(
        //         child: Text('添加设备到列表'),
        //         onPressed: () {
        //           _insertDevice();
        //         },
        //       ),
        //     ],
        //   ),
        // ),
        //if finish show finish button
        isFinish
            ? Container(
                margin: const EdgeInsets.only(top: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ElevatedButton(
                      child: const Text('恭喜完成配网，点击返回'),
                      onPressed: () {
                        widget.onFinish();
                      },
                    ),
                  ],
                ),
              )
            : Container(),
      ]),
    ));
  }
}

///
///配网进度end///////////////
///

class SelectDevicePage extends StatelessWidget {
  const SelectDevicePage({
    Key? key,
    required this.onDeviceSelected,
  }) : super(key: key);

  final void Function(String deviceId) onDeviceSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select a nearby device:',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) {
                      return const Color(0xFF222222);
                    }),
                  ),
                  onPressed: () {
                    onDeviceSelected('22n483nk5834');
                  },
                  child: const Text(
                    'Bulb 22n483nk5834',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class WaitingPage extends StatefulWidget {
  const WaitingPage({
    Key? key,
    required this.message,
    required this.onWaitComplete,
  }) : super(key: key);

  final String message;
  final VoidCallback onWaitComplete;

  @override
  State<WaitingPage> createState() => _WaitingPageState();
}

class _WaitingPageState extends State<WaitingPage> {
  @override
  void initState() {
    super.initState();
    _startWaiting();
  }

  Future<void> _startWaiting() async {
    await Future<dynamic>.delayed(const Duration(seconds: 3));

    if (mounted) {
      widget.onWaitComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 32),
              Text(widget.message),
            ],
          ),
        ),
      ),
    );
  }
}

class FinishedPage extends StatelessWidget {
  const FinishedPage({
    Key? key,
    required this.onFinishPressed,
  }) : super(key: key);

  final VoidCallback onFinishPressed;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 250,
                height: 250,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF222222),
                ),
                child: const Center(
                  child: Icon(
                    Icons.lightbulb,
                    size: 175,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              const Text(
                'Bulb added!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.resolveWith((states) {
                    return const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12);
                  }),
                  backgroundColor: MaterialStateColor.resolveWith((states) {
                    return const Color(0xFF222222);
                  }),
                  shape: MaterialStateProperty.resolveWith((states) {
                    return const StadiumBorder();
                  }),
                ),
                onPressed: onFinishPressed,
                child: const Text(
                  'Finish',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RightChild extends StatelessWidget {
  const _RightChild({
    Key? key,
    required this.asset,
    required this.title,
    required this.message,
    this.disabled = false,
    this.isDoing = false,
  }) : super(key: key);

  final String asset;
  final String title;
  final String message;
  final bool disabled;
  final bool isDoing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: <Widget>[
          Opacity(
            // child: Image.asset(asset, height: 50),
            child: isDoing
                ? const CircularProgressIndicator()
                : Image.asset(asset, height: 50),
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
