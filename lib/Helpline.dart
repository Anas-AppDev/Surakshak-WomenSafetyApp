import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class Helpline extends StatefulWidget {
  const Helpline({super.key});

  @override
  State<Helpline> createState() => _HelplineState();
}

class _HelplineState extends State<Helpline> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Color(0xffF0EEFB),
          ),
          SingleChildScrollView(

            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 100,
                  ),

                  Text(
                    "Call For Help",
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.black,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D1FF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/helplinecall.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("1091",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Women Helpline",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(
                            width: 20,
                          ),

                          InkWell(
                            onTap: () async{
                              if (await Permission.phone.isGranted) {
                                FlutterPhoneDirectCaller.callNumber("1091");
                              } else {
                                print("Permissions not granted for making a phone call");
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Icon(Icons.phone,color: Colors.black,size: 35,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),


                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D1FF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/children.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("1098",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Children Helpline",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          InkWell(
                            onTap: () async{
                              if (await Permission.phone.isGranted) {
                                FlutterPhoneDirectCaller.callNumber("1098");
                              } else {
                                print("Permissions not granted for making a phone call");
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Icon(Icons.phone,color: Colors.black,size: 35,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D1FF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/accident.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("1073",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Road Accident",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(
                            width: 90,
                          ),
                          InkWell(
                            onTap: () async{
                              if (await Permission.phone.isGranted) {
                                FlutterPhoneDirectCaller.callNumber("1073");
                              } else {
                                print("Permissions not granted for making a phone call");
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Icon(Icons.phone,color: Colors.black,size: 35,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),


                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D1FF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/train.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("182",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Railway protection",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(
                            width: 60,
                          ),
                          InkWell(
                            onTap: () async{
                              if (await Permission.phone.isGranted) {
                                FlutterPhoneDirectCaller.callNumber("182");
                              } else {
                                print("Permissions not granted for making a phone call");
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Icon(Icons.phone,color: Colors.black,size: 35,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),


                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D1FF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/police.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("100",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Police",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(
                            width: 150,
                          ),
                          InkWell(
                            onTap: () async{
                              if (await Permission.phone.isGranted) {
                                FlutterPhoneDirectCaller.callNumber("100");
                              } else {
                                print("Permissions not granted for making a phone call");
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Icon(Icons.phone,color: Colors.black,size: 35,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D1FF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/ambulance.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("108",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Ambulance",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(
                            width: 110,
                          ),
                          InkWell(
                            onTap: () async{
                              if (await Permission.phone.isGranted) {
                                FlutterPhoneDirectCaller.callNumber("108");
                              } else {
                                print("Permissions not granted for making a phone call");
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Icon(Icons.phone,color: Colors.black,size: 35,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 100,
                    width: 350,
                    decoration: BoxDecoration(
                      color: Color(0xffD9D1FF),
                      borderRadius: BorderRadius.circular(25.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Row(
                        children: [
                          Image.asset(
                            "assets/images/pregnant.png",
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 25,
                              ),
                              Text("102",style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w700),),
                              SizedBox(
                                height: 5,
                              ),
                              Text("Pregnancy Medic",style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                  fontFamily: "Poppins",
                                  fontWeight: FontWeight.w400),)
                            ],
                          ),
                          SizedBox(
                            width: 70,
                          ),
                          InkWell(
                            onTap: () async{
                              if (await Permission.phone.isGranted) {
                                FlutterPhoneDirectCaller.callNumber("102");
                              } else {
                                print("Permissions not granted for making a phone call");
                              }
                            },
                            child: Container(
                              height: 60,
                              width: 60,
                              decoration: BoxDecoration(
                                color: Color(0xffffffff),
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              child: Icon(Icons.phone,color: Colors.black,size: 35,),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),


                  SizedBox(height: 140,),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
