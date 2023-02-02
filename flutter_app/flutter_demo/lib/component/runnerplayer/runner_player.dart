import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smart_cook/models/device_status.dart';
import 'package:smart_cook/screens/preset/func1_screen.dart';
import 'package:smart_cook/screens/preset/func2_screen.dart';

class RunnerPlayer extends StatefulWidget {

  static const routeName = '/preset';
  
  final void Function(String name) gotoPage ;
  const RunnerPlayer(  {Key? key, required this.gotoPage}) : super(key: key);


  @override
  State<RunnerPlayer> createState() => _RunnerPlayerState();
}



class _RunnerPlayerState extends State<RunnerPlayer>{

final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  //variable
  @override
  initState() {
    super.initState();
   
  }

  _onGoto(){
    DeviceStatus ds = DeviceStatus.getInstance();
    switch(ds.model){
    case PresetFunc1Screen.model:
      widget.gotoPage(PresetFunc1Screen.routeName);
      break;
    case PresetFunc2Screen.model:
      widget.gotoPage(PresetFunc2Screen.routeName);
      break;
    default:
      debugPrint("no model running");
    }
    
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Positioned(
            width: size.height *0.9,
            height: 56,
            top: size.height - 72,
            left:  0,
            child: Material(
              key:const Key("_RunnerPlayerState_Material"),
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () => debugPrint('ON TAP OVERLAY!'),
                child: Container(
                  decoration: const BoxDecoration(shape: BoxShape.rectangle, color: Colors.redAccent),
                  child: Scaffold(
                    body:Consumer<Map>(
                      builder: (context, Map wsData, child) {
                            return Row(
                              children: <Widget>[
                                
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      textStyle: const TextStyle(fontSize: 11),
                                    ),
                                    onPressed: _onGoto,
                                    child: const Text('GOTO'),
                                  ),
                                  Text("$wsData"),
                              ],
                            );
                          },
                        ),
                  ),
                ),
              ),
            ),
          );

    // return Scaffold(
    //   body:Consumer<String>(
    //     builder: (context, String wsData, child) {
              
              
              
    //           //  Column(
    //           //   children: <Widget>[
    //           //     Text("REVICER..."),
    //           //     Text("$wsData"),
      

    //           //   ],
    //           // );
    //         },
    //       ),
    // );
  }
}