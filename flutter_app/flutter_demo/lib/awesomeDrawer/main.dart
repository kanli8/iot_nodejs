import 'package:smart_cook/awesomeDrawer/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';



class AwesomeDrawerScreen extends StatelessWidget {

  final Widget child ;

  final int currentPage ;
  final bool isShowDefaultHeader ;
  static const routeName = '/awesome_drawer_screen';

   const AwesomeDrawerScreen({Key? key, 
    required this.child, 
    this.isShowDefaultHeader = true ,
    required this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  ChangeNotifierProvider(
        create: (_) => MenuProvider(currentPage),
        child: HomeScreen(
          child: child,currentPage:currentPage, isShowDefaultHeader: isShowDefaultHeader,
          ),
      );
  }
}
