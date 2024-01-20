import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'Splash2Route.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    Splash2Route().isLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Container(
          height: double.infinity,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors:  [
                Color(0xff765AFE),
                Color(0xff5230E9)
              ]
            ),
          ),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 30,
                ),
              Lottie.asset(
              "assets/lottie/splash.json",
              height: 500,
              width: 400,
              repeat: true,
              ),
                Text("SURAKSHAK",style: TextStyle(fontWeight: FontWeight.w700,fontFamily: 'Poppins',fontSize: 50,color: Colors.white),)
              ],
              ),
          ),
        ),
      ]),
    );
  }
}
