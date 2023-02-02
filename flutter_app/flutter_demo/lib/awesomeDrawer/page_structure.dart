import 'package:smart_cook/awesomeDrawer/home_screen.dart';

import 'package:flutter/material.dart';
import 'package:smart_cook/component/awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:provider/provider.dart';

class PageStructure extends StatelessWidget {
  final String title;
  final Widget child;
  final Color backgroundColor;
  final double elevation;
  final bool isShowDefaultHeader;
  const PageStructure(
      {Key? key,
      required this.title,
      required this.child,
      required this.backgroundColor,
      required this.elevation,
      required this.isShowDefaultHeader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final angle = false ? 180 * pi / 180 : 0.0;
    const angle = 0.0;
    final _currentPage =
        context.select<MenuProvider, int>((provider) => provider.currentPage);

    return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: isShowDefaultHeader
            ? AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  HomeScreen.mainMenu[_currentPage].title,
                ),
                leading: Transform.rotate(
                  angle: angle,
                  child: IconButton(
                    icon: const Icon(
                      Icons.menu,
                    ),
                    onPressed: () {
                      AwesomeDrawerBar.of(context)!.toggle();
                    },
                  ),
                ),
                // trailingActions: actions,
              )
            : null,
        body: child);
  }
}
