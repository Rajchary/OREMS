import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addImages.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddDataFromMap extends StatefulWidget {
  static const idScreen = "AddFromMap";
  @override
  _AddDataFromMapState createState() => _AddDataFromMapState();
}

class _AddDataFromMapState extends State<AddDataFromMap> {
  String _resultAddress = "";
  List<String> _addressArray = [];
  SharedPreferences prefs;
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(17.383669937788902, 78.47599386215623),
    zoom: 7.4746,
  );
  GoogleMapController gmController;
  Marker origin;
  Marker destination;
  @override
  void initState() {
    _getRequirements();
    super.initState();
  }

  Future<void> _getRequirements() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void dispose() {
    gmController.dispose();
    super.dispose();
  }

  getSetAddress(Coordinates coordinates) async {
    final addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    setState(() {
      _resultAddress = addresses.first.addressLine;
      // print(_resultAddress);
      _addressArray = _resultAddress.split(",");
      for (String item in _addressArray) {
        if (item.contains("Telangana")) {
          _resultAddress = item.trim();
          //   print(_resultAddress);
          break;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Select location"),
      ),
      body: Stack(
        children: [
          GoogleMap(
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (controller) => gmController = controller,
            markers: {if (origin != null) origin},
            onLongPress: _addMarker,
          ),
          Positioned(
              top: 50,
              left: 15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (origin == null)
                    Text(
                      "Long press on your property location to mark it",
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.blue[600],
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              )),
          Positioned(
            bottom: 70,
            left: 25,
            child: Row(
              children: [
                if (origin != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: greenThick),
                    onPressed: () {
                      if (origin != null)
                        gmController.animateCamera(
                            CameraUpdate.newCameraPosition(CameraPosition(
                          target: origin.position,
                          zoom: 20.5,
                          tilt: 50,
                        )));
                    },
                    icon: Icon(Icons.location_on),
                    label: Text("Origin"),
                  ),
                SizedBox(
                  width: 15,
                ),
                if (origin != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      setState(() {
                        origin = null;
                      });
                    },
                    icon: Icon(Icons.clear),
                    label: Text("Clear"),
                  ),
                SizedBox(
                  width: 15,
                ),
                if (origin != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(primary: greenThick),
                    onPressed: () async {
                      await getSetAddress(Coordinates(
                          origin.position.latitude, origin.position.longitude));
                      if (_resultAddress !=
                              "Svalbard, Svalbard and Jan Mayen" &&
                          _resultAddress.isNotEmpty) {
                        prefs.setDouble("pLat", origin.position.latitude);
                        prefs.setDouble("pLng", origin.position.longitude);
                        prefs.setString("Glocation", _resultAddress);
                        //print(_resultAddress);
                        //print(origin.position.toString());
                        Navigator.popAndPushNamed(context, AddImages.idScreen);
                      } else {
                        Fluttertoast.showToast(msg: "Retrying please wait");
                        getSetAddress(Coordinates(origin.position.latitude,
                            origin.position.longitude));
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios),
                    label: Text("Proceede"),
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        foregroundColor: greenThick,
        onPressed: () => gmController.animateCamera(
          CameraUpdate.newCameraPosition(_initialCameraPosition),
        ),
        child: Icon(Icons.center_focus_strong),
      ),
    );
  }

  void _addMarker(LatLng pos) {
    setState(() {
      origin = Marker(
        markerId: const MarkerId("Origin"),
        infoWindow: const InfoWindow(title: "Your property position"),
        icon:
            BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueMagenta),
        position: pos,
      );
      print(pos);
    });
  }
}
