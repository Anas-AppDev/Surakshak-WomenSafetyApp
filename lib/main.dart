import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:alan_voice/alan_voice.dart';
import 'package:chitkara/liveloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shake/shake.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';
import 'package:telephony/telephony.dart';
import 'package:vibration/vibration.dart';

import 'NavDrawer.dart';
import 'SplashPage.dart';
import 'ToastUtil.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Permission.phone.request();
  await Permission.sms.request();
  await Permission.location.request();

  runApp(MaterialApp(
    home: SplashPage(),
  ));
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  _HomeState() {
    AlanVoice.addButton("4e300df7e3335cefbdae850e8767c4e12e956eca572e1d8b807a3e2338fdd0dc/stage", buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT);

    AlanVoice.onCommand.add((command) => handleCommand(command.data));

  }

  void handleCommand(Map<String, dynamic> command){

    switch(command["command"]){
      case "activateSos":
        sendLocation();
        break;
      case "deactivateSos":
        stopLocation();
        break;
      case "sendphoto":
        sendPhoto(source: ImageSource.camera);
        break;
      case "sendvideo":
        sendVideo(source: ImageSource.camera);
        break;
      default:
        print("unknown command");
    }
  }

  var destCtrl =  TextEditingController();


  var initialDistance=1000;
  var lastCheckedDistance;
  var shouldVibrate = false;

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

    // initialDistance = calculateDistance(currLat, currLong, destLat, destLong);
    destLocation.toString()!=null ? initialDistance = 100 : null;

    Timer.periodic(Duration(seconds: 5), (Timer timer) {
      getCurrLoc();
      gmapLink = "https://www.google.com/maps/place/$currLat,$currLong";
      print(currLat.toString() + " " + currLong.toString());

      // calculateDistance(currLat, currLong, destLat, destLong)
      double currentDistance = destLocation.toString()!=null ? 101 : 0.0;
      // print(destCoordinates.toString() + "descoor");
      // print(destLocation.toString() + "desloc");

      print("Current Distance  = $currentDistance");

      // Check if the current distance exceeds the initial distance
      if (currentDistance > initialDistance && shouldVibrate==true) {
        print("exceeded");
        Vibration.vibrate(duration: 2000);
      }

      // Update lastCheckedDistance with the current distance
      lastCheckedDistance = currentDistance;
    });


    // Timer.periodic(Duration(seconds: 5), (Timer timer2) {
    //   getCurrLoc();
    //   gmapLink = "https://www.google.com/maps/place/$currLat,$currLong";
    //   print(currLat.toString()+" "+currLong.toString());
    // });
    goToCurrentLoc();
    marker.addAll(markerList);
  }

  @override
  void dispose() {
    super.dispose();
    detector.stopListening();
    shouldVibrate = false;
  }

  double calculateDistance(double startLat, double startLng, double endLat, double endLng) {
    double distance = Geolocator.distanceBetween(startLat, startLng,
        endLat, endLng);
    return distance;
  }

  var gmapLink = "https://www.google.com/maps/place/29.2839,78.8281";
  var firestore = FirebaseFirestore.instance.collection("Surakshak");
  var auth = FirebaseAuth.instance;
  var detector;

  var currLat=29.2839;
  var currLong=78.8281;
  var currCoordinates;
  var destCoordinates;
  var destLat=29.2839;
  var destLong=78.8281;

  late Timer smsTimer;

  List<Marker> marker = [];
  List<Marker> markerList = [
    Marker(markerId: MarkerId('1'), position: LatLng(37.42796133580664, -122.085749655962), infoWindow: InfoWindow(title: "target")),
  ];

  Completer<GoogleMapController> mapCtrl = Completer();
  var initLocation = CameraPosition(target: LatLng(30.518221, 76.659012), zoom: 14,);
  var destLocation;


  Future<void> getDestLoc(String address) async{
    if (address.isNotEmpty) {
      try {
        List<Location> locations = await locationFromAddress(address,
            localeIdentifier: 'en_US');
        if (locations.isNotEmpty) {
          setState(() {
            destLat = locations.first.latitude;
            destLong = locations.first.longitude;

            print("Destination = $destLat");
            print("Destination = $destLong");
          });
        } else {
          print('No location found for the given address');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
    marker.removeWhere((m) => m.markerId.value == '3');
    marker.add(Marker(markerId: MarkerId('3'), position: LatLng(destLat, destLong), infoWindow: InfoWindow(title: "Destination Location")),);

    destLocation = CameraPosition(
      target: LatLng(destLat, destLong),
      zoom: 11,
    );
  }

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
  void goToDestLoc() async{



    await getCurrLoc().then((value) async{

      GoogleMapController ctrl = await mapCtrl.future;
      ctrl.animateCamera(CameraUpdate.newCameraPosition(
          destLocation
      ));

    });

  }

  void sendLocation() async{

    ToastUtil().toast("SOS Triggered");
    smsTimer = Timer.periodic(Duration(seconds: 15), (Timer timer) async{
      var query = await firestore.doc("Users").collection("UserUids").doc(auth.currentUser!.uid).collection("Contacts").get();
      query.docs.forEach((doc) async {
        var iPhone = doc.data()["iPhone"];
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: 320,
                    height: 50,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Color(0xffF5F5F5),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: destCtrl,
                            decoration: InputDecoration(
                              hintText: "   Enter Destination...",
                              border: InputBorder.none,
                            ),
                            onChanged: (value){
                              setState(() {

                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () async{
                      // goToCurrentLoc();
                      await getDestLoc(destCtrl.text.trim().toString());
                      goToDestLoc();

                      var ans  = calculateDistance(currLat, currLong, destLat, destLong);
                      print("ans = " + ans.toString());

                      setState(() {
                        shouldVibrate = true;
                      });

                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Color(0xffF5F5F5),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(Icons.send),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Column(
                    children: [
                      InkWell(
                        onTap: (){
                          sendPhoto(source: ImageSource.camera);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                            color: Color(0xff846DEE),
                          ),
                          child: Icon(CupertinoIcons.photo_camera_solid, color: Colors.white,),
                        ),
                      ),
                      SizedBox(height: 1,),
                      InkWell(
                        onTap: (){
                          sendVideo(source: ImageSource.camera);
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(bottom: Radius.circular(8)),
                            color: Color(0xff846DEE),
                          ),
                          child: Icon(CupertinoIcons.video_camera_solid, color: Colors.white, size: 30,),
                        ),
                      ),
                      SizedBox(height: 10,),
                      InkWell(
                        onTap: (){
                          goToCurrentLoc();
                        },
                        child: Container(
                          height: 45,
                          width: 45,
                          child: Icon(CupertinoIcons.map_pin_ellipse, color: Colors.deepPurple,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 15,),
                ],
              ),

              SizedBox(height: 300,),
              RippleAnimation(
                child: InkWell(
                  onTap: (){
                    makeCall("8171592676");
                    sendLocation();
                  },
                  onLongPress: (){
                    setState(() {
                      shouldVibrate = false;
                      stopLocation();
                      print("sms stopped");
                    });
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Colors.red,
                    ),
                    child: Center(child: Text("SOS", style: TextStyle(fontFamily: "Poppins", fontWeight: FontWeight.bold, color: Colors.white, fontSize: 24, ),),),
                  ),
                ),
                color: Colors.red,
                delay: const Duration(milliseconds: 0),
                repeat: true,
                minRadius: 50,
                ripplesCount: 12,
                duration: const Duration(milliseconds: 5000),
              ),


            ],
          ),
        ]
      ),
    );
  }
}

class AutoDropdown extends StatefulWidget {
  TextEditingController ctrl;
  List list;
  String? listSelected;
  String? hint;
  double widths;

  AutoDropdown(
      {required this.ctrl,
        required this.list,
        required this.listSelected,
        required this.widths,
        required this.hint});

  @override
  State<AutoDropdown> createState() => _AutoDropdownState();
}

class _AutoDropdownState extends State<AutoDropdown> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.widths, // Adjust the width as needed
      child: TypeAheadFormField(
        hideSuggestionsOnKeyboardHide: true,
        textFieldConfiguration: TextFieldConfiguration(
          controller: widget.ctrl,
          style: TextStyle(color: Colors.black, fontSize: 16),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(
              fontFamily: "Poppins",
              color: Color(
                  0xff846DEE), // Change this color to your desired hint text color
            ),
            border: InputBorder.none,
            suffixIcon: Icon(
              Icons.keyboard_arrow_down,
              color: Color(0xff846DEE),
              size: 30,
            ),
          ),
        ),
        suggestionsCallback: (pattern) {
          return widget.list.where(
                  (color) => color.toLowerCase().contains(pattern.toLowerCase()));
        },
        itemBuilder: (context, suggestion) {
          return Column(
            children: [
              ListTile(
                title: Text(suggestion),
              ),
              Container(
                height: 1,
                width: widget.widths - 10,
                color: Colors.grey, // Set the color of the divider line
              ),
            ],
          );
        },
        onSuggestionSelected: (suggestion) {
          setState(() {
            widget.listSelected = suggestion;
            widget.ctrl.text = suggestion;
          });
        },
      ),
    );
  }
}

class listServices {
  //13 colors
  var contactList = [
    'Mother',
    'Father',
    'Brother',
    'Sister',
    'Friend',
    'Family Member',
    'Mentor',
    'Unknown'
  ];

}
