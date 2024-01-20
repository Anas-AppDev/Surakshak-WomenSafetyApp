import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Recordings extends StatefulWidget {
  const Recordings({super.key});

  @override
  State<Recordings> createState() => _RecordingsState();
}

class _RecordingsState extends State<Recordings> {

  final searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,

      body: Stack(
        children: [
          Container(
            color: Color(0xffF0EEFB),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 110,
                ),
                Row(
                  children: [
                    Container(
                      width: 270,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Color(0xffffffff),
                      ),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                            child: InkWell(
                                onTap: () {},
                                child: Icon(CupertinoIcons.search)),
                          ),
                          Expanded(
                            child: TextField(
                              controller: searchController,
                              decoration: InputDecoration(
                                hintText: "Search recording here....",
                                border: InputBorder.none,
                              ),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff5736EC).withOpacity(.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: Offset(2, 2),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SvgPicture.asset(
                        'assets/icons/add.svg',
                        height: 50,
                        color: Color(0xff5736EC),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    "May 2023",
                    style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontFamily: "Poppins",
                        fontSize: 16,
                        color: Color(0xff5736EC),
                        height: 1.2),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  height: 75,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Stack(children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Color(0xffD9D1FF),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Icon(Icons.play_arrow_rounded,color:Color(0xff5736EC),size: 40,),
                          ),
                        ]),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Kharar",style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Color(0xff000000),
                                height: 1.2),),
                            SizedBox(
                              height: 5,
                            ),
                            Text("21 Oct 2023 | 11:11",style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Color(0xff5736EC),
                                height: 1.2),),
                          ],
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("5.21.45s",style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Color(0xff5736EC),
                              height: 1.2),),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  height: 75,
                  width: 340,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Row(
                      children: [
                        Stack(children: [
                          Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              color: Color(0xffD9D1FF),
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                            child: Icon(Icons.play_arrow_rounded,color:Color(0xff5736EC),size: 40,),
                          ),
                        ]),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Text("Kharar",style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 16,
                                color: Color(0xff000000),
                                height: 1.2),),
                            SizedBox(
                              height: 5,
                            ),
                            Text("21 Oct 2023 | 12:08",style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Color(0xff5736EC),
                                height: 1.2),),
                          ],
                        ),
                        SizedBox(
                          width: 60,
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Text("10.00.45s",style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Color(0xff5736EC),
                              height: 1.2),),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
