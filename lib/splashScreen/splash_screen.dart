import 'dart:async';

import 'package:flutter/material.dart';

import '../authentication/login.dart';
import '../global/global.dart';
import '../mainScreen/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTimer(){
    Timer(const Duration(seconds: 1), () async{
      if(firebaseAuth.currentUser!= null){
        //Home Screen
        Navigator.push(context, MaterialPageRoute(builder: (c) => HomeScreen()));
      }
      else {
        //Login Screen
        Navigator.push(context, MaterialPageRoute(builder: (c) => LoginScreen()));
      }
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red.shade600,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("images/logo.png", scale: 2,)

              ],
            ),
          ),
        ),
      ),
    );
  }
}
