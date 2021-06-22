import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends StatefulWidget {
  static const String idScreen = "provileView";
  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  firebase_storage.Reference propertyDatabase;
  Map<String, dynamic> _userData = {};
  DatabaseReference userReference =
      FirebaseDatabase.instance.reference().child("Users");
  TextEditingController nameController = new TextEditingController();
  TextEditingController occupationController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  SharedPreferences pref;
  Color iconColor;
  Color containerColor;
  Color backgroundColor;
  bool isDarkMode = true;
  bool isUpdated = false;
  File imageFile;
  AnimationController animationController;
  String imageUrl = "https://www.woolha.com/media/2020/03/eevee.png";

  @override
  void initState() {
    _getUserData();
    _setMode();
    super.initState();
  }

  _getUserData() async {
    pref = await SharedPreferences.getInstance();
    imageUrl = pref.getString("profileUrl");
    await FirebaseFirestore.instance
        .collection("users")
        .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
        .get()
        .then((value) {
      setState(() {
        nameController.text = value.data()["name"];
        addressController.text = value.data()["userAddress"];
        phoneController.text = value.data()["phone"];
        occupationController.text = value.data()["occupation"];
      });
    });
  }

  _setMode() {
    iconColor = isDarkMode ? Colors.yellow : Colors.deepOrangeAccent;
    containerColor = isDarkMode ? Colors.black : Colors.white;
    backgroundColor = isDarkMode ? Colors.black : Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var route = ModalRoute.of(context).settings.name;
    return Scaffold(
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        child: AnimatedContainer(
          duration: Duration(seconds: 1),
          color: containerColor,
          //r height: size.height,
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        // print(route);
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back_ios_new),
                      iconSize: 25,
                      color: iconColor,
                    ),
                    SizedBox(width: 230),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          isDarkMode = isDarkMode ? false : true;
                          _setMode();
                        });
                      },
                      icon: isDarkMode
                          ? Icon(Icons.dark_mode)
                          : Icon(Icons.wb_sunny),
                      iconSize: 25,
                      color: iconColor,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              GestureDetector(
                onTap: () async {
                  final action = await AlertDialogs.confirmDialog(context,
                      "Update ?", "Do you wanna update new profile image ??");
                  if (action == DialogAction.Yes) {
                    _chooseImage();
                  }
                },
                child: Container(
                  width: 140.0,
                  height: 140.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Your information",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.deepOrangeAccent,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  isUpdated = true;
                },
                controller: nameController,
                autocorrect: true,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Name',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  isUpdated = true;
                },
                controller: phoneController,
                keyboardType: TextInputType.phone,
                autocorrect: true,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Mobile number',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                onChanged: (value) {
                  isUpdated = true;
                },
                controller: occupationController,
                autocorrect: true,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Occupation',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                maxLines: 3,
                onChanged: (value) {
                  isUpdated = true;
                },
                controller: addressController,
                autocorrect: true,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  hintText: 'Address',
                  hintStyle: TextStyle(color: Colors.white),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.green),
                  ),
                ),
              ),
              SizedBox(
                height: 35,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  isUpdated
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: greenThick,
                          ),
                          onPressed: () async {
                            await updateUserInfo().whenComplete(() =>
                                Fluttertoast.showToast(
                                    msg: 'Details updated successfully'));
                          },
                          child: Text(
                            "Save",
                            style: GoogleFonts.rajdhani(
                              textStyle: Theme.of(context).textTheme.headline4,
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        )
                      : Container(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Cancel",
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 235,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
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
    await uploadProfilePhoto(context)
        .whenComplete(() => Navigator.of(context).pop());
  }

  Future uploadProfilePhoto(BuildContext context) async {
    String fileName = FirebaseAuth.instance.currentUser.uid;
    propertyDatabase = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/profiles/$fileName');

    await propertyDatabase.putFile(imageFile).whenComplete(() async {
      await propertyDatabase.getDownloadURL().then((value) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({
          "ProfilePicture": value,
        });
        pref.setString('profileUrl', value.toString());
        Fluttertoast.showToast(msg: "Profile updated");
        setState(() {
          imageUrl = pref.getString("profileUrl");
        });
      });
    });
    isUpdated = false;
  }

  Future<dynamic> updateUserInfo() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Updating..",
          );
        });
    await FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser.uid}')
        .set({
      "name": nameController.text.trim(),
      "phone": phoneController.text.trim(),
      "occupation": occupationController.text.trim(),
      "userAddress": addressController.text.trim(),
    }, SetOptions(merge: true)).then((value) => Navigator.pop(context));
    isUpdated = false;
  }
}
