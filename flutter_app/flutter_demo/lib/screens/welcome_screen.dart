import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:smart_cook/models/ws_data.dart';
import 'package:smart_cook/screens/category_screen.dart';
import 'package:smart_cook/constant/constant.dart';
import 'package:smart_cook/sql/appwirte/user.dart';
import 'login_screen.dart';



class WelcomeScreen extends StatefulWidget {
  static const routeName = '/welcome-screen';



  const WelcomeScreen({
    Key? key,}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();

}


class _WelcomeScreenState extends  State<WelcomeScreen> {
  




  @override
  void initState() {
    super.initState();
    
    checkLogin2(
      onLoading:(){
        
      },
      onSuccess: (){
       
        WsData.getInstance().connectIot();
        Navigator.pushNamedAndRemoveUntil(context, CategoryScreen.routeName, (route) => false);
      },
      onError: (errMsg) {
        
        Navigator.pushNamedAndRemoveUntil(context, LoginScreen.routeName, (route) => false);
      }
    );


    
  }

  @override
  Widget build(BuildContext context) {
      double width = MediaQuery.of(context).size.width;
      double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: SvgPicture.asset('assets/images/Ornament.svg')
          ),
          Baseline(
            baseline:height *1.05,
            baselineType:TextBaseline.alphabetic,
            child: Row(
            children:[
              SizedBox(
                width: width*0.4,height: width*0.4,
                child: Image.asset('assets/images/welcome_left_recipe_img.png',scale: 1.5,fit:BoxFit.none,alignment:Alignment.center),
              ),
              SizedBox.fromSize(size:Size( width*0.2,  width*0.5)),
              SizedBox(
                width: width*0.4,height: width*0.4,
                child: Image.asset('assets/images/welcome_right_recipe_img.png',scale: 1.8,fit:BoxFit.none,alignment:Alignment.center),
              ),

              
              
            ]
          ),
            ),

          
          Center(
            child: SvgPicture.asset('assets/images/Logo.svg')
          ),
          
      ],
      //  body:
    ));
  }
}
