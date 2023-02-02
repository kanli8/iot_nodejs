import 'package:smart_cook/screens/preset/func1_screen.dart';
import 'package:smart_cook/screens/preset/func2_screen.dart';

class PresetItemModel {
  final String name;
  final String backgroupImg;
  final String routeAddr;

  const PresetItemModel(
      {required this.name,
      required this.backgroupImg,
      required this.routeAddr});
}

class MachinePreset {
  final String name;
  final List<PresetItemModel> presetList;

  const MachinePreset({required this.name, required this.presetList});
}

//model_id : config
const presetList = {
  ///高压锅
  2: MachinePreset(name: 'test preset22', presetList: [
    PresetItemModel(
        backgroupImg: 'assets/images/graphicsScale.png',
        name: '调试',
        routeAddr: PresetFunc1Screen.routeName),
    PresetItemModel(
        backgroupImg: 'assets/images/graphicsScale.png',
        name: '恒温-样例',
        routeAddr: PresetFunc2Screen.routeName),
  ])
};
