import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/models/device_status.dart';
import 'package:smart_cook/models/my_recipes.dart';
import 'package:smart_cook/screens/preset/fuc2_component.dart';
import 'package:smart_cook/sql/appwirte/storage.dart';
import 'package:smart_cook/theme/MySize.dart';

class RecipeRunnerScreen extends StatefulWidget {
  static const routeName = '/recipe-runner';

  final RouteSettings settings;

  const RecipeRunnerScreen({
    Key? key,
    required this.settings,
  }) : super(key: key);

  @override
  State<RecipeRunnerScreen> createState() => _RecipeRunnerScreenState();
}

class _RecipeRunnerScreenState extends State<RecipeRunnerScreen>
    with SingleTickerProviderStateMixin {
  late MyRecipe _mr;
  int _step = 0; //
  late TabController _tabController;
  DeviceStatus deviceStatus = DeviceStatus.getInstance();
  _onExitPressed() {
    Navigator.of(context).pop();
  }

  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    _mr = widget.settings.arguments as MyRecipe;
    _tabController = TabController(vsync: this, length: _mr.steps.length);

    _step = 0;
    if (deviceStatus.isRe && deviceStatus.rId == _mr.id) {
      _step = deviceStatus.step;
    }
  }

  Widget _getImages(String fileId) {
    return getRecipesImagePreview(fileId, MySize.width.toInt(), 100);
  }

  Widget _stepView(int index) {
    Map<String, dynamic> step = jsonDecode(_mr.steps[index]);
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
        minimumSize: Size(MySize.startButtonLength, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        elevation: 0);
    final ButtonStyle mediumRaisedButtonStyle = ElevatedButton.styleFrom(
        minimumSize: Size(MySize.size12, 40),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        elevation: 0);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close_sharp),
          onPressed: _onExitPressed,
        ),
        title: Text(tr('STEP') + ' ${index + 1}'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (index + 1) / _mr.steps.length,
              semanticsLabel: 'Linear progress indicator',
              color: Colors.red,
            ),
            _getImages(_mr.imagePath),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                tr('Step') + '${index + 1} : ' + step['name'],
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.red),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                step['description'].toString(),
                style: const TextStyle(fontSize: 20),
              ),
            ),
            step['deviceSetting'] == null ? Text('') : PresetFunc2Component(),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: SizedBox(
                height: 40,
                child: step['deviceSetting'] == null
                    ? Row(
                        children: [
                          ElevatedButton(
                              onPressed: _startCook,
                              style: mediumRaisedButtonStyle,
                              child: Text(tr('prev step'))),
                          const SizedBox(
                            width: 20,
                          ),
                          ElevatedButton(
                              onPressed: _startCook,
                              style: mediumRaisedButtonStyle,
                              child: Text(tr('next step'))),
                        ],
                      )
                    : ElevatedButton(
                        onPressed: _startCook,
                        style: raisedButtonStyle,
                        child: const Text('start cook ')),
              ))
        ],
      ),
    );
  }

  void _startCook() {}
  //  Column(
  //       children: [
  //         _getImages(_mr.imagePath),
  //         const SizedBox(
  //           height: 10,
  //         ),
  //         Text(
  //           _mr.title,
  //           style: const TextStyle(fontSize: 20),
  //         ),
  //       ],
  //     ),
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      controller: _tabController,
      children: _mr.steps.map((e) => _stepView(_mr.steps.indexOf(e))).toList(),
    );
  }
}
