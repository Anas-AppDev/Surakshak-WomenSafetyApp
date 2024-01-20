import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Contacts.dart';
import 'ToastUtil.dart';
import 'main.dart';

class AddContact extends StatefulWidget {
  const AddContact({super.key});

  @override
  State<AddContact> createState() => _AddContactState();
}

class _AddContactState extends State<AddContact> {

  late String currDate;
  var firestore = FirebaseFirestore.instance.collection("Surakshak");
  var auth = FirebaseAuth.instance;

  var formKey = GlobalKey<FormState>();

  var iNameCtrl = TextEditingController();
  var iTypeCtrl = TextEditingController();
  var iPhoneCtrl = TextEditingController();

  late String cid;

  String? typeListSelected = null;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor:
          Colors.transparent, // Make the AppBar background transparent
          leading: BackButton(color: Color(0xffffffff)),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff785CFF),
                  Color(0xff4724E3)],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xff785CFF),
                  Color(0xff4724E3),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 30,),
                Text("Add", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),
                Text("Contact", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 40, height: 1.2),),



                Form(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 40,),
                      Text("  Contact Name", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
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
                                keyboardType: TextInputType.text,
                                controller: iNameCtrl,
                                decoration: InputDecoration(
                                  prefixText: "   ",
                                  hintText: "Contact Name",
                                  hintStyle: TextStyle(
                                    fontFamily: "Poppins",
                                    color: Color(0xff785CFF), // Change this color to your desired hint text color
                                  ),
                                  border: InputBorder.none,
                                ),
                                maxLines: 1,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Item Name required";
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30,),
                      Text("  Contact Type", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
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
                            SizedBox(width: 15,),
                            Expanded(
                              child: AutoDropdown(ctrl: iTypeCtrl, list: listServices().contactList, listSelected: typeListSelected, widths: 300, hint: "Type"),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 30,),
                      Text("  Phone Number", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),),
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
                                  hintText: "Phone Number",
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
                    ],
                  ),
                  key: formKey,
                ),









                SizedBox(height: 161,),
                InkWell(
                  onTap: () {
                    if (formKey.currentState!.validate()){
                      cid = DateTime.now().microsecondsSinceEpoch.toString();
                      // currDate = DateFormat('d MMMM y').format(DateTime.now());

                      firestore.doc("Users").collection("UserUids").doc(auth.currentUser!.uid).collection("Contacts").doc(cid).set(
                          {
                            "iName": iNameCtrl.text,
                            "iType": (iTypeCtrl.text)!=null && iTypeCtrl.text.isNotEmpty ? (iTypeCtrl.text) : "Unknown",
                            "iPhone": iPhoneCtrl.text ?? "",
                            "userUid": auth.currentUser!.uid,
                            "cid": cid
                          }
                      );

                      print(cid);
                      ToastUtil().toast("Contact Added");
                      // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Contacts()));

                    }
                  },
                  child: Center(
                    child: Container(
                      height: 60,
                      width: 240,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(21)),
                      child: Center(
                        child: Text(
                          'Add',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),

              ],
            ),
          ),
        )
    );
  }
}
