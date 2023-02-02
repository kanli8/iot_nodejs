import 'package:flutter/material.dart';
import 'package:smart_cook/screens/preset/item/int_item.dart';
import 'package:smart_cook/screens/preset/item/timer_item.dart';

class PresetFunc2Component extends StatefulWidget {
  const PresetFunc2Component({Key? key}) : super(key: key);

  @override
  State<PresetFunc2Component> createState() => _PresetFunc2ComponentState();
}

////
///需要二次确认
////////
class _PresetFunc2ComponentState extends State<PresetFunc2Component> {
  int _time = 120;
  int temp = 110;
  //variable
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TimerItem(
          time: _time,
          maxTime: 1500,
          onTimeChange: (val) {
            setState(() {
              _time = val;
            });
          },
        ),
        IntItem(
          icon: Icons.thermostat,
          maxvalue: 120,
          minvalue: 0,
          onValueChange: (val) {
            setState(() {
              temp = val;
            });
          },
          title: 'TEMP',
          unit: '℃',
          value: temp,
          interval: 3,
        )
      ],
    );
  }
}
