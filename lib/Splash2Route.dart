import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'NavDrawer.dart';
class Splash2Route{

  void isLogin(BuildContext context){
    Future.delayed(Duration(seconds: 1),(){
      if (FirebaseAuth.instance.currentUser!=null){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> NavDrawer()));
      }
      else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
  }
}