import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_real_estate_management_system/screens/Tenant/Services/directionModel.dart';
import 'package:online_real_estate_management_system/screens/Tenant/Services/directionRepositery.dart';

class NavigateToProperty extends StatefulWidget {
  static const idScreen = "NavigateToProperty";
  const NavigateToProperty({Key key}) : super(key: key);

  @override
  _NavigateToPropertyState createState() => _NavigateToPropertyState();
}

class _NavigateToPropertyState extends State<NavigateToProperty> {
  static final CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(17.383669937788902, 78.47599386215623),
    zoom: 20,
  );

  Directions _info;

  GoogleMapController _googleMapController;

  Marker _origin, _destination;

  Position currentPosition;

  LatLng start, dest;

  var geoLocator = Geolocator();

  void locatePosition(double zoom) async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    currentPosition = position;

    // setState(() {
    //   start = LatLng(position.latitude, position.longitude);
    // });
    start = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: start, zoom: zoom, tilt: 64);

    _googleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    _addMarkers("Origin", start);
  }

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      dest = ModalRoute.of(context).settings.arguments;
      print("${dest.hashCode}  ${dest.longitude}");
    });
    try {
      if (dest != null) {
        _addMarkers("Destination", dest);
        //  _addMarkers("Origin", start);
      }
    } catch (E) {
      print("Error");
    }
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            myLocationButtonEnabled: true,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            buildingsEnabled: true,
            tiltGesturesEnabled: true,
            mapToolbarEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (GoogleMapController controller) {
              _googleMapController = controller;
              locatePosition(20);
            },
            markers: {
              if (_origin != null) _origin,
              if (_destination != null) _destination
            },
            polylines: {
              if (_info != null)
                Polyline(
                  polylineId: const PolylineId('overview_polyline'),
                  color: Colors.red,
                  width: 5,
                  points: _info.polylinepoints
                      .map((e) => LatLng(e.latitude, e.longitude))
                      .toList(),
                ),
            },
          ),
          if (_info != null)
            Positioned(
              top: 20,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
                decoration: BoxDecoration(
                  color: Colors.yellowAccent,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(0, 2),
                      blurRadius: 6.0,
                    ),
                  ],
                ),
                child: Text(
                  '${_info.totalDistance}, ${_info.totalDuration}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FloatingActionButton.extended(
              heroTag: null,
              enableFeedback: true,
              icon: Icon(Icons.location_searching_outlined),
              backgroundColor: Colors.indigo.shade900,
              onPressed: () {
                _googleMapController.animateCamera(_info != null
                    ? CameraUpdate.newLatLngBounds(_info.bounds, 100.0)
                    : CameraUpdate.newCameraPosition(CameraPosition(
                        target: _origin.position, zoom: 20, tilt: 60)));
                locatePosition(20);
              },
              label: Text(
                "Destination",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addMarkers(String place, LatLng pos) async {
    if (place == "Origin") {
      setState(() {
        _origin = Marker(
            markerId: const MarkerId('Start'),
            infoWindow: const InfoWindow(title: "You location"),
            icon: BitmapDescriptor.defaultMarkerWithHue(
                BitmapDescriptor.hueGreen),
            position: pos);
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _origin.position, zoom: 20, tilt: 65)));
      });
      final directions = await DirectionRepositery().getDirection(
          origin: _origin.position, destination: _destination.position);
      setState(() => _info = directions);
    } else if (place == "Destination") {
      setState(() {
        _destination = Marker(
            markerId: const MarkerId('Dest'),
            infoWindow: const InfoWindow(title: "Property location"),
            icon:
                BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
            position: pos);
        _googleMapController.animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: _destination.position, zoom: 20, tilt: 65)));
      });
    }
  }
}
