import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';

class AddMap extends StatefulWidget {
  static const String idScreen = "MapsScreen";
  @override
  _AddMapState createState() => _AddMapState();
}

class _AddMapState extends State<AddMap> {
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _gmController = Completer();
  GoogleMapController _newGmController; //Defined for future purpose
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.383669937788902,
        78.47599386215623), //37.42796133580664, -122.085749655962),
    zoom: 7.4746,
  );
  Position currentPosition;
  var geoLocator = Geolocator();

  void locatePosition(double zoom) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latlngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latlngPosition, zoom: zoom);
    _newGmController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void dispose() {
    _newGmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.normal,
            myLocationButtonEnabled: false,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: false,
            mapToolbarEnabled: true,
            onMapCreated: (GoogleMapController controller) {
              _gmController.complete(controller);
              _newGmController = controller;
              locatePosition(16.756);
            },
          ),
          Positioned(
            bottom: 50,
            left: 25,
            child: Row(
              children: [
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: greenThick),
                  onPressed: () {
                    locatePosition(20);
                  },
                  icon: Icon(
                    Icons.gps_fixed,
                    color: Colors.white,
                  ),
                  label: Text("Select current location"),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(primary: greenThick),
                  onPressed: () async {
                    Navigator.pushNamedAndRemoveUntil(
                        context, HomeScreen.idScreen, (route) => false);
                  },
                  icon: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.white,
                  ),
                  label: Text("Go Home"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
