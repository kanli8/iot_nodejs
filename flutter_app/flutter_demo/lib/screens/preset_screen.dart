import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_cook/models/ws_data.dart';

class PresetScreen extends StatefulWidget {

  static const routeName = '/preset';

  const PresetScreen({Key? key}) : super(key: key);

  @override
  State<PresetScreen> createState() => _PresetScreenState();
}



class _PresetScreenState extends State<PresetScreen>{

  String msg = "";
  //variable
  @override
  initState() {
    super.initState();
   
  }

  //头
  Widget header(){
    return const Text('Header...') ;
  }

  //选设备
  Widget chooseDevice(){
    return const Text('chooseDevice...') ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Consumer<Map>(
        builder: (context, Map wsData, child) {
              return Column(
                children: <Widget>[
                  const Text("REVICER..."),
                  Text("$wsData"),
                  TextField(
                    obscureText: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'msg',
                    ),
                    onSubmitted: (str){msg=str;},
                  ),
                  OutlinedButton(
                    onPressed: () {
                      debugPrint('send msg on click');
                      WsData.getInstance().sendData(msg) ;
                    },
                    child: const Text('send msg'),
                  )
                    

                ],
              );
            },
          ),
    );
  }
}