import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

const double CAMERA_ZOOM = 20;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 0;
const LatLng SOURCE_LOCATION = LatLng(22.357302044410176, 114.1278995692894);
const LatLng DEST_LOCATION = LatLng(22.34249454912625, 114.10634636970619);


class GoToParking extends StatefulWidget{
  @override
  _GoParkingPage createState() =>_GoParkingPage();
}

class _GoParkingPage extends State<GoToParking>{

  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> _markers=Set<Marker>();


  // for my drawn routes on the map
  Set<Polyline> _polylines = Set<Polyline>();
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints;

  String googleAPIKey = "AIzaSyAnzKFZ14QeroQ1pKEBMTFoipmt1MrW-r4";

  // for my custom marker pins
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  // the user's initial location and current location
// as it moves
  LocationData currentLocation;
// a reference to the destination location
  LocationData destinationLocation;
// wrapper around the location API
  Location location;

  // bool _serviceEnabled;
  // PermissionStatus _permissionGranted;


  void initState(){
    super.initState();
    // create an instance of Location
    location = new Location();
    polylinePoints = PolylinePoints();
    _initMarkers();

    // subscribe to changes in the user's location
    // by "listening" to the location's onLocationChanged event
    location.onLocationChanged.listen((LocationData cLoc) {
      // cLoc contains the lat and long of the
      // current user's position in real time,
      // so we're holding on to it
      currentLocation = cLoc;

      _initMarkers();
      updatePinOnMap();
  });
  }

  void _initMarkers() async {
    // set the initial location
    await setInitialLocation();
    // set custom marker pins
    await setSourceAndDestinationIcons();
    await showPinsOnMap();

  }

  Future<void> setSourceAndDestinationIcons() async {


      sourceIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          'assets/images/driving_pin.png');

      destinationIcon = await BitmapDescriptor.fromAssetImage(
          ImageConfiguration(devicePixelRatio: 2.5),
          'assets/images/destination_map_marker.png');
    }

  Future<void> setInitialLocation() async {
   /*_serviceEnabled = await location.serviceEnabled();
   if (!_serviceEnabled) {
     _serviceEnabled = await location.requestService();
     if (!_serviceEnabled) {
       return;
     }
   }
   _permissionGranted = await location.hasPermission();
   if (_permissionGranted == PermissionStatus.denied) {
     _permissionGranted = await location.requestPermission();
     if (_permissionGranted != PermissionStatus.granted) {
       return;
     }
   }*/


    // set the initial location by pulling the user's
    // current location from the location's getLocation()
    currentLocation = await location.getLocation();

    // hard-coded destination for this example
    destinationLocation = LocationData.fromMap({
      "latitude": DEST_LOCATION.latitude,
      "longitude": DEST_LOCATION.longitude
    });
  }



  @override
  Widget build(BuildContext context) {



     CameraPosition initialCameraPosition =CameraPosition(
        zoom: CAMERA_ZOOM,
        tilt: CAMERA_TILT,
        bearing: CAMERA_BEARING,
        target: SOURCE_LOCATION
    );

    if (currentLocation != null) {
      initialCameraPosition = CameraPosition(
          target: LatLng(currentLocation.latitude,
              currentLocation.longitude),
          zoom: CAMERA_ZOOM,
          tilt: CAMERA_TILT,
          bearing: CAMERA_BEARING
      );
    }

     return Scaffold(
       appBar: AppBar(
         leading: IconButton(
           icon: Icon(Icons.arrow_back_ios),
           iconSize: 20.0,
           color: Colors.black,
           onPressed: () {
             Navigator.pop(context);
           },
         ),
         centerTitle: true,
         title: Text('Go To Parking',style: TextStyle(color: Colors.black),),
         backgroundColor: Colors.white,
       ),
       body: Stack(
         children: <Widget>[
           GoogleMap(
               rotateGesturesEnabled:true,
               zoomGesturesEnabled: true,
               myLocationEnabled: true,
               compassEnabled: true,
               tiltGesturesEnabled: true,
               markers: _markers,
               polylines: _polylines,
               mapType: MapType.normal,
               initialCameraPosition: initialCameraPosition,
               onMapCreated: (GoogleMapController controller) {
                 _controller.complete(controller);
                 // my map has completed being created;
                 // i'm ready to show the pins on the map
                 // showPinsOnMap();
               }),
          /* Container(
             child:FloatingActionButton(
               child: Icon(Icons.location_searching),
               onPressed: (){
                 setState(() {
                   btnStart=!btnStart;
                   if(btnStart){
                     camera_zoom=13;
                   }else{
                     camera_zoom=15;
                   }
                 });
               },

           )
              ),*/
         ],
       ),

     );

  }

  Future<void> showPinsOnMap() {
    // get a LatLng for the source location
    // from the LocationData currentLocation object
    var pinPosition = LatLng(currentLocation.latitude,
        currentLocation.longitude);
    // get a LatLng out of the LocationData object
    var destPosition = LatLng(destinationLocation.latitude,
        destinationLocation.longitude);
    // add the initial source location pin
    _markers.add(Marker(
        markerId: MarkerId('sourcePin'),
        position: pinPosition,
        icon: sourceIcon
    ));
    // destination pin
    _markers.add(Marker(
        markerId: MarkerId('destPin'),
        position: destPosition,
        icon: destinationIcon
    ));
    // set the route lines on the map from source to destination
    // for more info follow this tutorial
    setPolylines();
  }

  Future<void> setPolylines() async {

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(googleAPIKey,
        PointLatLng(currentLocation.latitude, currentLocation.longitude),
        PointLatLng(destinationLocation.latitude, destinationLocation.longitude),
       );

    polylineCoordinates.clear();
    if(result.points.isNotEmpty){
      result.points.forEach((PointLatLng point){
        polylineCoordinates.add(
            LatLng(point.latitude,point.longitude)
        );
      });
      if(mounted){
      setState(() {
        _polylines.add(Polyline(
            width: 5, // set the width of the polylines
            polylineId: PolylineId('poly'),
            color: Color.fromARGB(255, 40, 122, 198),
            points: polylineCoordinates
        ));
      });
    }}
  }

  Future<void> updatePinOnMap() async {

    // create a new CameraPosition instance
    // every time the location changes, so the camera
    // follows the pin as it moves with an animation
    CameraPosition cPosition = CameraPosition(
      zoom: CAMERA_ZOOM,
      tilt: CAMERA_TILT,
      bearing: CAMERA_BEARING,
      target: LatLng(currentLocation.latitude,
          currentLocation.longitude),
    );
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(cPosition));
    // do this inside the setState() so Flutter gets notified
    // that a widget update is due
    if(mounted){
    setState(() {
      // updated position
      var pinPosition = LatLng(currentLocation.latitude,
          currentLocation.longitude);

      var destPosition = LatLng(destinationLocation.latitude,
          destinationLocation.longitude);

      // the trick is to remove the marker (by id)
      // and add it again at the updated location
      _markers.removeWhere((m) => m.markerId.value == 'sourcePin');

      _markers.add(Marker(
          markerId: MarkerId('sourcePin'),
          position: pinPosition, // updated position
          icon: sourceIcon
      ));


    });};
  }

}
