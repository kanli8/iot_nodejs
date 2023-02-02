import 'package:easy_localization/easy_localization.dart';
import 'package:smart_cook/screens/activite_screen.dart';
import 'package:smart_cook/screens/appwrite_test_screen.dart';
import 'package:smart_cook/screens/category_screen.dart';
// ignore: unused_import
import 'package:smart_cook/screens/add_devices_screen.dart';
import 'package:smart_cook/screens/device_list.dart';
import 'package:smart_cook/screens/preset_list_screen.dart';
import 'package:smart_cook/screens/setting_screen.dart';
import 'package:smart_cook/awesomeDrawer/menu_page.dart';
import 'package:smart_cook/awesomeDrawer/page_structure.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/component/awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  static List<MyMenuItem> mainMenu = [
    MyMenuItem(tr("recipes"), Icons.payment, 0, CategoryScreen.routeName),
    MyMenuItem(
        tr("preset"), Icons.card_giftcard, 1, PresetListScreen.routeName),
    MyMenuItem(
        tr("device"), Icons.notifications, 2, DeviceListScreen.routeName),
    MyMenuItem(tr("settings"), Icons.help, 3, SettingScreen.routeName),
    MyMenuItem(tr("activat"), Icons.info_outline, 4, ActivatScreen.routeName),
    MyMenuItem(tr("appwirte test"), Icons.info_outline, 5,
        AppwriteTestScreen.routeName),
  ];

  final Widget child;
  final int currentPage;
  final bool isShowDefaultHeader;
  const HomeScreen(
      {Key? key,
      required this.child,
      required this.currentPage,
      required this.isShowDefaultHeader})
      : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _drawerController = AwesomeDrawerBarController();

  @override
  Widget build(BuildContext context) {
    return AwesomeDrawerBar(
      isRTL: false,
      controller: _drawerController,
      type: StyleState.scaleRight, // default,style1,style2,style3,style4,style5
      menuScreen: MenuScreen(
        HomeScreen.mainMenu,
        callback: _updatePage,
        current: widget.currentPage,
      ),
      mainScreen: MainScreen(
          isShowDefaultHeader: widget.isShowDefaultHeader, child: widget.child),
      borderRadius: 24.0,
      showShadow: true, //default,style1,style3
      angle: -12.0, //default
      slideWidth: MediaQuery.of(context).size.width * (0.65),
      // slideWidth: MediaQuery.of(context).size.width * (false ? .45 : 0.65), // default
      // slideHeight: MediaQuery.of(context).size.height * (AwesomeDrawerBar.isRTL() ? .45 : -0.17), //default
      // openCurve: Curves.fastOutSlowIn,
      // closeCurve: Curves.bounceIn,
    );
  }

  void _updatePage(index) {
    // _navigatorKey.currentState!.pushNamed(HomeScreen.mainMenu[index].routeName);
    Provider.of<MenuProvider>(context, listen: false).updateCurrentPage(index);
    _drawerController.toggle!();
    if (index != widget.currentPage) {
      Navigator.pushNamed(context, HomeScreen.mainMenu[index].routeName);
    }
  }
}

class MainScreen extends StatefulWidget {
  final Widget child;
  final bool isShowDefaultHeader;
  const MainScreen(
      {Key? key, required this.child, required this.isShowDefaultHeader})
      : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    const rtl = false;
    return ValueListenableBuilder<DrawerState>(
      valueListenable: AwesomeDrawerBar.of(context)?.stateNotifier
          as ValueNotifier<DrawerState>,
      builder: (context, state, child) {
        return AbsorbPointer(
          absorbing: state != DrawerState.closed,
          child: child,
        );
      },
      child: GestureDetector(
        child: PageStructure(
          title: "hello",
          child: widget.child,
          backgroundColor: const Color.fromARGB(11, 114, 32, 222),
          elevation: 2.0,
          isShowDefaultHeader: widget.isShowDefaultHeader,
        ),
        onPanUpdate: (details) {
          if (details.delta.dx < 6 && !rtl || details.delta.dx < -6 && rtl) {
            // AwesomeDrawerBar.of(context)!.toggle();
          }
        },
      ),
    );
  }
}

class MenuProvider extends ChangeNotifier {
  int _currentPage;

  MenuProvider(this._currentPage);

  int get currentPage => _currentPage;

  void updateCurrentPage(int index) {
    if (index != currentPage) {
      _currentPage = index;
      notifyListeners();
    }
  }
}
