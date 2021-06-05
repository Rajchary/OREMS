import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:location/location.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/components/body.dart';
import 'package:online_real_estate_management_system/screens/Home/models/profileView.dart';
import 'package:online_real_estate_management_system/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final LocalAuthentication _localAuthentication = LocalAuthentication();
  String _message = "Not Authorized";
  Future<bool> checkingForBioMetrics() async {
    bool canCheckBiometrics = await _localAuthentication.canCheckBiometrics;
    print(canCheckBiometrics);
    return canCheckBiometrics;
  }

  Future<void> _authenticateMe() async {
    // 8. this method opens a dialog for fingerprint authentication.
    ////    we do not need to create a dialog nut it popsup from device natively.
    bool authenticated = false;
    try {
      authenticated = await _localAuthentication.authenticateWithBiometrics(
        localizedReason: "Authenticate for Testing",
        // message for dialog
        useErrorDialogs: true, // show error in dialog
        stickyAuth: true, // native process
      );
      setState(() {
        _message = authenticated ? "Authorized" : "Not Authorized";
      });
    } catch (e) {
      print(e);
    }
    if (!mounted) return;
  }

  //Stable from here
  firebase_storage.Reference propertyDatabase;
  String name = " ",
      phone = "",
      occupatio = "",
      imageUrl = "https://www.woolha.com/media/2020/03/eevee.png",
      profileName = " ";
  File imageFile;
  DatabaseReference userReference =
      FirebaseDatabase.instance.reference().child("Users");
  SharedPreferences pref;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {
    checkingForBioMetrics();
    _getUserData();
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
    return result;
  }

  _getUserData() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
      occupatio = pref.getString('occupation');
      phone = pref.getString('phone');
      imageUrl = pref.getString('profileUrl');
      // Fluttertoast.showToast(msg: "Initiated");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home page"),
      ),
      drawer: Container(
        width: 260.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400],
          ),
        ),
        child: Drawer(
          child: ListView(
            children: [
              Container(
                color: Colors.black,
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final action = await AlertDialogs.confirmDialog(
                              context,
                              "Upload",
                              "DO you wanna update new profile image");
                          if (action == DialogAction.Yes) {
                            _chooseImage();
                          }
                        },
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(imageUrl),
                          onBackgroundImageError: (_, __) {
                            setState(() {
                              profileName = name;
                            });
                          },
                          child: ClipRRect(
                            child: Text(
                              profileName[0].toString(),
                              style: TextStyle(
                                color: Colors.black, //greenThick,
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        children: [
                          SizedBox(height: 50.0),
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Brand-Bold",
                                color: greenThick),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          Text(
                            "View Profile",
                            style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Brand-Bold",
                                color: greenThick),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 3.0,
                color: greenThick,
              ),
              SizedBox(height: 6.0),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "My Profile",
                  style: TextStyle(color: greenThick),
                ),
                onTap: () {
                  Fluttertoast.showToast(msg: "Profile view");
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => ProfileView()),
                  );
                }, //viewProfile(),
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "Signout",
                  style: TextStyle(color: greenThick),
                ),
                onTap: () async {
                  final action = await AlertDialogs.confirmDialog(
                      context, "Signout ?", "Are you sure you wanna do it");
                  if (action == DialogAction.Yes) {
                    signoutUser();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Body(),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  viewProfile() {
    //print(person.getName);
    Fluttertoast.showToast(msg: "Profile view");
  }

  _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile.path);
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Uploading..",
          );
        });
    uploadProfilePhoto(context).whenComplete(() => Navigator.of(context).pop());
  }

  Future uploadProfilePhoto(BuildContext context) async {
    String fileName = FirebaseAuth.instance.currentUser.uid;
    propertyDatabase = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/profiles/$fileName');

    await propertyDatabase.putFile(imageFile).whenComplete(() async {
      await propertyDatabase.getDownloadURL().then((value) {
        pref.setString('profileUrl', value.toString());
        Fluttertoast.showToast(msg: "Profile updated");
        setState(() {
          imageUrl = pref.getString("profileUrl");
        });
      });
    });
    setState(() {
      profileName = " ";
    });
  }

  Future<void> signoutUser() async {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, WelcomeScreen.idScreen, (route) => false);
    Fluttertoast.showToast(msg: "Logged out Succeffully");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', "");
    prefs.setString('phone', "");
    prefs.setString('occupation', "");
  }
}
