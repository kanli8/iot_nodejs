import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cook/component/awesome_drawer_bar/awesome_drawer_bar.dart';
import 'package:smart_cook/models/device.dart';
import 'package:smart_cook/models/family.dart';
import 'package:smart_cook/screens/add_devices_screen.dart';
import 'package:smart_cook/sql/appwirte/database.dart';
import 'package:smart_cook/sql/appwirte/storage.dart';
import 'package:smart_cook/theme/MySize.dart';
import '../utilities/constants.dart';
import 'add_device_screen_route.dart';

class DeviceListScreen extends StatefulWidget {
  static const routeName = '/deviceList';

  const DeviceListScreen({Key? key}) : super(key: key);

  @override
  State<DeviceListScreen> createState() => DeviceListScreenState();
}

class DeviceListScreenState extends State<DeviceListScreen> {
  final String _familyName = 'my devices';
  List<Device> _deviceList = [];
  @override
  void initState() {
    //TODO : implement initState
    super.initState();
    _getDeviceList();
  }

  void _getDeviceList() {
    Device.getDeviceListByUserId(
      onData: (deviceList) {
        setState(() {
          _deviceList = deviceList;
        });
      },
      onError: (error) {
        print(error);
      },
      onLoading: () {},
    );
  }

  List<Widget> _deviceListView() {
    List<Widget> deviceList = [];

    if (_deviceList.isEmpty) {
      return [
        const Center(
          child: Text('No device found'),
        )
      ];
    }

    for (Device device in _deviceList) {
      deviceList.add(
        Stack(alignment: AlignmentDirectional.bottomStart, children: [
          Container(
            alignment: Alignment.topCenter,
            // decoration: const BoxDecoration(
            //   image: DecorationImage(
            //     alignment: Alignment.topCenter,
            //     fit: BoxFit.fill,
            //     image: NetworkImage(
            //       'https://i.ibb.co/ZSzJcRm/image.png',
            //     ),
            //   ),
            // ),
            child: SizedBox(
              height: 350.0,
              child: getDeviceImgPreview(device.deviceImg, 350, 100),
            ),
          ),
          Container(
            width: 400,
            height: 60,
            alignment: AlignmentDirectional.center,
            child: Text(device.name,
                style: const TextStyle(
                  color: Color.fromARGB(245, 255, 255, 255),
                )),
            decoration: const BoxDecoration(color: Color(0x90000000)),
          )
        ]),
      );
    }
    return deviceList;
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
        _familyName,
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
          onPressed: () {
            Navigator.of(context).pushNamed(AddDeviceFlow.routeName);
          },
        ),
      ],
      elevation: 0,
    );

    return Scaffold(
      appBar: appBar,
      body: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildListDelegate(_deviceListView()),
          ),
        ],
      ),
      bottomSheet: Text('bottomSheet'),
    );
  }
}
