import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/theme/MySize.dart';

class IntItem extends StatelessWidget {
  final int value;
  final int maxvalue;
  final int minvalue;
  final String unit;
  final String title;
  final IconData icon;
  final int interval;
  final void Function(int) onValueChange;

  const IntItem({
    Key? key,
    required this.value,
    required this.maxvalue,
    required this.onValueChange,
    required this.minvalue,
    required this.unit,
    required this.title,
    required this.icon,
    required this.interval,
  }) : super(key: key);

  void _onCardTap(BuildContext context) {
    //open sheet to set timer
    int _selectedValue = 0;
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
                              initialItem: value,
                            ),
                            itemExtent: 32.0,
                            onSelectedItemChanged: (int index) {
                              _selectedValue = index;
                            },
                            children:
                                List<Widget>.generate(maxvalue, (int index) {
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
      onValueChange(_selectedValue);
      // print('selected time: $_selectedMinute:$_selectedSecond');
    });
  }

  @override
  Widget build(BuildContext context) {
    //add 0 to minute and second

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
                        title,
                        style: TextStyle(fontSize: 20, color: textColor),
                      ),
                      Icon(
                        icon,
                        size: 50,
                        color: textColor,
                      ) //import AlarmSharpIcon from '@mui/icons-material/AlarmSharp';
                    ],
                  ),
                  const Spacer(),
                  Text(
                    value.toString(),
                    style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: textColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Text(
                      ' ' + unit,
                      style: TextStyle(fontSize: 20, color: textColor),
                    ),
                  ),
                  const Spacer(),
                ])),
      )),
    );
  }
}
