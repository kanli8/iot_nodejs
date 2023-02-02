import 'package:flutter/material.dart';
import 'package:smart_cook/component/awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:smart_cook/models/device.dart';
import 'package:smart_cook/screens/add_device_screen_route.dart';
import 'package:smart_cook/screens/preset/func1_screen.dart';
import 'package:smart_cook/screens/preset/func2_screen.dart';
import 'package:smart_cook/screens/preset/preset_list.dart';
import 'package:smart_cook/theme/MySize.dart';

class PresetItem extends StatelessWidget {
  final String itemName;
  final BuildContext context;
  const PresetItem({Key? key, required this.itemName, required this.context})
      : super(key: key);

  void _onCardTap() {
    Navigator.pushNamed(context, PresetFunc1Screen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
        child: InkWell(
      onTap: _onCardTap,
      child: Text(itemName),
    ));
  }
}

class PresetListScreen extends StatefulWidget {
  static const routeName = '/preset_list';

  const PresetListScreen({Key? key}) : super(key: key);

  @override
  State<PresetListScreen> createState() => _PresetListScreenState();
}

class _PresetListScreenState extends State<PresetListScreen> {
  //variable

  final List<Device> _deviceList = [
    Device(
        status: 0,
        name: 'test device',
        deviceImg: '634261b0850922dbca89',
        ownerUserId: 'ownerUserId',
        deviceModelId: 2,
        deviceId: '	46cfdff09398faa9')
  ];

  @override
  initState() {
    super.initState();
  }

  List<Widget> _tabBars() {
    List<Widget> list = [];
    for (int i = 0; i < _deviceList.length; i++) {
      list.add(Tab(
        icon: Image.asset('assets/images/device1.png'),
      ));
    }
    return list;
  }

  List<Widget> _tabViews() {
    List<Widget> list = [];

    for (int i = 0; i < _deviceList.length; i++) {
      List<Widget> presetItems = [];
      MachinePreset? mps = presetList[2];
      if (mps == null) {
        presetItems.add(
          Center(
            child: Text(_deviceList[i].name + " not perset config"),
          ),
        );
      } else {
        for (int j = 0; j < mps.presetList.length; j++) {
          presetItems.add(Padding(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Card(
                  clipBehavior: Clip.hardEdge,
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0))),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, mps.presetList[j].routeAddr,
                          arguments: _deviceList[i].deviceId);
                      // Navigator.pushNamed(context, RecipeDetailsScreen.routeName, arguments: recipe);
                    },
                    child: Stack(children: [
                      Image.asset(mps.presetList[j].backgroupImg,
                          fit: BoxFit.cover),
                      Center(
                        child: Container(
                            alignment: Alignment.bottomCenter,
                            height: MySize.width * 0.25,
                            child: Text(mps.presetList[j].name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 50,
                                ))),
                      ),
                    ]),
                  ))));
        }
      }

      list.add(Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: presetItems,
      ));
    }

    return list;
  }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = AppBar(
      leading: Builder(
        builder: (BuildContext context) {
          return IconButton(
            icon: Icon(
              Icons.menu,
              color: MySize.purpleDark,
            ),
            onPressed: () {
              AwesomeDrawerBar.of(context)!.toggle();
            },
          );
        },
      ),
      title: Text(
        'preset',
        style: TextStyle(
          color: MySize.purpleDark,
          fontSize: MySize.getScaledSizeHeight(20),
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: MySize.purpleDark,
          ),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(
            Icons.add,
            color: MySize.purpleDark,
          ),
          onPressed: () {},
        ),
      ],
      elevation: 0,
    );
    return Scaffold(
        appBar: appBar,
        body: DefaultTabController(
          length: _deviceList.length, // Added
          initialIndex: 0,
          child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                elevation: 0,
                title: PreferredSize(
                  preferredSize: const Size.fromHeight(5.0),
                  child: TabBar(
                      isScrollable: true,
                      unselectedLabelColor: Colors.white.withOpacity(0.3),
                      indicatorColor: Color.fromARGB(255, 97, 65, 65),
                      tabs: _tabBars()),
                )),
            body: TabBarView(
              children: _tabViews(),
            ),
          ),
        ));
  }
}
