import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:smart_cook/models/device_status.dart';
import 'package:smart_cook/screens/preset/fuc2_component.dart';
import 'package:smart_cook/screens/preset_list_screen.dart';
import 'package:smart_cook/theme/MySize.dart';

class PresetFunc2Screen extends StatefulWidget {
  static const routeName = '/preset/func2';
  static const model = 2;

  final String uiJsonFile; //前面全部来自asset ,后续改为file
  final String luaFile;

  const PresetFunc2Screen(
      {Key? key, required this.uiJsonFile, required this.luaFile})
      : super(key: key);

  @override
  State<PresetFunc2Screen> createState() => _PresetFunc2ScreenState();
}

class _PresetFunc2ScreenState extends State<PresetFunc2Screen> {
  GlobalKey key = GlobalKey();

  String msg = "";

  //variable
  @override
  initState() {
    super.initState();
  }

  _onExitPressed() {
    // Navigator.of(context).pop();
    Navigator.of(context).pushNamedAndRemoveUntil(
        PresetListScreen.routeName, (Route<dynamic> route) => false);
  }

  PreferredSizeWidget _buildFlowAppBar() {
    return AppBar(
      leading: IconButton(
        onPressed: _onExitPressed,
        icon: const Icon(Icons.chevron_left),
      ),
      title: const Text('恒温-样例'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        minimumSize: Size(MySize.startButtonLength, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        elevation: 0);

    return Scaffold(
      appBar: _buildFlowAppBar(),
      body: PresetFunc2Component(),
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                height: 40,
                child: ElevatedButton(
                    onPressed: () {},
                    style: raisedButtonStyle,
                    child: const Text('start cook')),
              ))
        ],
      ),
    );
  }
}
