
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'FakeCall_UI.dart';



class FakeCall extends StatefulWidget {
  const FakeCall({super.key});

  @override
  State<FakeCall> createState() => _FakeCallState();
}

class _FakeCallState extends State<FakeCall> {


  final timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final timeController = TextEditingController();
    return Scaffold(
      body:
      SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              color: Color(0xffffffff),
            ),
            Center(
              child: Column(
                children: [

                  SizedBox(
                    height: 120,
                  ),
                  Container(
                    height: 400,
                    width: 400,
                    child: Lottie.asset("assets/lottie/purple_lottie.json",height: 400, width: 400 ,repeat: true),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 250,
                    decoration: BoxDecoration(
                      color: Color(0xffeeeeee),
                      borderRadius:
                      BorderRadius.circular(20.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0),
                      child: TextFormField(
                        keyboardType:
                        TextInputType.number,
                        controller: timeController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Time",
                          hintStyle: TextStyle(
                            fontFamily: "Poppins",
                            color: Color(0xff9b9b9b),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () async{

                      final textValue = timeController.text;
                      if (textValue.isNotEmpty) {
                        final int? seconds = int.tryParse(textValue);
                        if (seconds != null) {
                          await Future.delayed(Duration(seconds: seconds), () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => CallUI(),
                              ),
                            );
                          });
                        } else {
                          // Handle the case where the input is not a valid integer.
                          print("Invalid input for seconds.");
                        }
                      } else {
                        // Handle the case where the input is empty.
                        print("Please enter a value for seconds.");
                      }

                    },
                    child: Container(
                      height: 50,
                      width: 100,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.topRight,
                          colors: [
                            Color(0xff654CDC),
                            Color(0xff947FF6),
                          ],
                        ),
                        borderRadius:
                        BorderRadius.circular(22.0),
                      ),
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("Save",style: TextStyle(
                              fontFamily: "Poppins",fontWeight: FontWeight.w600,fontSize: 16,color: Colors.white
                          ),)),
                    ),
                  ),
                ],

              ),
            )
          ],
        ),
      ),
    );
  }
}

