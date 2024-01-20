import 'dart:async';
import 'dart:io';

import 'package:chitkara/Newly/SeeContacts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:telephony/telephony.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../ToastUtil.dart';
  import 'package:dio/dio.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {

  Future<String> calculateDistance(double currentLatitude, double currentLongitude, double destinationLatitude, double destinationLongitude) async {
    // Calculate distance using the Haversine formula
    double distanceInMeters = await Geolocator.distanceBetween(
      currentLatitude, currentLongitude,
      destinationLatitude, destinationLongitude,
    );

    return ('Distance: ${distanceInMeters / 1000} kilometers').toString(); // Convert to kilometers
  }

  List<Marker> markers = [];
  List<Polyline> polylines = [];

  void addMarker(LatLng position, String markerId) {
    Marker marker = Marker(
      markerId: MarkerId(markerId),
      position: position,
      infoWindow: InfoWindow(title: markerId),
    );

    setState(() {
      markers.add(marker);
    });
  }

  void drawPolyline(LatLng source, LatLng destination) {
    Polyline polyline = Polyline(
      polylineId: PolylineId('poly'),
      color: Colors.blue,
      points: [source, destination],
    );

    setState(() {
      polylines.add(polyline);
    });
  }

  @override
  void initState() {
    super.initState();

    detector = ShakeDetector.autoStart(
        onPhoneShake: () {
          print("Shake Experienced");
          sendLocation();
        },
        shakeThresholdGravity: 10
    );

    Timer.periodic(Duration(seconds: 5), (Timer timer2) {
      getCurrLoc();
      gmapLink = "https://www.google.com/maps/place/$currLat,$currLong";
      print(currLat.toString()+" "+currLong.toString());
    });
    goToCurrentLoc();
    marker.addAll(markerList);

    fetchiPhone();
  }

  @override
  void dispose() {
    super.dispose();
    detector.stopListening();
  }

  var gmapLink = "https://www.google.com/maps/place/29.2839,78.8281";
  var firestore = FirebaseFirestore.instance.collection("Surakshak");
  var auth = FirebaseAuth.instance;
  var detector;

  var currLat=29.2839;
  var currLong=78.8281;
  var currCoordinates;

  late Timer smsTimer;

  List<Marker> marker = [];
  List<Marker> markerList = [
    Marker(markerId: MarkerId('1'), position: LatLng(37.42796133580664, -122.085749655962), infoWindow: InfoWindow(title: "target")),
  ];

  var iPhone;

  Future<void> fetchiPhone() async {
    try {
      DocumentSnapshot snapshot = await firestore.doc("Users").collection("Contacts (Call)")
          .doc('CallingNo')
          .get();

      if (snapshot.exists) {
        // Access the value of the specific key
        iPhone = snapshot['iPhone'];
        setState(() {}); // Update the UI with the fetched data
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  Completer<GoogleMapController> mapCtrl = Completer();
  var initLocation = CameraPosition(target: LatLng(29.2839, 78.8281), zoom: 14,);

  Future<Position> getCurrLoc() async{
    // await Geolocator.requestPermission().then((value) async{

    currCoordinates = await Geolocator.getCurrentPosition();

    if (mounted){
      setState(() {
        currLat = currCoordinates.latitude;
        currLong = currCoordinates.longitude;
        marker.removeWhere((m) => m.markerId.value == '2');
        marker.add(Marker(markerId: MarkerId('2'), position: LatLng(currLat, currLong), infoWindow: InfoWindow(title: "Current Location")),);

        initLocation = CameraPosition(
          target: LatLng(currLat, currLong),
          zoom: 14,
        );

      });
    }


    // }).onError((error, stackTrace) async{
    //   await Geolocator.requestPermission();
    //   print("Error fetching current location");
    // });

    return currCoordinates;
  }

  void goToCurrentLoc() async{


    await getCurrLoc().then((value) async{

      GoogleMapController ctrl = await mapCtrl.future;
      ctrl.animateCamera(CameraUpdate.newCameraPosition(
          initLocation
      ));

    });

  }

  void sendLocation() async{

    ToastUtil().toast("SOS Triggered");
    smsTimer = Timer.periodic(Duration(seconds: 15), (Timer timer) async{
      var query = await firestore.doc("Users").collection("Contacts (Msg)").get();
      query.docs.forEach((doc) async {
        var iPhone = doc.data()["iMsg"];
        await sendSms(gmapLink, iPhone);
      });
    });

  }

  void stopLocation(){
    ToastUtil().toast("SOS Stopped");
    smsTimer.cancel();
  }


  File? photoVideoFile;
  var downloadUrl;

  void sendVideo({required ImageSource source}) async{

    var pickedImg = await ImagePicker().pickVideo(source: source, maxDuration: Duration(seconds: 15));

    if (pickedImg != null){
      setState(() {
        photoVideoFile = File(pickedImg.path);
      });

      print("photoVideoFile :"+photoVideoFile.toString());
      await uploadVideoToFirebaseStorage(photoVideoFile!);
    }
    else{
      print("Pick a video");
    }
  }

  void sendPhoto({required ImageSource source}) async{
    var pickedImg = await ImagePicker().pickImage(source: source);

    if (pickedImg != null){
      setState(() {
        photoVideoFile = File(pickedImg.path);
      });

      print("photoVideoFile :"+photoVideoFile.toString());
      await uploadPhotoToFirebaseStorage(photoVideoFile!);
    }
    else{
      print("Pick an image");
    }
  }


  Future<void> uploadPhotoToFirebaseStorage(File file) async {
    try {
      var fstorage = FirebaseStorage.instance;
      Reference storageReference = fstorage.ref().child('Surakshak/Photos/${DateTime.now()}');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      downloadUrl = await taskSnapshot.ref.getDownloadURL();

      var query = await firestore.doc("Users").collection("UserUids").doc(auth.currentUser!.uid).collection("Contacts").get();
      query.docs.forEach((doc) async {
        var iPhone = doc.data()["iPhone"];
        await sendSms("Photo :"+downloadUrl, iPhone);
      });


    } catch (e) {
      ToastUtil().toast("Photo not uploaded to Firebase");
    }
  }
  Future<void> uploadVideoToFirebaseStorage(File file) async {
    try {
      var fstorage = FirebaseStorage.instance;
      Reference storageReference = fstorage.ref().child('Surakshak/Videos/${DateTime.now()}');
      UploadTask uploadTask = storageReference.putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

      downloadUrl = await taskSnapshot.ref.getDownloadURL();

      print("downloadUrl :"+downloadUrl);

      var query = await firestore.doc("Users").collection("UserUids").doc(auth.currentUser!.uid).collection("Contacts").get();
      query.docs.forEach((doc) async {
        var iPhone = doc.data()["iPhone"];
        await sendSms("Video :"+downloadUrl, iPhone);
      });


    } catch (e) {
      ToastUtil().toast("Video not uploaded to Firebase");
    }
  }

  Future<void> sendSms(String msg, String iPhone) async{
    if (await Permission.sms.status.isGranted){
      final Telephony telephony = Telephony.instance;
      // var permissionsGranted = await telephony.requestPhoneAndSmsPermissions;
      telephony.sendSms(
        to: iPhone,
        message: msg,
        isMultipart: true,
      );
      print("sms sent to $iPhone");
    }
    else{
      print("Permissions not given for sms");
    }

  }

  void makeCall(String number) async{

    if (await Permission.phone.isGranted) {
      FlutterPhoneDirectCaller.callNumber("+91"+number);
    } else {
      print("Permissions not granted for making a phone call");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: initLocation,
              mapType: MapType.terrain,
              compassEnabled: true,
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              markers: Set<Marker>.of(marker),
              polylines: Set<Polyline>.from(polylines),
              onMapCreated: (GoogleMapController controller){
                mapCtrl.complete(controller);
              },
              circles: {
                Circle(
                  circleId: CircleId('geo_fence_1'),
                  center: LatLng(currLat, currLong),
                  radius: 1000,
                  strokeWidth: 2,
                  strokeColor: Color(0xff846DEE),
                  fillColor: Color(0xff846DEE).withOpacity(0.15),
                ),
              },
            ),

            Column(
              children: [
                SizedBox(height: 100,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Column(
                    //   children: [
                    //     InkWell(
                    //       onTap: (){
                    //         sendPhoto(source: ImageSource.camera);
                    //       },
                    //       child: Container(
                    //         height: 45,
                    //         width: 45,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                    //           color: Color(0xff846DEE),
                    //         ),
                    //         child: Icon(CupertinoIcons.photo_camera_solid, color: Colors.white,),
                    //       ),
                    //     ),
                    //     SizedBox(height: 1,),
                    //     InkWell(
                    //       onTap: (){
                    //         sendVideo(source: ImageSource.camera);
                    //       },
                    //       child: Container(
                    //         height: 45,
                    //         width: 45,
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                    //           color: Color(0xff846DEE),
                    //         ),
                    //         child: Icon(CupertinoIcons.video_camera_solid, color: Colors.white, size: 30,),
                    //       ),
                    //     ),
                    //     SizedBox(height: 10,),
                    //     InkWell(
                    //       onTap: (){
                    //         goToCurrentLoc();
                    //       },
                    //       child: Container(
                    //         height: 45,
                    //         width: 45,
                    //         child: Icon(CupertinoIcons.map_pin_ellipse, color: Colors.deepPurple,),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(width: 15,),
                  ],
                ),

                SizedBox(height: 550,),
                InkWell(
                  onTap: (){
                    makeCall(iPhone);
                    sendLocation();
                  },
                  onLongPress: (){
                    stopLocation();
                    print("sms stopped");
                  },
                  child: Container(
                    width: 120,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.black,
                    ),
                    child: Center(child: Text("SOS", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24, ),),),
                  ),
                ),
                SizedBox(height: 10,),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> SeeContacts()));
                }, child: Text("See Contacts")),

                ElevatedButton(onPressed: () async{
                  String apiKey = 'AIzaSyAMa82-fdWqfLvoLHjQ7C4gL8oPVwsO1CM';
                  String origin = '30.51736,76.66001';
                  String destination = '30.76891,76.57540';

                  var lat1 = 30.51736;
                  var long1 = 76.66001;

                  var lat2 = 30.76891;
                  var long2 = 76.57540;

                  String result2 = await calculateDistance(lat1, long1, lat2, long2);
                  // String result = await getDistance(origin, destination, apiKey);

                  LatLng source2 = LatLng(lat1, long1); // Source coordinates
                  LatLng destination2 = LatLng(lat2, long2); // Destination coordinates

                  addMarker(source2, 'Source');
                  addMarker(destination2, 'Destination');
                  drawPolyline(source2, destination2);


                }, child: Text("Calculate Distance")),
              ],
            ),
          ]
      ),
    );
  }
}
