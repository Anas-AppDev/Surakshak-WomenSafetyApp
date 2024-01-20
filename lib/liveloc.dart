

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';


class liveloc extends StatefulWidget {
  const liveloc({super.key});

  @override
  State<liveloc> createState() => _livelocState();
}

class _livelocState extends State<liveloc> {


  Location locCtrl = new Location();
  final Completer<GoogleMapController> mapCtrl = Completer<GoogleMapController>();
  static const LatLng changigarhuni = LatLng (30.772901, 76.575102);
  static const LatLng chitkarauni = LatLng (30.51599430091543, 76.65997222203006);
  LatLng? currP = null;

  Map<PolylineId, Polyline> polylines = {};

  initState(){
    super.initState();

    getLocUpdates().then((_)
    => getPloylinePoints().then((coordinates) => {
      generatePolylineFromPoints(coordinates),
      // print("Polyline coordinates : ${coordinates}"),
    }));
  }

  Future<void> camera2postion (LatLng pos) async {
    final GoogleMapController controller = await mapCtrl.future;
    CameraPosition newCamPos = CameraPosition(
        target: pos,
      zoom: 14
    );

    await controller.animateCamera(CameraUpdate.newCameraPosition(newCamPos));
  }

  Future<void> getLocUpdates() async{

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await locCtrl.serviceEnabled();

    if (serviceEnabled) {
      serviceEnabled =  await locCtrl.requestService();
    }
    else{
      return;
    }

    permissionGranted = await locCtrl.hasPermission();
    if (permissionGranted == PermissionStatus.denied){
      permissionGranted = await locCtrl.requestPermission();
      if (permissionGranted != PermissionStatus.granted){
        return;
      }
    }

    locCtrl.onLocationChanged.listen((LocationData currentLocation) {
      if (currentLocation.latitude != null && currentLocation.longitude != null){
        setState(() {
          currP = LatLng(currentLocation.latitude!, currentLocation.longitude!);
          print(currP);

          camera2postion(currP!);
        });
      }
    });
  }

  Future<List<LatLng>> getPloylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates("AIzaSyAMa82-fdWqfLvoLHjQ7C4gL8oPVwsO1CM", PointLatLng(chitkarauni!.latitude, chitkarauni!.longitude), PointLatLng(changigarhuni.latitude, changigarhuni.longitude), travelMode: TravelMode.driving);

    if (result.points.isNotEmpty){
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }

  void generatePolylineFromPoints(List<LatLng> polylineCoordinates) async{
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(polylineId: id, color: Colors.deepPurpleAccent, points: polylineCoordinates, width: 9);
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currP==null ? Center(child: CircularProgressIndicator()) : GoogleMap(
        initialCameraPosition: CameraPosition (
            target: currP!,
            zoom: 14
        ),
        onMapCreated: ( (GoogleMapController controller) => mapCtrl.complete(controller)) ,
        markers: {
          Marker(
            markerId: MarkerId("current location"),
            position: currP!,
          ),
          Marker(
            markerId: MarkerId("destination location"),
            position: changigarhuni!,
          ),
          Marker(
            markerId: MarkerId("initial location"),
            position: chitkarauni,
          ),
        },
        polylines: Set<Polyline>.of(polylines.values),
      ),
    );
  }
}



// `https://maps.googleapis.com/maps/api/staticmap?center=30.772901,76.575102&zoom=14&size=400x400&markers=color:blue%7Clabel:C%7C30.772901,76.575102&markers=color:red%7Clabel:D%7C30.51599430091543,76.65997222203006&path=color:0x0000ff|weight:5|30.51599430091543,76.65997222203006|30.772901,76.575102`