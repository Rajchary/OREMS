import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/main.dart';
import 'package:online_real_estate_management_system/screens/Home/components/body.dart';
import 'package:online_real_estate_management_system/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //Person person = new Person();
  final auth = FirebaseAuth.instance;
  User firebaseUser;
  String name = " ", phone = "", occupatio = "";
  DatabaseReference userReference =
      FirebaseDatabase.instance.reference().child("Users");
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  Completer<GoogleMapController> _gmController = Completer();
  GoogleMapController _newGmController; //Defined for future purpose
  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  // AddOns ad = new AddOns();
  @override
  void initState() {
    _getUserData();
    super.initState();
  }

  _getUserData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
      occupatio = pref.getString('occupation');
      phone = pref.getString('phone');
    });
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      firebaseUser = auth.currentUser;
      DatabaseReference userReference =
          FirebaseDatabase.instance.reference().child("Users");
      userReference.child(firebaseUser.uid).once().then((DataSnapshot snap) {
        if (snap.value != null) {
          var values = snap.value;
          userDatavalues['name'] = values['name'];
          userDatavalues['phone'] = values['phone'];
          userDatavalues['occupation'] = values['occupation'];
        }
      });
    });
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Maps Screen"),
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
                      // Image.asset(
                      //   "assets/icons/person.png",
                      //   height: 64.0,
                      //   width: 64.0,
                      // ),
                      CircleAvatar(
                        radius: 50.0,
                        // backgroundImage: NetworkImage(
                        //     "file:///C:/Users/lenovo/Desktop/Dp.png"),
                        child: ClipRRect(
                          //   child: FadeInImage.memoryNetwork(
                          //       placeholder: kTransparentImage,
                          //       image:
                          //           ""), //Image.asset("assets/images/main_top.png"),
                          //   borderRadius: BorderRadius.circular(50.0),
                          // ),
                          child: Text(
                            name[0].toString(),
                            style: TextStyle(
                              color: Colors.black,//greenThick,
                              fontSize: 40,
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
      body: Body(), //Stack(
      //   children: [
      //     GoogleMap(
      //       mapType: MapType.normal,
      //       myLocationEnabled: true,
      //       initialCameraPosition: _kGooglePlex,
      //       onMapCreated: (GoogleMapController controller) {
      //         _gmController.complete(controller);
      //         _newGmController = controller;
      //       },
      //     ),
      //   ],
      // ),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  viewProfile() {
    //print(person.getName);
    Fluttertoast.showToast(msg: "Profile view");
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
