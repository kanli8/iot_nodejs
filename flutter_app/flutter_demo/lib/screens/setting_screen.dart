import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_cook/constant/constant.dart';
import 'package:smart_cook/main.dart';
import 'package:smart_cook/sql/appwirte/storage.dart';
import 'package:smart_cook/sql/appwirte/user.dart';
import 'package:uuid/uuid.dart';

class SettingScreen extends StatefulWidget {
  static const routeName = '/setting';

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  Image _userAvator = Image.asset('assets/images/user.png');
  final ImagePicker _picker = ImagePicker();

  Future<void> chooseFileFromGallery() async {
    setUserAtavar(
        onChooseImage: (Image image) {
          setState(() {
            _userAvator = image;
          });
        },
        onLoading: () {},
        onSuccess: (String uuid) {},
        onError: (String msg) {});
  }

  Future<void> addrecipesImages() async {
    addRecipesImages(
        onChooseImage: (Image image) {
          setState(() {
            _userAvator = image;
          });
        },
        onLoading: () {},
        onSuccess: (String uuid) {},
        onError: (String msg) {
          debugPrint('addrecipesImages  error.....' + msg);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            child: InkWell(
              child: CircleAvatar(
                backgroundImage: _userAvator.image,
              ),
              onTap: () => chooseFileFromGallery(),
            ),
            width: 50,
            height: 50,
          ),
          ElevatedButton(
            onPressed: () {
              debugPrint(
                  ' MyApp.notifier.value' + MyApp.notifier.value.toString());
              MyApp.notifier.value = MyApp.notifier.value == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            },
            child: const Text('Toggle Theme'),
          ),
          const Text('add recipes image:'),
          SizedBox(
            child: InkWell(
              child: CircleAvatar(
                backgroundImage: _userAvator.image,
              ),
              onTap: () => addrecipesImages(),
            ),
            width: 50,
            height: 50,
          ),
        ],
      ),
    );
  }
}
