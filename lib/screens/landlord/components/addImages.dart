import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

class AddImages extends StatefulWidget {
  static const String idScreen = "addImageScreen";
  @override
  _AddImagesState createState() => _AddImagesState();
}

class _AddImagesState extends State<AddImages> {
  CollectionReference imgref;
  firebase_storage.Reference propertyDatabase;
  List<File> _image = [];
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add images"),
        centerTitle: true,
        automaticallyImplyLeading: true,
        actions: [
          TextButton(
            onPressed: () async {
              showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return ProgressDialog(
                      message: "Uploading..",
                    );
                  });
              if (_image.length > 0) {
                await uploadFile()
                    .whenComplete(() => Navigator.of(context).pop());
                //Fluttertoast.showToast(msg: "Uploading images done");
                // Navigator.popAndPushNamed(context, AddMap.idScreen);
                // dispose();
              } else {
                Navigator.pop(context);
                Fluttertoast.showToast(msg: "Please select atleast one image");
              }
            },
            child: Text(
              "Upload",
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ),
        ],
      ),
      body: GridView.builder(
          itemCount: _image.length + 1,
          gridDelegate:
              SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          itemBuilder: (context, index) {
            return index == 0
                ? Center(
                    child: IconButton(
                      icon: Icon(
                        Icons.add_a_photo_rounded,
                        color: greenThick,
                        size: 35,
                      ),
                      onPressed: () {
                        chooseImage();
                      },
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(_image[index - 1]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
          }),
    );
  }

  chooseImage() async {
    final pickedFile =
        await picker.getImage(source: ImageSource.gallery, imageQuality: 65);

    setState(() {
      _image.add(File(pickedFile?.path));
      print(pickedFile.path);
    });
    if (pickedFile.path == null) retrieveLostData();
  }

  Future<void> retrieveLostData() async {
    final LostData response = await picker.getLostData();
    if (response.isEmpty) return;
    if (response.file != null) {
      setState(() {
        _image.add(File(response.file.path));
        print(response.file.path);
      });
    } else
      print(response.file);
  }

  Future<void> uploadFile() async {
    String uid = FirebaseAuth.instance.currentUser.uid;
    final prefs = await SharedPreferences.getInstance();
    String pName = prefs.getString('pName');
    for (var img in _image) {
      propertyDatabase = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/property/$uid/$pName/${Path.basename(img.path)}');
      await propertyDatabase.putFile(img).whenComplete(() async {
        await propertyDatabase.getDownloadURL().then((value) {
          prefs.setString("pImage", value.toString());
        });
      });
    }
    await uploadPropertyData()
        .whenComplete(() => Fluttertoast.showToast(msg: "Details upload done"));
  }

  Future<void> uploadPropertyData() async {
    // await Firebase.initializeApp();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    CollectionReference cref;
    if (prefs.getString("pPurpose") == "Manage") {
      cref = FirebaseFirestore.instance
          .collection('Property')
          .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
          .collection("PropertyDetails");
      DocumentReference propertyDocumentReference =
          cref.doc("${prefs.getString('pName')}");
      Fluttertoast.showToast(msg: "Uploading Data");
      propertyDocumentReference.set({
        "name": prefs.getString("pName"),
        "Address": prefs.getString("pAddress"),
        "Landmark": prefs.getString("pLandmark"),
        "Description": prefs.getString("pDiscription"),
        "Contact": prefs.getString("pContact"),
        "Purpose": prefs.getString("pPurpose"),
        "RoomType": prefs.getString("roomType"),
        "Area": prefs.getDouble("pArea"),
        "Value": prefs.getDouble("pValue"),
        "Image": prefs.getString("pImage"),
        "GeoLocation": prefs.getString("Glocation"),
        "latitude": prefs.getDouble("pLat"),
        "longitude": prefs.getDouble("pLng"),
        "isNegotiable": prefs.getString("isNegotiable"),
        "isFurnished": prefs.getString("isFurnished"),
        "uid": FirebaseAuth.instance.currentUser.uid.toString(),
      }).then((_) {
        Navigator.of(context).pop();
        showSuccess(context);
      });
      return;
    } else if (prefs.getString("pPurpose") == "Lease") {
      cref = FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection("Lease");
      cref.add({
        "name": prefs.getString("pName"),
        "Address": prefs.getString("pAddress"),
        "Landmark": prefs.getString("pLandmark"),
        "Description": prefs.getString("pDiscription"),
        "Area": prefs.getDouble("pArea"),
        "Contact": prefs.getString("pContact"),
        "Purpose": prefs.getString("pPurpose"),
        "lease type": prefs.getString("leaseDuration"),
        "Preferse": prefs.getString("preferedTenants"),
        "RoomType": prefs.getString("roomType"),
        "Rent": prefs.getDouble("pValue"),
        "Image": prefs.getString("pImage"),
        "GeoLocation": prefs.getString("Glocation"),
        "latitude": prefs.getDouble("pLat"),
        "longitude": prefs.getDouble("pLng"),
        "isNegotiable": prefs.getString("isNegotiable"),
        "isFurnished": prefs.getString("isFurnished"),
        "uid": FirebaseAuth.instance.currentUser.uid.toString(),
      }).then((value) {
        Navigator.of(context).pop();
        showSuccess(context);
      });
    } else if (prefs.getString("pPurpose") == "Sale") {
      cref = FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection("Sale");
      cref.add({
        "name": prefs.getString("pName"),
        "Address": prefs.getString("pAddress"),
        "Landmark": prefs.getString("pLandmark"),
        "Description": prefs.getString("pDiscription"),
        "Contact": prefs.getString("pContact"),
        "Purpose": prefs.getString("pPurpose"),
        "RoomType": prefs.getString("roomType"),
        "Area": prefs.getDouble("pArea"),
        "Value": prefs.getDouble("pValue"),
        "Image": prefs.getString("pImage"),
        "GeoLocation": prefs.getString("Glocation"),
        "latitude": prefs.getDouble("pLat"),
        "longitude": prefs.getDouble("pLng"),
        "isNegotiable": prefs.getString("isNegotiable"),
        "isFurnished": prefs.getString("isFurnished"),
        "uid": FirebaseAuth.instance.currentUser.uid.toString(),
      }).then((value) {
        Navigator.of(context).pop();
        showSuccess(context);
      });
    }
  }

  void showSuccess(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            elevation: 16,
            child: Container(
              color: Colors.white,
              height: 400,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/growth 2.svg",
                    width: 400,
                    height: 200,
                  ),
                  Text(
                    "Success !",
                    style: GoogleFonts.lobster(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Your property was added successfully",
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 3,
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.idScreen, (route) => false);
                        },
                        child: Text(
                          "OK",
                          style:
                              TextStyle(fontSize: 15, color: Colors.pink[400]),
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

//{Path.basename(img.path)}
  @override
  void initState() {
    super.initState();
    imgref = FirebaseFirestore.instance.collection('propertyImages');
  }
}
