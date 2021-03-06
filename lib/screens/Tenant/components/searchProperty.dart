import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/property.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addProperty.dart';

class SearchProperty extends StatefulWidget {
  static const String idScreen = "Search";
  @override
  _SearchPropertyState createState() => _SearchPropertyState();
}

class _SearchPropertyState extends State<SearchProperty> {
  RangeValues rentRangevalues = RangeValues(3000, 25000);
  RangeLabels rentRangeLabels = RangeLabels("3000", "25000");

  RangeValues assetRangeValues = RangeValues(50000, 50000000);
  RangeLabels assetRangeLabels = RangeLabels("50000", "50000000");

  RangeValues areaRangeValues = RangeValues(100, 22000);
  RangeLabels areaRangeLabels = RangeLabels("100", "22000");

  String docId = "";
  int properties = 0;
  String type = "Choose..",
      tType = "Bachelors",
      roomType = "1BHK",
      locationType = "Automatic Location";
  bool selected = false;
  List<Map<String, dynamic>> _propertyData = [];
  bool furnished = false, negotiable = false, isLocationEnable = false;
  Color furnishedColor = Colors.white,
      tTypeColor = Colors.white,
      negotiableColor = Colors.white,
      roomTypeColor = Colors.white;
  List<String> _addressArray = [];
  LatLng _userLocation;
  String _resultAddress;
  Icon done = Icon(
    Icons.done,
    color: Colors.white,
  );

  @override
  void initState() {
    print("Called");
    selected = false;
    type = "Choose..";
    roomType = "1BHK";
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
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        setState(() {
          isLocationEnable = false;
        });
        return;
      }
    } else {
      setState(() {
        isLocationEnable = true;
      });
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
    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 1.2;
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1, childAspectRatio: (itemWidth / itemHeight)),
            itemBuilder: (context, index) {
              return index == 0
                  ? Center(
                      child: Container(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              SizedBox(
                                height: size.height * .002,
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * .045,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(Icons.arrow_back_ios),
                                    iconSize: size.width * .085,
                                    color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: size.width * .6,
                                  ),
                                  IconButton(
                                    onPressed: () {
                                      if (!isLocationEnable) {
                                        getUserLocation();
                                      } else {
                                        Fluttertoast.showToast(
                                            msg: "Location already enabled");
                                      }
                                    },
                                    icon: isLocationEnable
                                        ? Icon(
                                            Icons.location_searching_rounded,
                                            color: greenThick,
                                            size: size.width * .085,
                                          )
                                        : Icon(
                                            Icons.location_disabled,
                                            color: Colors.red,
                                            size: size.width * .085,
                                          ),
                                  )
                                ],
                              ),
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    // SizedBox(
                                    //   height: 100,
                                    // ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
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
                                              color: Colors.black,
                                              fontSize: 25),
                                          underline: Container(
                                            color: Colors.white,
                                            height: 2,
                                          ),
                                          onChanged: (String newValue) {
                                            setState(() {
                                              type = newValue;
                                              selected = (type != "Choose..")
                                                  ? true
                                                  : false;
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
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            );
                                          }).toList(),
                                        ),
                                        SizedBox(
                                          width: size.width * .035,
                                        ),
                                        DropdownButton<String>(
                                          dropdownColor: Colors.black,
                                          value: locationType,
                                          icon: const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                            size: 25,
                                          ),
                                          iconSize: 24,
                                          elevation: 16,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 25),
                                          underline: Container(
                                            color: Colors.white,
                                            height: 2,
                                          ),
                                          onChanged: (String newValue) async {
                                            setState(() {
                                              locationType = newValue;
                                            });
                                            if (locationType ==
                                                "Manual Location") {
                                              showManualLocation();
                                              print(_resultAddress);
                                            } else {
                                              getUserLocation();
                                            }
                                          },
                                          items: <String>[
                                            "Automatic Location",
                                            "Manual Location",
                                          ].map<DropdownMenuItem<String>>(
                                              (String value) {
                                            return DropdownMenuItem<String>(
                                              value: value,
                                              child: Text(value,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            );
                                          }).toList(),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    type == "Lease"
                                        ? Container(
                                            //Tenant filters
                                            child: Column(
                                              children: <Widget>[
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  furnishedColor),
                                                      onPressed: () {
                                                        setState(() {
                                                          furnished =
                                                              !furnished;
                                                          if (furnished)
                                                            furnishedColor =
                                                                Colors.green;
                                                          else
                                                            furnishedColor =
                                                                Colors.white;
                                                        });
                                                      },
                                                      icon: furnished
                                                          ? done
                                                          : Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      label: Text(
                                                        "Furnished",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                          color: furnished
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * .04,
                                                    ),
                                                    ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  negotiableColor),
                                                      onPressed: () {
                                                        setState(() {
                                                          negotiable =
                                                              !negotiable;
                                                          if (negotiable)
                                                            negotiableColor =
                                                                Colors.green;
                                                          else
                                                            negotiableColor =
                                                                Colors.white;
                                                        });
                                                      },
                                                      icon: negotiable
                                                          ? done
                                                          : Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      label: Text(
                                                        "Negotiable",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                          color: negotiable
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * .004,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: <Widget>[
                                                    DropdownButton<String>(
                                                      dropdownColor:
                                                          Colors.black,
                                                      value: tType,
                                                      icon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 25),
                                                      underline: Container(
                                                        color: Colors.white,
                                                        height: 2,
                                                      ),
                                                      onChanged:
                                                          (String newValue) {
                                                        setState(() {
                                                          tType = newValue;
                                                        });
                                                      },
                                                      items: <String>[
                                                        "Bachelors",
                                                        "Family",
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        );
                                                      }).toList(),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * .075,
                                                    ),
                                                    DropdownButton<String>(
                                                      dropdownColor:
                                                          Colors.black,
                                                      value: roomType,
                                                      icon: const Icon(
                                                        Icons.arrow_drop_down,
                                                        color: Colors.white,
                                                        size: 25,
                                                      ),
                                                      iconSize: 24,
                                                      elevation: 16,
                                                      style: const TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 25),
                                                      underline: Container(
                                                        color: Colors.white,
                                                        height: 2,
                                                      ),
                                                      onChanged:
                                                          (String newValue) {
                                                        setState(() {
                                                          roomType = newValue;
                                                        });
                                                      },
                                                      items: <String>[
                                                        "1RK",
                                                        "1BHK",
                                                        "2BHK",
                                                        "3BHK",
                                                        "4BHK",
                                                        "4+ BHK",
                                                      ].map<
                                                              DropdownMenuItem<
                                                                  String>>(
                                                          (String value) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value: value,
                                                          child: Text(value,
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                        );
                                                      }).toList(),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * .01,
                                                ),
                                                Hint(hint: "Rent range "),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: RangeSlider(
                                                    min: 3000,
                                                    max: 25000,
                                                    values: rentRangevalues,
                                                    labels: rentRangeLabels,
                                                    activeColor: greenThick,
                                                    inactiveColor: Colors.black,
                                                    divisions: 100,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        rentRangevalues = value;
                                                        rentRangeLabels =
                                                            RangeLabels(
                                                                value.start
                                                                    .toInt()
                                                                    .toString(),
                                                                value.end
                                                                    .toInt()
                                                                    .toString());
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    type == "Sale"
                                        ? Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  furnishedColor),
                                                      onPressed: () {
                                                        setState(() {
                                                          furnished =
                                                              !furnished;
                                                          if (furnished)
                                                            furnishedColor =
                                                                Colors.green;
                                                          else
                                                            furnishedColor =
                                                                Colors.white;
                                                        });
                                                      },
                                                      icon: furnished
                                                          ? done
                                                          : Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      label: Text(
                                                        "Furnished",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                          color: furnished
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: size.width * .03,
                                                    ),
                                                    ElevatedButton.icon(
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  negotiableColor),
                                                      onPressed: () {
                                                        setState(() {
                                                          negotiable =
                                                              !negotiable;
                                                          if (negotiable)
                                                            negotiableColor =
                                                                Colors.green;
                                                          else
                                                            negotiableColor =
                                                                Colors.white;
                                                        });
                                                      },
                                                      icon: negotiable
                                                          ? done
                                                          : Icon(
                                                              Icons
                                                                  .cancel_outlined,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                      label: Text(
                                                        "Negotiable",
                                                        style: GoogleFonts
                                                            .rajdhani(
                                                          textStyle:
                                                              Theme.of(context)
                                                                  .textTheme
                                                                  .headline4,
                                                          color: negotiable
                                                              ? Colors.white
                                                              : Colors.black,
                                                          fontSize: 19,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: size.height * .015,
                                                ),
                                                Hint(
                                                  hint: "Select Asset Value",
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: RangeSlider(
                                                    min: 50000,
                                                    max: 50000000,
                                                    values: assetRangeValues,
                                                    labels: assetRangeLabels,
                                                    activeColor: greenThick,
                                                    inactiveColor: Colors.black,
                                                    divisions: 100,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        assetRangeValues =
                                                            value;
                                                        assetRangeLabels =
                                                            RangeLabels(
                                                                value.start
                                                                    .toInt()
                                                                    .toString(),
                                                                value.end
                                                                    .toInt()
                                                                    .toString());
                                                      });
                                                    },
                                                  ),
                                                ),
                                                Hint(
                                                  hint: "Select Preffered Area",
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: 15),
                                                  child: RangeSlider(
                                                    min: 100,
                                                    max: 22000,
                                                    values: areaRangeValues,
                                                    labels: areaRangeLabels,
                                                    activeColor: greenThick,
                                                    inactiveColor: Colors.black,
                                                    divisions: 100,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        areaRangeValues = value;
                                                        areaRangeLabels =
                                                            RangeLabels(
                                                                value.start
                                                                    .toInt()
                                                                    .toString(),
                                                                value.end
                                                                    .toInt()
                                                                    .toString());
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container(),
                                    ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: greenThick,
                                      ),
                                      onPressed: () async {
                                        if (selected) {
                                          properties = 0;
                                          _propertyData.clear();
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return ProgressDialog(
                                                  message: "Searching ..",
                                                );
                                              });
                                          await getProperties();
                                          Navigator.pop(context);
                                          await getUserLocation();
                                        } else
                                          Fluttertoast.showToast(
                                              msg: "Please apply a filter");
                                      },
                                      child: Text(
                                        "Get Properties",
                                        style: GoogleFonts.rajdhani(
                                          textStyle: Theme.of(context)
                                              .textTheme
                                              .headline4,
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
                        ),
                      ),
                    )
                  : GestureDetector(
                      onTap: () {
                        // Fluttertoast.showToast(msg: "Working");
                        Navigator.pushNamed(context, PropertyView.idScreen,
                            arguments: _propertyData[index - 1]);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          margin: EdgeInsets.all(3),
                          width: double.infinity,
                          height: 500,
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
                          child: SingleChildScrollView(
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
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
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
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
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
                                      _propertyData[index - 1]["Value"] != null
                                          ? "Value : "
                                          : "Rent : ",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.blue,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Text(
                                      "??? ${_propertyData[index - 1]["Value"] != null ? _propertyData[index - 1]["Value"] : _propertyData[index - 1]["Rent"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.red,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                      "Description : ",
                                      overflow: TextOverflow.ellipsis,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
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
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
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
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
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
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.teal,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                type == "Lease"
                                    ? Row(
                                        children: <Widget>[
                                          Text(
                                            "Pay Type",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                              color: Colors.blue,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 8,
                                          ),
                                          Text(
                                            " ${_propertyData[index - 1]["lease type"]}",
                                            overflow: TextOverflow.ellipsis,
                                            style: GoogleFonts.rajdhani(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headline4,
                                              color: Colors.green,
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
            }),
      ),
    );
  }

  void showManualLocation() {
    TextEditingController locationC = new TextEditingController();
    Size size = MediaQuery.of(context).size;
    // String address = "";
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            elevation: 16,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF1B222E),
                borderRadius: BorderRadius.circular(30),
              ),
              height: size.height * 0.45,
              width: size.width * 0.4,
              child: Column(
                children: [
                  SvgPicture.asset(
                    "assets/images/moonLight.svg",
                    width: size.width * 0.4,
                    height: size.height * 0.2,
                  ),
                  RoundedInputField(
                    icon: Icons.location_on,
                    textInputType: TextInputType.phone,
                    textcontroller: locationC,
                    lines: 1,
                  ),
                  Flexible(
                    child: Text(
                      "Provide 6 digit pin code",
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 3,
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.white,
                        fontSize: size.width * .045,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          if (locationC.text.trim().length == 6) {
                            setState(() {
                              _resultAddress =
                                  "Telangana " + locationC.text.trim();
                              Navigator.pop(context);
                            });
                          } else {
                            Fluttertoast.showToast(
                                msg: "Please provide valid 6 digit PIN code");
                          }
                        },
                        child: Text(
                          "Set",
                          style: TextStyle(
                              fontSize: size.width * .035,
                              color: Colors.pink[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future<dynamic> getProperties() async {
    if (type == "Sale") {
      FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Sale')
          .where("GeoLocation", isEqualTo: "$_resultAddress")
          .where("isFurnished", isEqualTo: furnished ? "YES" : "NO")
          .where("isNegotiable", isEqualTo: negotiable ? "YES" : "NO")
          .where("Value", isGreaterThan: assetRangeValues.start.toInt())
          .where("Value", isLessThan: assetRangeValues.end.toInt())
          .get()
          .then((QuerySnapshot snap) {
        setState(() {
          properties = 0;
          int i = 0;
          snap.docs.forEach((element) {
            docId = element.id.toString();
            Map<String, dynamic> mp = element.data();
            if (mp["Area"] >= areaRangeValues.start.toInt() &&
                mp["Area"] <= areaRangeValues.end.toInt() &&
                mp["uid"] != FirebaseAuth.instance.currentUser.uid) {
              _propertyData.add(element.data());
              _propertyData[i]["docId"] = docId;
              ++i;
              ++properties;
            }
          });
        });
        if (properties == 0) {
          AlertDialogs.confirmDialog(
              context, "Not Found!", "No results found for your search",
              cancel: "", yes: "Ok");
        }
      });
    } else if (type == "Lease") {
      FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Lease')
          .where("GeoLocation", isEqualTo: "$_resultAddress")
          .where("isFurnished", isEqualTo: furnished ? "YES" : "NO")
          .where("isNegotiable", isEqualTo: negotiable ? "YES" : "NO")
          .where("Preferse", isEqualTo: tType)
          .where("RoomType", isEqualTo: roomType)
          .where("Rent", isGreaterThan: rentRangevalues.start - 1)
          .where("Rent", isLessThan: rentRangevalues.end - 1)
          .get()
          .then((QuerySnapshot snap) {
        setState(() {
          // Fluttertoast.showToast(msg: "Checking ${snap.docs.length}");
          properties = 0;
          int i = 0;
          snap.docs.forEach((element) {
            docId = element.id.toString();
            Map<String, dynamic> mp = element.data();
            if (mp["uid"] != FirebaseAuth.instance.currentUser.uid) {
              _propertyData.add(element.data());
              _propertyData[i]["docId"] = docId;
              ++properties;
              ++i;
            }
          });
        });
        if (properties == 0) {
          AlertDialogs.confirmDialog(
              context, "Not Found!", "No results found for your search",
              cancel: "", yes: "Ok");
        }
      });
    }
  }
}
