import 'package:flutter/material.dart';

import 'package:smart_cook/screens/preset/fuc1_component.dart';
import 'package:smart_cook/screens/preset_list_screen.dart';
import 'package:smart_cook/theme/MySize.dart';

class PresetFunc1Screen extends StatefulWidget {
  static const routeName = '/preset/func1';
  static const model = 1;
  final RouteSettings settings;
  const PresetFunc1Screen({Key? key, required this.settings}) : super(key: key);

  @override
  State<PresetFunc1Screen> createState() => _PresetFunc1ScreenState();
}

class _PresetFunc1ScreenState extends State<PresetFunc1Screen> {
  GlobalKey key = GlobalKey();
  String deviceId = '';
  String msg = "";
  String pass = "";
  Map<String, dynamic> map = {
    "mod": 2,
    "p1": 99,
    "p2": 1024,
    "t1": 88,
    "t2": 369,
    "rid": 10001,
    "step": 4,
    "pg": 35,
    "rt": 1200,
    "progess_time": 1662280593,
    "status": 1
  };
  //variable
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    deviceId = widget.settings.arguments as String;
  }

  _onExitPressed() {
    Navigator.of(context).pushNamedAndRemoveUntil(
        PresetListScreen.routeName, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.chevron_left,
              color: MySize.purpleDark,
            ),
            onPressed: _onExitPressed,
          );
        },
      ),
      title: Text(
        '恒温' + deviceId,
        style: TextStyle(
          color: MySize.purpleDark,
          fontSize: MySize.getScaledSizeHeight(20),
          fontWeight: FontWeight.w600,
        ),
      ),
      elevation: 0,
    );

    return Scaffold(
        appBar: appBar,
        body: PresetFunc1Component(
          deviceId: deviceId,
        ));
  }
}
