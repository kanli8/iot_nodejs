import 'dart:io';



import 'package:easy_localization/easy_localization.dart';
import 'package:smart_cook/awesomeDrawer/home_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_cook/constant/show_snack_bar.dart';
import 'package:smart_cook/screens/login_screen.dart';
import 'package:smart_cook/sql/appwirte/user.dart';

import '../constant/constant.dart';

class MenuScreen extends StatefulWidget {
  final List<MyMenuItem> mainMenu;
  final Function(int) callback;
  final int current;

   const MenuScreen(
    this.mainMenu, {Key? key, 
    required this.callback,
    required this.current,
  }) : super(key: key);

  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  final widthBox = const SizedBox(
    width: 16.0,
  );


  void logout(){
      logout2(context);
    
  }

  @override
  Widget build(BuildContext context) {
    const TextStyle androidStyle = TextStyle(
        fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white);
    const TextStyle iosStyle = TextStyle(color: Colors.white);
    final style = kIsWeb? androidStyle: Platform.isAndroid ? androidStyle : iosStyle;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Theme.of(context).primaryColor,
              Colors.indigo,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 24.0, left: 24.0, right: 24.0),
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 36.0, left: 24.0, right: 24.0),
                child: Text(
                  tr("name"),
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Selector<MenuProvider, int>(
                selector: (_, provider) => provider.currentPage,
                builder: (_, index, __) => Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ...widget.mainMenu
                        .map((item) => MyMenuItemWidget(
                              key: Key(item.index.toString()),
                              item: item,
                              callback: widget.callback,
                              widthBox: widthBox,
                              style: style,
                              selected: index == item.index,
                            ))
                        .toList()
                  ],
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 24.0),
                child: ElevatedButton(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      tr("logout"),
                      style: const TextStyle(fontSize: 18),
                    ),
                  ),
              
                  onPressed: logout,
                  
                
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

class MyMenuItemWidget extends StatelessWidget {
  final MyMenuItem item;
  final Widget widthBox;
  final TextStyle style;
  final Function callback;
  final bool selected;

  final white = Colors.white;

  const MyMenuItemWidget(
      {required Key key,
      required this.item,
      required this.widthBox,
      required this.style,
      required this.callback,
      required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => callback(item.index),
      // color: selected ? const Color(0x44000000) : null,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            item.icon,
            color: white,
            size: 24,
          ),
          widthBox,
          Expanded(
            child: Text(
              item.title,
              style: style,
            ),
          )
        ],
      ),
    );
  }
}

class MyMenuItem {
  final String title;
  final IconData icon;
  final int index;
  final String routeName;
  const MyMenuItem(this.title, this.icon, this.index,this.routeName);
}
