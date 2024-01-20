import 'dart:async';
import 'package:flutter/material.dart';

import 'NavDrawer.dart';


class AcceptCall extends StatefulWidget {
  const AcceptCall({super.key});

  @override
  State<AcceptCall> createState() => _AcceptCallState();
}

class _AcceptCallState extends State<AcceptCall> {

  late Timer _timer;
  int _seconds = 0;


  void initState() {
    super.initState();

    // Start the timer when the screen is loaded
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _seconds++;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    "Mohd Anas",
                    style: TextStyle(
                        fontWeight: FontWeight.w600,color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 30,
                        height: 1.2),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Text(
                    "+91 7060997580",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,color: Colors.white,
                        fontFamily: "Poppins",
                        fontSize: 20,
                        height: 1.2),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          height: 25,
                          width: 50,
                          decoration: BoxDecoration(
                            color: Color(0xffffffff),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Center(
                            child: Text("HD",style: TextStyle(
                                fontSize: 16,fontFamily: "Poppins",fontWeight: FontWeight.w600,color: Colors.black
                            ),),
                          )
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Center(
                        child: Text(
                          formatTime(_seconds),
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontFamily: "Poppins",
                            fontSize: 20,
                            height: 1.2,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 150,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(width: 20,),
                        Column(
                          children: [
                            Icon(Icons.edit_note_sharp,size: 50,color: Colors.white,),
                            Text(
                              "Notes",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  height: 1.2),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Column(
                          children: [
                            Icon(Icons.add_call,size: 40,color: Colors.white,),
                            SizedBox(height: 15,),
                            Text(
                              "Add Call",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  height: 1.2),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 80,
                        ),
                        Column(
                          children: [
                            Icon(Icons.mic_off,size: 45,color: Colors.white,),
                            SizedBox(height: 13,),
                            Text(
                              "Mute",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  height: 1.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [

                        SizedBox(width: 20,),
                        Column(
                          children: [
                            Icon(Icons.voicemail_rounded,size: 45,color: Colors.white,),
                            SizedBox(height: 10,),
                            Text(
                              "Record",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  height: 1.2),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Column(
                          children: [
                            Icon(Icons.video_call_rounded,size: 45,color: Colors.white,),
                            SizedBox(height: 15,),
                            Text(
                              "Video Call",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  height: 1.2),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 70,
                        ),
                        Column(
                          children: [
                            Icon(Icons.pause,size: 45,color: Colors.white,),
                            SizedBox(height: 13,),
                            Text(
                              "Hold",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,color: Colors.white,
                                  fontFamily: "Poppins",
                                  fontSize: 16,
                                  height: 1.2),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width:50 ,
                      ),
                      Icon(Icons.dialpad_rounded,size: 36,color: Colors.white,),
                      SizedBox(
                        width: 80,
                      ),
                      InkWell(
                        onTap: (){

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => NavDrawer(),
                            ),
                          );

                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xffEA3B24)
                          ),
                          child: Icon(Icons.call_end,color: Colors.white,size: 40,),
                        ),
                      ),
                      SizedBox(
                        width:70,
                      ),
                      Icon(Icons.volume_up,size: 35,color: Colors.white,)
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  String formatTime(int seconds) {
    final int minutes = (seconds ~/ 60);
    final int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
}
