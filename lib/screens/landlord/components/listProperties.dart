import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class ListProperty extends StatefulWidget {
  static const String idScreen = "ListProperty";
  @override
  _ListPropertyState createState() => _ListPropertyState();
}

class _ListPropertyState extends State<ListProperty>
    with WidgetsBindingObserver {
  int properties = 0;
  int i = 0;
  List<Map<String, dynamic>> _propertyData = [];
  @override
  void initState() {
    getPropertyDetails();
    super.initState();
    //WidgetsBinding.instance.addObserver(this);
  }

  void getPropertyDetails() async {
    await FirebaseFirestore.instance
        .collection('Property')
        .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
        .collection("PropertyDetails")
        .get()
        .then((QuerySnapshot snap) {
      setState(() {
        i = 0;
        properties = snap.docs.length;
        snap.docs.forEach((record) {
          String docId = record.id.toString();
          _propertyData.add(record.data());
          _propertyData[i]["docId"] = docId;
          //    print("${_propertyData[i]["docId"]}  $i");
          ++i;
        });
      });
    });
    await FirebaseFirestore.instance
        .collection('Property')
        .doc('General')
        .collection('Sale')
        .where("uid",
            isEqualTo: "${FirebaseAuth.instance.currentUser.uid.toString()}")
        .get()
        .then((QuerySnapshot snap) {
      setState(() {
        properties += snap.docs.length;
        snap.docs.forEach((element) {
          String docId = element.id.toString();
          _propertyData.add(element.data());
          _propertyData[i]["docId"] = docId;
          //  print("${_propertyData[i]["docId"]}  $i");
          ++i;
        });
      });
    });
    await FirebaseFirestore.instance
        .collection('Property')
        .doc('General')
        .collection('Lease')
        .where("uid",
            isEqualTo: "${FirebaseAuth.instance.currentUser.uid.toString()}")
        .get()
        .then((QuerySnapshot snap) {
      setState(() {
        properties += snap.docs.length;
        snap.docs.forEach((element) {
          String docId = element.id.toString();
          _propertyData.add(element.data());
          _propertyData[i]["docId"] = docId;
          //    print("${_propertyData[i]["docId"]}  $i");
          ++i;
        });
      });
    });
    print("Property count is $properties");
    if (properties == 0) {
      final action = await AlertDialogs.confirmDialog(
          context, "Ouch!", "You haven't added any properties yet",
          cancel: "", yes: "Ok");
      if (action == DialogAction.Yes) {
        Navigator.pushNamedAndRemoveUntil(
            context, HomeScreen.idScreen, (route) => false);
      }
    }
  }

  Future<void> deleteProperty(Map<String, dynamic> map) async {
    if (map["Purpose"] == "Manage") {
      await FirebaseFirestore.instance
          .collection('Property')
          .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
          .collection("PropertyDetails")
          .doc(map["docId"])
          .delete()
          .then((value) async {
        firebase_storage.ListResult result = await firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child(
                "images/property/${FirebaseAuth.instance.currentUser.uid}/${map["name"]}")
            .listAll();
        result.items.forEach((firebase_storage.Reference ref) async {
          await firebase_storage.FirebaseStorage.instance
              .ref()
              .child("${ref.fullPath}")
              .delete();
        });
      });
    } else if (map["Purpose"] == "Lease") {
      await FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Lease')
          .doc(map["docId"])
          .delete()
          .then((value) async {
        firebase_storage.ListResult result = await firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child(
                "images/property/${FirebaseAuth.instance.currentUser.uid}/${map["name"]}")
            .listAll();
        result.items.forEach((firebase_storage.Reference ref) async {
          await firebase_storage.FirebaseStorage.instance
              .ref()
              .child("${ref.fullPath}")
              .delete();
        });
      });
    } else if (map["Purpose"] == "Sale") {
      await FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Sale')
          .doc(map["docId"])
          .delete()
          .then((value) async {
        firebase_storage.ListResult result = await firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child(
                "images/property/${FirebaseAuth.instance.currentUser.uid}/${map["name"]}")
            .listAll();
        result.items.forEach((firebase_storage.Reference ref) async {
          await firebase_storage.FirebaseStorage.instance
              .ref()
              .child("${ref.fullPath}")
              .delete();
        });
      });
    }
    showDeleteSuccess();
  }

  void showDeleteSuccess() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            elevation: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xFF1B222E),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 400,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/deleted.svg",
                    width: 400,
                    height: 200,
                  ),
                  Text(
                    "Success !",
                    style: GoogleFonts.lobster(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.blue,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Flexible(
                    child: Text(
                      "Your property was deleted successfully",
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 3,
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: greenThick,
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

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getPropertyDetails();
    super.didChangeAppLifecycleState(state);
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
            itemCount: properties,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, index) {
              return GestureDetector(
                onLongPress: () async {
                  final action = await AlertDialogs.confirmDialog(
                      context,
                      "Delete ?",
                      "Do you want to delete this property. This action can't be revoked",
                      yes: "YES",
                      cancel: "Cancel");
                  if (action == DialogAction.Yes) {
                    showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return ProgressDialog(
                            message: "Removing..",
                          );
                        });
                    await deleteProperty(_propertyData[index]);
                  }
                },
                child: Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.all(3),
                    width: double.infinity,
                    height: 700,
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
                                _propertyData[index]["Image"],
                                width: 300,
                                height: 150,
                                fit: BoxFit.fill),
                          ),
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
                                _propertyData[index]["name"],
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
                                  _propertyData[index]["Description"],
                                  overflow: TextOverflow.visible,
                                  softWrap: true,
                                  maxLines: 3,
                                  style: GoogleFonts.rajdhani(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
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
                                  _propertyData[index]["Address"],
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 3,
                                  style: GoogleFonts.rajdhani(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
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
                                _propertyData[index]["Purpose"],
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
                                _propertyData[index]["Value"] != null
                                    ? "Value : "
                                    : "Rent : ",
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
                                "??? ${_propertyData[index]["Value"] != null ? _propertyData[index]["Value"] : _propertyData[index]["Rent"]}",
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
                          Row(
                            children: <Widget>[
                              Text(
                                "Furnished : ",
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
                                _propertyData[index]["isFurnished"],
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
                                "Negotiable : ",
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
                                _propertyData[index]["isNegotiable"],
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
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
