import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inspection/catur/constants/color_constant.dart';
import 'package:inspection/catur/home/screens/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    loadActivity();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.colorWhite,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Image.asset(
              'assets/logo_catur.jpg',
              height: 150.0,
              width: 150.0,
            ),
          ],
        ),
      ),
    );
  }

  void loadActivity() async {
    // isLogin = await _isLogin();
    // print('intro isLogin: $isLogin');
    // sharedPreferences = await SharedPreferences.getInstance();
    Timer(Duration(seconds: 3), () {
      // if (isLogin) {
      Navigator.of(context).pushReplacement(new MaterialPageRoute(builder: (_) {
        return HomeScreen();
      }));
      // }
      // else {
      // Navigator.of(context)
      //     .pushReplacement(new MaterialPageRoute(builder: (_) {
      //   return LoginPresensi();
      // }));
      // }
    });
  }
}
