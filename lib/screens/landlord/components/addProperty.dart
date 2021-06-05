import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addImages.dart';
import 'package:online_real_estate_management_system/screens/landlord/services/addDataFromMap.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMyProperty extends StatefulWidget {
  static const String idScreen = "addProperty";

  @override
  _AddMyPropertyState createState() => _AddMyPropertyState();
}

class _AddMyPropertyState extends State<AddMyProperty> {
  TextEditingController propertyNameController = new TextEditingController();

  TextEditingController propertyAddressController = new TextEditingController();

  TextEditingController propertyDiscriptionController =
      new TextEditingController();
  TextEditingController propertyContactController = new TextEditingController();

  TextEditingController propertyValueController = new TextEditingController();
  TextEditingController propertyAreaController = new TextEditingController();
  TextEditingController propertyLandmarkController =
      new TextEditingController();
  List<String> purpose = ["lease", "Sale", "Manage"];
  List<String> _preferedTenantTypeList = ['Choose..', "Family", "Bachelors"];
  String currentPurpose = "Choose..";
  String leaseType = "Choose..",
      preferedTenants = "Choose..",
      currentLocation = "YES",
      currentTenantType = "Choose..",
      isNegotiable = "NO",
      isFurnished = "NO",
      currentRoomType = "Choose..";
  bool selected = false;
  double assetValue = 1500;
  // ignore: non_constant_identifier_names
  bool lease_selected = false;
  List<String> _addressArray = [];
  List<String> _rentTypeList = ["Choose..", "Monthly", "Yearly"];
  List<String> _roomTypeList = [
    "Choose..",
    "1RK",
    "1BHK",
    "2BHK",
    "3BHK",
    "4BHK",
    "4+ BHK"
  ];
  LatLng _userLocation;
  String _resultAddress;
  @override
  void initState() {
    selected = false;
    lease_selected = false;
    preferedTenants = "Choose..";
    currentPurpose = "Choose..";
    currentRoomType = "Choose..";
    currentLocation = "YES";
    currentTenantType = "Choose..";
    _rentTypeList = ["Choose..", "Monthly", "Yearly"];
    _preferedTenantTypeList = ['Choose..', "Family", "Bachelors", "Company"];
    _roomTypeList = [
      "Choose..",
      "1RK",
      "1BHK",
      "2BHK",
      "3BHK",
      "4BHK",
      "4+ BHK"
    ];
    leaseType = "Choose..";
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
    var result = await location.getLocation();
    result = await location.getLocation();
    result = await location.getLocation();
    result = await location.getLocation();
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
    Size size = MediaQuery.maybeOf(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue[400],
                Colors.blue[900],
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50),
                SingleChildScrollView(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
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
                ),
                SizedBox(
                  height: 25,
                ),
                Text(
                  "Fill details about your property",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.white,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                RoundedInputField(
                  lines: 2,
                  hintText: "property name",
                  icon: Icons.home,
                  onChanged: (value) {},
                  textInputType: TextInputType.text,
                  textcontroller: propertyNameController,
                ),
                SizedBox(
                  height: 25,
                ),
                RoundedInputField(
                  lines: 5,
                  hintText: "Property adress",
                  icon: Icons.location_history,
                  onChanged: (value) {},
                  textInputType: TextInputType.text,
                  textcontroller: propertyAddressController,
                ),
                SizedBox(
                  height: 25,
                ),
                RoundedInputField(
                  lines: 2,
                  hintText: "Landmark (or) Street name",
                  icon: Icons.location_on,
                  onChanged: (value) {},
                  textInputType: TextInputType.text,
                  textcontroller: propertyLandmarkController,
                ),
                SizedBox(
                  height: 25,
                ),
                RoundedInputField(
                  lines: 5,
                  hintText: "Discription about the property",
                  icon: Icons.add,
                  onChanged: (value) {},
                  textInputType: TextInputType.text,
                  textcontroller: propertyDiscriptionController,
                ),
                SizedBox(
                  height: 15,
                ),
                RoundedInputField(
                  hintText: "Contact number",
                  icon: Icons.phone,
                  onChanged: (value) {},
                  textInputType: TextInputType.phone,
                  textcontroller: propertyContactController,
                ),
                SizedBox(
                  height: 15,
                ),
                Text(
                  "please select purpose of the property",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Center(
                  //child: DropDown(),
                  child: DropdownButton<String>(
                    value: currentPurpose,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 25,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 25),
                    underline: Container(height: 2, color: Colors.white),
                    onChanged: (String newValue) {
                      setState(() {
                        currentPurpose = newValue;
                        selected =
                            (currentPurpose != "Choose..") ? true : false;
                      });
                    },
                    items: <String>['Choose..', "Lease", "Sale", "Manage"]
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                  ),
                ),
                selected
                    ? Container(
                        child: Column(
                          children: [
                            currentPurpose == "Sale" ||
                                    currentPurpose == "Manage"
                                ? Container(
                                    child: Column(
                                      children: [
                                        Hint(
                                          hint:
                                              "Please provide value of the property",
                                        ),
                                        SizedBox(height: 10),
                                        RoundedInputField(
                                          lines: 1,
                                          hintText: "Value of the property",
                                          icon: Icons.money,
                                          onChanged: (value) {},
                                          textInputType: TextInputType.number,
                                          textcontroller:
                                              propertyValueController,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Hint(
                                          hint: "Flat's Carpet Area",
                                        ),
                                        RoundedInputField(
                                          lines: 1,
                                          hintText: "Property area",
                                          icon: Icons.architecture,
                                          onChanged: (value) {},
                                          textInputType: TextInputType.number,
                                          textcontroller:
                                              propertyAreaController,
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          height: 15,
                                        ),
                                        SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Column(
                                                  children: [
                                                    Hint(
                                                      hint: "Pay rent duration",
                                                    ),
                                                    Center(
                                                      //child: DropDown(),
                                                      child: DropdownButton<
                                                          String>(
                                                        value: leaseType,
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
                                                            height: 2,
                                                            color:
                                                                Colors.white),
                                                        onChanged:
                                                            (String newValue) {
                                                          setState(() {
                                                            leaseType =
                                                                newValue;
                                                            lease_selected =
                                                                (leaseType !=
                                                                        "Choose..")
                                                                    ? true
                                                                    : false;
                                                          });
                                                        },
                                                        items: _rentTypeList.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(width: 15),
                                                Column(
                                                  children: [
                                                    Hint(
                                                      hint: "Prefered tenants",
                                                    ),
                                                    Center(
                                                      //child: DropDown(),
                                                      child: DropdownButton<
                                                          String>(
                                                        value:
                                                            currentTenantType,
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
                                                            height: 2,
                                                            color:
                                                                Colors.white),
                                                        onChanged:
                                                            (String newValue) {
                                                          setState(() {
                                                            currentTenantType =
                                                                newValue;
                                                          });
                                                        },
                                                        items: _preferedTenantTypeList.map<
                                                            DropdownMenuItem<
                                                                String>>((String
                                                            value) {
                                                          return DropdownMenuItem<
                                                              String>(
                                                            value: value,
                                                            child: Text(value,
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                          );
                                                        }).toList(),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ]),
                                        ),
                                        lease_selected
                                            ? RoundedInputField(
                                                lines: 1,
                                                hintText:
                                                    "$leaseType Rent in ₹",
                                                icon: Icons.money,
                                                onChanged: (value) {},
                                                textInputType:
                                                    TextInputType.number,
                                                textcontroller:
                                                    propertyValueController,
                                              )
                                            : Container(),
                                        SizedBox(
                                          height: 15,
                                        ),
                                      ],
                                    ),
                                  ),
                          ],
                        ),
                      )
                    : Container(),
                Hint(
                  hint: "Select the type of room.",
                ),
                Center(
                  child: DropdownButton<String>(
                    value: currentRoomType,
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.white,
                      size: 25,
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(color: Colors.black, fontSize: 25),
                    underline: Container(height: 2, color: Colors.white),
                    onChanged: (String newValue) {
                      setState(() {
                        currentRoomType = newValue;
                      });
                    },
                    items: _roomTypeList
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Hint(
                                  hint: "Is Furnished ?",
                                ),
                                Center(
                                  child: DropdownButton<String>(
                                    value: isNegotiable,
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
                                        height: 2, color: Colors.white),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        isNegotiable = newValue;
                                      });
                                    },
                                    items: <String>["YES", "NO"]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                Hint(
                                  hint: "Is Negotiable ?",
                                ),
                                Center(
                                  child: DropdownButton<String>(
                                    value: isFurnished,
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
                                        height: 2, color: Colors.white),
                                    onChanged: (String newValue) {
                                      setState(() {
                                        isFurnished = newValue;
                                      });
                                    },
                                    items: <String>["YES", "NO"]
                                        .map<DropdownMenuItem<String>>(
                                            (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold)),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //SizedBox(width: 25),
                    ElevatedButton.icon(
                      onPressed: () async {
                        final action = await AlertDialogs.confirmDialog(
                            context,
                            "Discard ?",
                            "The changes you have made will not be saved");
                        if (action == DialogAction.Yes) {
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.idScreen, (route) => false);
                          Fluttertoast.showToast(msg: "Opertion cancelled.");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red[400],
                      ),
                      icon: Icon(Icons.cancel),
                      label: Text(
                        "Cancel",
                        style: GoogleFonts.rajdhani(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(width: 35),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await getSetAddress(Coordinates(
                            _userLocation.latitude, _userLocation.longitude));
                        String ack = await finalValidation();
                        if (ack != "Make sure the details are valid") {
                          Fluttertoast.showToast(msg: ack);
                        } else {
                          final action = await AlertDialogs.confirmDialog(
                              context, "Proceed ?", ack);
                          if (action == DialogAction.Yes) {
                            // Navigator.popAndPushNamed(
                            //     context, AddImages.idScreen);
                            Navigator.pushNamed(
                                context, AddDataFromMap.idScreen);
                            Fluttertoast.showToast(msg: "Select Images.");
                          } //end local if
                        } //end else
                      },
                      style: ElevatedButton.styleFrom(
                        primary: greenThick,
                      ),
                      icon: Icon(Icons.arrow_forward_ios),
                      label: Text(
                        "Proceed",
                        style: GoogleFonts.rajdhani(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  Future<String> finalValidation() async {
    if (propertyNameController.text.isEmpty)
      return "name should not left empty";
    else if (propertyAddressController.text.length <= 15)
      return "please fill in some address";
    else if (propertyLandmarkController.text.length <= 10)
      return "Please provide landmark for better results";
    else if (propertyDiscriptionController.text.length <= 10)
      return "please add some description";
    else if (currentPurpose == "Choose..")
      return "please choose purpose of the property";
    else if (propertyValueController.text.length < 4)
      return "please provide value of the property";
    else if (propertyAreaController.text.isEmpty)
      return "Please provide area of your property";
    else if (propertyContactController.text.isEmpty)
      return "Please provide contact for the property";
    else if (leaseType == "Choose.." && currentPurpose == "Lease")
      return "Please provide rent duration type.";
    else if (currentTenantType == "Choose.." && currentPurpose == "Lease")
      return "Please provide prefered tenant type";
    else if (currentRoomType == "Choose..")
      return "please select category of the room";
    else {
      final pref = await SharedPreferences.getInstance();
      pref.setString('pName', propertyNameController.text.toString());
      pref.setString('pAddress', propertyAddressController.text.toString());
      pref.setString("pLandmark", propertyLandmarkController.text);
      pref.setString(
          'pDiscription', propertyDiscriptionController.text.toString());
      pref.setString("pContact", propertyContactController.text.toString());
      pref.setString('pPurpose', currentPurpose);
      if (currentPurpose == "Sale") {
        pref.setString("pArea", propertyAreaController.text.toString().trim());
      }
      if (currentPurpose == "Lease") {
        pref.setString("leaseDuration", leaseType.toString());
        pref.setString("preferedTenants", currentTenantType.toString());
      }
      pref.setString("roomType", currentRoomType.toString());
      assetValue = double.parse(propertyValueController.text.toString());
      // pref.setString("isCurrentLocation", currentLocation);
      pref.setDouble("pValue", assetValue);
      pref.setString('Glocation', _resultAddress);
      pref.setString("isNegotiable", isNegotiable);
      pref.setString("isFurnished", isFurnished);
      return "Make sure the details are valid";
    }
  }
}

class Hint extends StatelessWidget {
  const Hint({
    Key key,
    @required this.hint,
  }) : super(key: key);
  final String hint;
  @override
  Widget build(BuildContext context) {
    return Text(
      hint.toString(),
      style: GoogleFonts.rajdhani(
        textStyle: Theme.of(context).textTheme.headline4,
        color: Colors.white,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
