import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_corner/smooth_corner.dart';

import 'Contacts.dart';
import 'FakeCall.dart';
import 'Helpline.dart';
import 'Login.dart';
import 'Recordings.dart';
import 'main.dart';

class NavDrawer extends StatefulWidget {
  const NavDrawer({super.key});

  @override
  State<NavDrawer> createState() => _NavDrawerState();
}

class _NavDrawerState extends State<NavDrawer> {

  var imgLink = "https://i.pinimg.com/564x/98/98/19/9898199841701e52cb871ed12b22204a.jpg";
  var searchCtrl = TextEditingController();

  var currIndex = 0;
  var auth = FirebaseAuth.instance;
  var firestore = FirebaseFirestore.instance.collection("Surakshak");

  double NavValue = 0;

  var selectedItemIndex = 0;

  List<Widget> pagesList = [
    Home(),
    Contacts(),
    FakeCall(),
    Recordings(),
    Helpline(),
  ];

  List<IconData> iconsList = [
    CupertinoIcons.house_fill,
    CupertinoIcons.person_2_fill,
    CupertinoIcons.phone_fill,
    CupertinoIcons.recordingtape,
    CupertinoIcons.bookmark_fill,
  ];



  double returnValue(){
    return NavValue;
  }


  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff846DEE),
                  Color(0xff6F56E1)],
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
              ),
            ),
          ),

          SafeArea(
            child: Container(
              width: 220,
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.all(8),
              child: StreamBuilder(
                stream: firestore.doc('Users').collection('UserUids').where("userUid", isEqualTo: auth.currentUser!.uid).snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){


                  if (snapshot.hasError){
                    return Center(child: Text("Something went wrong"));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting){
                    return Center(child: CupertinoActivityIndicator());
                  }
                  if (snapshot.data!.docs.isEmpty){
                    return Center(child: Text("No data found"));
                  }

                  if (snapshot!=null && snapshot.data!=null){
                    return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              DrawerHeader(
                                  decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(color: Colors.white)),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 80,
                                        width: 80,
                                        decoration: ShapeDecoration(
                                          shape: SmoothRectangleBorder(
                                            borderRadius: BorderRadius.circular(20),
                                            smoothness: 1,
                                          ),
                                          color: Colors.amber,
                                        ),
                                        child: Stack(
                                          children: [
                                            SmoothClipRRect(
                                              borderRadius: BorderRadius.circular(20),
                                              smoothness: 1,
                                              child: Image.network(
                                                imgLink,
                                                fit: BoxFit.cover,
                                                height: MediaQuery.of(context).size.height,
                                                width: MediaQuery.of(context).size.width,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 10,),
                                      Text(snapshot.data!.docs[index]['name'], style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15, height: 1.2),),
                                      // Text(snapshot.data!.docs[index]['uniUid'].toString().toUpperCase(), style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 11,),),


                                    ],
                                  )),

                              SizedBox(height: 60,),
                              Container(
                                decoration: selectedItemIndex==1 ? BoxDecoration(
                                  color: Colors.deepPurpleAccent.shade200,
                                  borderRadius: BorderRadius.circular(13),
                                ) : BoxDecoration(),

                                child: ListTile(
                                  onTap: (){
                                    setState(() {
                                      selectedItemIndex=1;
                                    });
                                    print("How to Use");
                                  },
                                  title: Row(
                                    children: [
                                      Icon(CupertinoIcons.bolt_horizontal, color: Colors.white,),
                                      SizedBox(width: 20,),
                                      Text("How to Use", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                decoration: selectedItemIndex==2 ? BoxDecoration(
                                  color: Colors.deepPurple.shade300,
                                  borderRadius: BorderRadius.circular(13),
                                ) : BoxDecoration(),

                                child: ListTile(
                                  onTap: (){
                                    setState(() {
                                      selectedItemIndex=2;
                                    });
                                    print("Feedback");
                                  },
                                  title: Row(
                                    children: [
                                      Icon(CupertinoIcons.dot_square_fill, color: Colors.white,),
                                      SizedBox(width: 20,),
                                      Text("Feeback", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                decoration: selectedItemIndex==3 ? BoxDecoration(
                                  color: Colors.deepPurple.shade300,
                                  borderRadius: BorderRadius.circular(13),
                                ) : BoxDecoration(),

                                child: ListTile(
                                  onTap: (){
                                    setState(() {
                                      selectedItemIndex=3;
                                    });
                                    print("Legal");
                                  },
                                  title: Row(
                                    children: [
                                      Icon(CupertinoIcons.largecircle_fill_circle, color: Colors.white,),
                                      SizedBox(width: 20,),
                                      Text("Legal", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 20,),
                              Container(
                                decoration: selectedItemIndex==4 ? BoxDecoration(
                                  color: Colors.deepPurple.shade300,
                                  borderRadius: BorderRadius.circular(13),
                                ) : BoxDecoration(),

                                child: ListTile(
                                  onTap: (){
                                    setState(() {
                                      selectedItemIndex=4;
                                    });
                                    print("Share");
                                  },
                                  title: Row(
                                    children: [
                                      Icon(CupertinoIcons.share_solid, color: Colors.white,),
                                      SizedBox(width: 20,),
                                      Text("Share", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.normal, color: Colors.white, fontSize: 14, ),),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 250,),

                              InkWell(
                                onTap: (){
                                  auth.signOut();
                                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Login()));
                                },
                                child: Container(
                                  height: 40,
                                  width: 140,
                                  decoration: ShapeDecoration(
                                    shape: SmoothRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      smoothness: 1,
                                    ),
                                    color: Colors.black,
                                  ),
                                  child: Center(child: Text("Log Out", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 12, ),),),
                                ),
                              ),
                            ],
                          );
                        }
                    );
                  }

                  // print(snapshot.data!.docs[0]['b']);
                  return Container();
                },
              ),
            ),
          ),


          GestureDetector(
            onTap: (){
              if (NavValue==1){
                setState(() {
                  NavValue=0;
                });
              }
            },
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: NavValue),
              duration: Duration(milliseconds: 500),
              curve: Curves.easeIn,
              builder: (_,double val,__){
                return(
                    Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..setEntry(0, 3, 200*val)
                        ..rotateY((pi/6)*val),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Scaffold(
                          extendBodyBehindAppBar: true,
                          appBar: AppBar(
                            elevation: 0,
                            backgroundColor: Colors.transparent,
                            title: Text('Surakshak', style: TextStyle(color: Colors.black),),
                            centerTitle: true,
                            leading: IconButton(
                              onPressed: () {
                                setState(() {
                                  NavValue == 0 ? NavValue=1 : NavValue=0;
                                });
                              },
                              icon: SvgPicture.asset('assets/icons/hamburgerIcon.svg', height: 80, color: Colors.black,),
                            ),
                          ),
                          body: pagesList[currIndex],
                          extendBody: true,
                          bottomNavigationBar: Padding(
                            padding: EdgeInsets.all(25),
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 15),
                              margin: EdgeInsets.symmetric(horizontal: 30),
                              height: 60,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff785CFF),
                                    Color(0xff4724E3),
                                  ],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white.withOpacity(.1),
                                    blurRadius: 30,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: ListView.builder(
                                itemCount: iconsList.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) => InkWell(
                                  onTap: () {
                                    setState(() {
                                      currIndex = index;
                                    },
                                    );
                                  },
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      AnimatedContainer(
                                        duration: Duration(milliseconds: 1500),
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        margin: EdgeInsets.only(
                                          bottom: index == currIndex ? 0 : 11,
                                          right: 8,
                                          left: 8,
                                        ),
                                        width: 35,
                                        height: index == currIndex ? 5 : 0,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.vertical(
                                            bottom: Radius.circular(50),
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        iconsList[index],
                                        size: 30,
                                        color: index == currIndex
                                            ? Colors.white
                                            : Color(0xFFF0EEFB),
                                      ),
                                      SizedBox(height: 14),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ),
                      ),
                    )
                );
              },
            ),
          ),

          // GestureDetector(
          //   onHorizontalDragUpdate: (e){
          //     if (e.delta.dx>0){
          //       setState(() {
          //         NavValue=1;
          //       });
          //     }
          //     else{
          //       setState(() {
          //         NavValue=0;
          //       });
          //     }
          //   },
          // ),
        ],
      ),
    );
  }
}

