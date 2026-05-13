import 'dart:async';
import 'package:flashcart_new_1/domain/constants/appcolors.dart';
import 'package:flashcart_new_1/repository/screens/home/homescreen.dart';
import 'package:flashcart_new_1/repository/screens/login/loginscreen.dart';
import 'package:flashcart_new_1/repository/widgets/uihelper.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget{
  @override
  State<SplashScreen> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  static const String KEYLOGIN = "login";
  @override
  void initState() {
    super.initState();
    whereToGo();
  }
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Color(0xFFC33E39),
     body: Center(
       child: Column(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
         UiHelper.CustomImage(img: "flashcart.jpeg"),
       ],),
     ),
   );
  }


void whereToGo() async {
    var sharedPref= await SharedPreferences.getInstance();
    var isLoggedIn =sharedPref.getBool(KEYLOGIN);
  Timer(Duration(seconds: 3),(){
    if(isLoggedIn!=null){
      if(isLoggedIn){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }else{
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
      }
    }else{
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

    }
  });
}
}