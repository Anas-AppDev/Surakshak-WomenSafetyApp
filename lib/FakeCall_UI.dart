
import 'package:flutter/material.dart';
import 'package:contacts_service/contacts_service.dart';
import 'NavDrawer.dart';
import 'acceptCall.dart';


class CallUI extends StatefulWidget {
  const CallUI({super.key, Contact? contact});

  @override
  State<CallUI> createState() => _CallUIState();
}

class _CallUIState extends State<CallUI> {


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
          Center(
            child: Column(
              children: [
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Incoming Call",
                  style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontSize: 18,
                      height: 1.2),
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  "Mohd Anas",
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontSize: 30,
                      height: 1.2),
                ),
                SizedBox(
                  height: 280,
                ),
                Icon(
                  Icons.phone,
                  size: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Most Recent Call",
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      color: Colors.white,
                      fontFamily: "Poppins",
                      fontSize: 16,
                      height: 1.2),
                ),
                SizedBox(
                  height: 150,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => AcceptCall(),
                            ),
                          );
                        },
                        child: Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Color(0xff5BBE49),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Icon(
                            Icons.phone,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 150,
                      ),
                      InkWell(
                        onTap: () {
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
                            color: Color(0xffEA3B24),
                            borderRadius: BorderRadius.circular(40.0),
                          ),
                          child: Icon(
                            Icons.call_end,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
