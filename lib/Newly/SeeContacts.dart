import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../ToastUtil.dart';

class SeeContacts extends StatefulWidget {
  const SeeContacts({super.key});

  @override
  State<SeeContacts> createState() => _SeeContactsState();
}

class _SeeContactsState extends State<SeeContacts> {


  late String currDate;
  var firestore = FirebaseFirestore.instance.collection("Surakshak");

  var formKey = GlobalKey<FormState>();

  late String cid;

  String? typeListSelected = null;

  var iPhoneCtrl = TextEditingController();
  var iMsgCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 200,),
            Text("See Contacts"),
            SizedBox(height: 100,),
        
            Text("  Phone Number (Call)", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),),
            SizedBox(height: 8,),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: iPhoneCtrl,
                      decoration: InputDecoration(
                        prefixText: "   ",
                        hintText: "Phone Number (Call)",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xff785CFF), // Change this color to your desired hint text color
                        ),
                        counterText: "",
                        border: InputBorder.none,
                      ),
                      maxLines: 1,
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone No. required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
        
            SizedBox(height: 100,),
        
            Text("  Phone Number (Msg)", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),),
            SizedBox(height: 8,),
            Container(
              height: 50,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: iMsgCtrl,
                      decoration: InputDecoration(
                        prefixText: "   ",
                        hintText: "Phone Number (Msg)",
                        hintStyle: TextStyle(
                          fontFamily: "Poppins",
                          color: Color(0xff785CFF), // Change this color to your desired hint text color
                        ),
                        counterText: "",
                        border: InputBorder.none,
                      ),
                      maxLines: 1,
                      maxLength: 10,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Phone No. required";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
        
            ElevatedButton(onPressed: (){
              cid = DateTime.now().microsecondsSinceEpoch.toString();
              // currDate = DateFormat('d MMMM y').format(DateTime.now());
        
              firestore.doc("Users").collection("Contacts (Call)").doc("CallingNo").set(
                  {
                    "iPhone": iPhoneCtrl.text ?? "",
                  }
              );
              firestore.doc("Users").collection("Contacts (Msg)").doc(cid).set(
                  {
                    "iMsg": iMsgCtrl.text,
                  }
              );
              
              iMsgCtrl.clear();
              print(cid);
              ToastUtil().toast("Contact Added");
            }, child: Text("Add")),
          ],
        ),
      ),
    );
  }
}
