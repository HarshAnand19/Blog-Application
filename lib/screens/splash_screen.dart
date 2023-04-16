import 'dart:async';

import 'package:blog_app/main.dart';
import 'package:blog_app/provider/user_provider.dart';
import 'package:blog_app/screens/home_screen.dart';
import 'package:blog_app/screens/login_screen.dart';
import 'package:blog_app/screens/option_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  FirebaseAuth auth=FirebaseAuth.instance;

  //if User is logged in --> HomeScreen()
  //if User is not logged in --> OptionScreen()
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    final user=auth.currentUser;
    if(user!=null){
      addData();
      Timer(Duration(seconds: 3),() => Navigator.pushReplacement
        (context, MaterialPageRoute(builder: (context)=>HomeScreen(name:user.displayName.toString()))));
    }else{
      Timer(Duration(seconds: 3),() => Navigator.pushReplacement
        (context, MaterialPageRoute(builder: (context)=>LoginScreen())));
    }
  }

  addData() async{
    UserProvider _userProvider=Provider.of<UserProvider>(context,listen: false);
    await _userProvider.refreshUser();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
         Align(
             alignment: Alignment.center,
             child: Image.asset(
               'assets/images/sociotechflash.png',
               )
         ),
        ],
      ),

    );
  }
}
