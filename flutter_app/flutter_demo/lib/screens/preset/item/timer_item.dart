import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:smart_cook/theme/MySize.dart';

class TimerItem extends StatelessWidget {
  final int time;
  final int maxTime;
  final void Function(int) onTimeChange;

  const TimerItem(
      {Key? key,
      required this.time,
      required this.maxTime,
      required this.onTimeChange})
      : super(key: key);

  void _onCardTap(BuildContext context) {
    //open sheet to set timer
    int _selectedMinute = time ~/ 60;
    int _selectedSecond = time % 60;
    int maxMinute = maxTime ~/ 60;
    Future<void> future = showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 300.0,
              color: Colors.white,
              child: Column(children: [
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () {
                            _selectedMinute = time ~/ 60;
                            _selectedSecond = time % 60;
                            Navigator.pop(context);
                          },
                          child: Text(tr('cancel'),
                              style: const TextStyle(fontSize: 20))),
                      Text(tr('timer'), style: const TextStyle(fontSize: 20)),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(tr('confirm'),
                              style: const TextStyle(fontSize: 20))),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: _selectedMinute,
                            ),
                            itemExtent: 32.0,
                            onSelectedItemChanged: (int index) {
                              _selectedMinute = index;
                            },
                            children:
                                List<Widget>.generate(maxMinute, (int index) {
                              return Center(
                                child: Text('$index '),
                              );
                            })),
                      ),
                      const Center(
                        child: Text(':',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
                      ),
                      Expanded(
                        child: CupertinoPicker(
                            scrollController: FixedExtentScrollController(
                              initialItem: _selectedSecond,
                            ),
                            itemExtent: 32.0,
                            onSelectedItemChanged: (int index) {
                              _selectedSecond = index + 1;
                            },
                            children: List<Widget>.generate(60, (int index) {
                              return Center(
                                child: Text('$index '),
                              );
                            })),
                      ),
                    ],
                  ),
                )
              ]));
        });
    future.then((value) {
      onTimeChange(_selectedMinute * 60 + _selectedSecond);
      // print('selected time: $_selectedMinute:$_selectedSecond');
    });
  }

  @override
  Widget build(BuildContext context) {
    int minute = time ~/ 60;
    int second = time % 60;
    //add 0 to minute and second
    String minuteStr = minute < 10 ? '0$minute' : '$minute';
    String secondStr = second < 10 ? '0$second' : '$second';
    Color textColor = Theme.of(context).textTheme.bodyText1!.color!;
    return InkWell(
      onTap: () {
        _onCardTap(context);
      },
      child: Center(
          child: Card(
        child: SizedBox(
            height: 100,
            width: MySize.width * 0.95,
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'timer'.tr(),
                        style: TextStyle(fontSize: 20, color: textColor),
                      ),
                      Icon(
                        Icons.alarm_sharp,
                        size: 50,
                        color: textColor,
                      ) //import AlarmSharpIcon from '@mui/icons-material/AlarmSharp';
                    ],
                  ),
                  const Spacer(
                    flex: 3,
                  ),
                  Text(
                      tr(
                        'MIN',
                      ),
                      style: TextStyle(fontSize: 20, color: textColor)),
                  const Spacer(),
                  Text(
                    minuteStr,
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const Spacer(),
                  Text(
                    ':',
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const Spacer(),
                  Text(
                    secondStr,
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  const Spacer(),
                  Text(tr('SEC'),
                      style: TextStyle(fontSize: 20, color: textColor)),
                  const Spacer(
                    flex: 3,
                  ),
                ])),
      )),
    );
  }
}
