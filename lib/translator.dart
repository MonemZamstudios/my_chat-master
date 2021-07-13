



import 'dart:async';
import 'dart:math';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'global.dart' as globals;
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeolocatorWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MapSample();
  }
}

class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  Completer<GoogleMapController> _controllerGoogleMap=Completer();
  GoogleMapController newGoogleMapController;
  @override
  void initState() {
    getlocation();
    // TODO: implement initState
    super.initState();
  }
  //String locationMessage1='';
  Position currentposition;
  var geolocator = Geolocator();
  void getlocation()async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentposition = position;

    var lastPOsition = await Geolocator.getLastKnownPosition();
    print(lastPOsition);
    LatLng latlongposition= LatLng(position.latitude,position.longitude);
    CameraPosition _initialposition = new CameraPosition(target: latlongposition,zoom: 14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(_initialposition));

  }


static final CameraPosition _kGooglePlex =CameraPosition(target: LatLng(22,44),zoom: 14);


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: GoogleMap(
          mapType: MapType.normal,
          myLocationButtonEnabled: true,
          myLocationEnabled: true,
          zoomControlsEnabled: true,
          onMapCreated: (GoogleMapController controller)
          {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController=controller;

          },

          initialCameraPosition: _kGooglePlex,
        ),
      ),


    );
  }


}