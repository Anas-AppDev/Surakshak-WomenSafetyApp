import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Login.dart';
import 'ToastUtil.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  var formKey = GlobalKey<FormState>();
  var cumailCtrl = TextEditingController();
  var passCtrl = TextEditingController();
  var nameCtrl = TextEditingController();

  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("Surakshak");

  late Timer timer;
  bool isResendButtonEnabled = true;


  @override
  void dispose() {
    super.dispose();
    // timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: BackButton(
          color: Colors.white,
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff7458FD),
                Color(0xff5736EC),
              ],
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color(0xff7458FD),
                Color(0xff5736EC),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Text("Sign Up", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40),),
                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30,),
                      Text("   Name", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                      SizedBox(height: 10,),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: nameCtrl,
                                decoration: InputDecoration(
                                    hintText: "Enter Name",
                                    hintStyle: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Color(0xff7458FD), // Change this color to your desired hint text color
                                    ),
                                    prefixIcon: Icon(CupertinoIcons.person_alt_circle, color: Color(0xff7458FD),),
                                    border: InputBorder.none,
                                    counterText: ""
                                ),
                                maxLength: 20,
                                maxLines: 1,
                                validator: (value){
                                  if (value!.isEmpty){
                                    return "Enter Name";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),


                      SizedBox(height: 30,),
                      Text("   Mail", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                      SizedBox(height: 10,),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.emailAddress,
                                controller: cumailCtrl,
                                decoration: InputDecoration(
                                    hintText: "Enter CU Mail",
                                    hintStyle: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Color(0xff7458FD), // Change this color to your desired hint text color
                                    ),
                                    prefixIcon: Icon(CupertinoIcons.mail, color: Color(0xff7458FD),),
                                    border: InputBorder.none
                                ),
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Enter Mail Id";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30,),
                      Text("   Password", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
                      SizedBox(height: 10,),
                      Container(
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                controller: passCtrl,
                                decoration: InputDecoration(
                                    hintText: "Enter Password",
                                    hintStyle: TextStyle(
                                      fontFamily: "Poppins",
                                      color: Color(0xff7458FD), // Change this color to your desired hint text color
                                    ),
                                    prefixIcon: Icon(CupertinoIcons.mail, color: Color(0xff7458FD),),
                                    border: InputBorder.none,
                                    counterText: ""
                                ),
                                maxLines: 1,
                                maxLength: 15,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password cannot be empty";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 20,),
                    ],
                  ),
                  key: formKey,
                ),

                SizedBox(height: 50,),
                InkWell(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      try {
                        final userCredential = await auth.createUserWithEmailAndPassword(
                          email: cumailCtrl.text.trim().toLowerCase(),
                          password: passCtrl.text.trim(),
                        );

                        if (userCredential.user != null) {
                          // Send email verification
                          await userCredential.user!.sendEmailVerification();
                          setState(() {
                            isResendButtonEnabled = false;
                          });

                          // Start a timer to re-enable the button after a certain duration (e.g., 60 seconds)
                          Timer(Duration(seconds: 60), () {
                            setState(() {
                              isResendButtonEnabled = true;
                            });
                          });

                          // Show a toast message or alert indicating that a verification email has been sent
                          ToastUtil().toast("Verification email sent. Please verify your email before logging in.");

                          // Delay navigation to allow time for the user to see the toast message
                          timer = Timer.periodic(Duration(seconds: 3), (timer) async{
                            await auth.currentUser!.reload();
                            if (auth.currentUser!.emailVerified){

                              firestore.doc('VerifiedUsers').collection("Users").add({auth.currentUser!.uid : auth.currentUser!.email.toString()});
                              firestore.doc("Users").collection("UserUids").doc(auth.currentUser!.uid).set(
                                  {
                                    "name": nameCtrl.text,
                                    "userUid": auth.currentUser!.uid,
                                  }
                              );

                              timer.cancel();
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                              ToastUtil().toast("Mail verified");
                            }
                          });
                        }
                      } catch (e) {
                        // Handle registration errors, such as invalid email or weak password
                        ToastUtil().toast("Registration failed: $e");
                      }
                    }
                  },
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 240,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff7458FD),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10,),
                InkWell(
                  onTap: ()async{

                    try {

                      if (!(auth.currentUser!.emailVerified)){
                        if (isResendButtonEnabled){

                          final user = auth.currentUser;
                          if (user != null) {
                            await user.sendEmailVerification();

                            setState(() {
                              isResendButtonEnabled = false;
                            });

                            // Start a timer to re-enable the button after a certain duration (e.g., 60 seconds)
                            Timer(Duration(seconds: 60), () {
                              setState(() {
                                isResendButtonEnabled = true;
                              });
                            });
                            // Show a toast message or alert indicating that a new verification email has been sent
                            ToastUtil().toast("New verification email sent. Please check your inbox.");
                            timer = Timer.periodic(Duration(seconds: 3), (timer) async{
                              await auth.currentUser!.reload();
                              if (auth.currentUser!.emailVerified){
                                print("cc ${auth.currentUser}");
                                timer.cancel();
                                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                                ToastUtil().toast("Mail verified");
                              }
                            });
                            // You can also update the UI if needed, e.g., disable the Resend button for a cooldown period
                          }

                        }
                        else{
                          ToastUtil().toast("Wait 1 min before sending another request");
                        }
                      }
                      else{
                        ToastUtil().toast("already verified");
                      }


                    } catch (e) {
                      // Handle any errors that may occur during email sending
                      ToastUtil().toast("Failed to send verification email: $e");
                    }

                  },
                  child: Center(
                    child: Text(
                      "Resend Verification Link",
                      style: TextStyle(
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.normal,
                        color: Colors.white,
                        fontSize: 11,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ?",
                      style: TextStyle(
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.normal,
                          color: Colors.white),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: (){
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Login()));
                      },
                      child: Text(
                        "Log in",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                  ],),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

