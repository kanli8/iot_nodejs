
import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:smart_cook/constant/constant.dart';






class AppwriteTestScreen extends StatefulWidget {

  static const routeName = '/appwrite-test';





  const AppwriteTestScreen({
    Key? key,}) : super(key: key);

  @override
  State<AppwriteTestScreen> createState() => _AppwriteTestScreenState();
}




class _AppwriteTestScreenState extends State<AppwriteTestScreen>{


  String _msg = "";

  @override
  initState() {
    super.initState();
   
  }


  void _getSession(){
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
        children: [
          Text(_msg),
           ElevatedButton(onPressed: _getSession, 
          child: const Text('getSession')
          ),
        ],
      )
    );
  }
}