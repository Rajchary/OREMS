import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:online_real_estate_management_system/constants.dart';

class SearchProperty extends StatefulWidget {
  static const String idScreen = "Search";
  @override
  _SearchPropertyState createState() => _SearchPropertyState();
}

class _SearchPropertyState extends State<SearchProperty> {
  int properties = 0;
  String type = "Choose..";
  bool selected = false;
  List<Map<String, dynamic>> _propertyData = [];
  List<String> _addressArray = [];
  LatLng _userLocation;
  String _resultAddress;

  @override
  void initState() {
    selected = false;
    type = "Choose..";
    getUserLocation();
    super.initState();
  }

  Future getUserLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    final result = await location.getLocation();
    setState(() {
      _userLocation = LatLng(result.latitude, result.longitude);
    });
    getSetAddress(Coordinates(_userLocation.latitude, _userLocation.longitude));
    return result;
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.indigo,
              Colors.teal,
            ],
          ),
        ),
        child: GridView.builder(
            itemCount: properties + 1,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, index) {
              return index == 0
                  ? Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 25,
                          ),
                          Row(
                            children: [
                              SizedBox(
                                width: 25,
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                icon: Icon(Icons.arrow_back_ios),
                                iconSize: 35,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SizedBox(
                                  height: 100,
                                ),
                                DropdownButton<String>(
                                  dropdownColor: Colors.black,
                                  value: type,
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                    size: 25,
                                  ),
                                  iconSize: 24,
                                  elevation: 16,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 25),
                                  underline: Container(
                                    color: Colors.white,
                                    height: 2,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      type = newValue;
                                      selected =
                                          (type != "Choose..") ? true : false;
                                    });
                                  },
                                  items: <String>[
                                    'Choose..',
                                    "Lease",
                                    "Sale",
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold)),
                                    );
                                  }).toList(),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    primary: greenThick,
                                  ),
                                  onPressed: () async {
                                    if (selected) {
                                      properties = 0;
                                      _propertyData.clear();
                                      getProperties();
                                      await getUserLocation();
                                      print(index);
                                    } else
                                      Fluttertoast.showToast(
                                          msg: "Please apply a filter");
                                  },
                                  child: Text(
                                    "Get Properties",
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.white,
                                      fontSize: 19,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        Fluttertoast.showToast(msg: "Working");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.all(3),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white,
                                Colors.grey,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: 10,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                //errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                                //     return Text('Your error widget...');
                                // },
                                child: Image.network(
                                    //'https://media.istockphoto.com/photos/beautiful-luxury-home-exterior-at-twilight-picture-id1026205392?k=6&m=1026205392&s=612x612&w=0&h=pe0Pqbm7GKHl7cmEjf9Drc7Fp-JwJ6aTywsGfm5eQm4=',
                                    _propertyData[index - 1]["Image"],
                                    width: 300,
                                    height: 150,
                                    fit: BoxFit.fill),
                              ),
                              SizedBox(height: 15),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Name : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    _propertyData[index - 1]["name"],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.teal,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Description : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      _propertyData[index - 1]["Description"],
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      maxLines: 3,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.teal,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Address : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Flexible(
                                    child: Text(
                                      _propertyData[index - 1]["Address"],
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 3,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.teal,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Purpose : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    _propertyData[index - 1]["Purpose"],
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.teal,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: <Widget>[
                                  Text(
                                    "Value : ",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.blue,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "₹ ${_propertyData[index - 1]["Value"]}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.red,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
            }),
      ),
    );
  }

  Future<dynamic> getProperties() async {
    if (type == "Sale") {
      FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Sale')
          .where("GeoLocation", isEqualTo: "$_resultAddress")
          .get()
          .then((QuerySnapshot snap) {
        setState(() {
          properties += snap.docs.length;
          snap.docs.forEach((element) {
            _propertyData.add(element.data());
          });
        });
      });
    } else if (type == "Lease") {
      FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Lease')
          .where("GeoLocation", isEqualTo: "$_resultAddress")
          .get()
          .then((QuerySnapshot snap) {
        setState(() {
          properties += snap.docs.length;
          snap.docs.forEach((element) {
            _propertyData.add(element.data());
          });
        });
      });
    }
  }
}
