import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_real_estate_management_system/assets/CustomeIcons.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/navigateProperty.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class PropertyView extends StatefulWidget {
  static const idScreen = "Property View";
  @override
  _PropertyViewState createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  bool wishlisted = false;
  int length = 0;
  Icon done = Icon(Icons.done);
  Icon cancel = Icon(Icons.cancel);
  Map<String, dynamic> data;
  List<NetworkImage> imagesList = [];
  LatLng dest;
  firebase_storage.Reference propertyDatabase;

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    try {
      if (imagesList[0] == null) {
        //setData(context);
      }
      // ignore: non_constant_identifier_names
    } catch (Exception) {
      setData(context);
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * .4,
            decoration: BoxDecoration(
              image: DecorationImage(
                  image:
                      length > 0 ? imagesList[0] : NetworkImage(data["Image"]),
                  fit: BoxFit.cover),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * .68,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(45),
                      topRight: Radius.circular(45)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.2),
                        offset: Offset(0, -4),
                        blurRadius: 8),
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            data["name"],
                            style: GoogleFonts.lobster(
                              textStyle: Theme.of(context).textTheme.headline4,
                              color: Colors.black,
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              HapticFeedback.vibrate();
                              wishlisted = !wishlisted;
                            });
                          },
                          icon: Icon(
                            wishlisted
                                ? CustomIcons.favorite
                                : CustomIcons.favorite_border,
                            color: wishlisted ? Colors.red : Colors.black,
                            size: 34,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: Row(
                      children: [
                        Text(
                          data["Value"] != null
                              ? "₹ ${data["Value"]}"
                              : "₹ ${data["Rent"]}",
                          style: GoogleFonts.lobster(
                            textStyle: Theme.of(context).textTheme.headline4,
                            color: Colors.black,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 20,
                      left: 30,
                      right: 30,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 77,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "Furnished",
                                  style: GoogleFonts.rajdhani(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(data["isFurnished"] == "YES"
                                    ? Icons.done
                                    : Icons.disabled_by_default),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                            width: 120,
                            height: 77,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: Colors.black,
                                  style: BorderStyle.solid,
                                  width: 2),
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  "Negotiable",
                                  style: GoogleFonts.rajdhani(
                                    textStyle:
                                        Theme.of(context).textTheme.headline4,
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Icon(data["isNegotiable"] == "YES"
                                    ? Icons.done
                                    : Icons.cancel),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, NavigateToProperty.idScreen,
                                  arguments: dest);
                            },
                            child: Container(
                              width: 120,
                              height: 77,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Directions",
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.directions,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              launch("tel://${data["Contact"]}");
                            },
                            child: Container(
                              width: 120,
                              height: 77,
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black,
                                    style: BorderStyle.solid,
                                    width: 2),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                children: [
                                  Text(
                                    "Call",
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.call,
                                    size: 30,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 20, left: 30, right: 30),
                    child: Container(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        // mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              data["Description"],
                              overflow: TextOverflow.visible,
                              softWrap: true,
                              maxLines: 3,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.black,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Divider(
                            thickness: 2,
                            color: Colors.grey,
                          ),
                          Container(
                            child: Row(
                              children: [
                                Icon(Icons.location_city),
                                SizedBox(width: 15),
                                Flexible(
                                  child: Text(
                                    data["Address"],
                                    maxLines: 3,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            thickness: 1.5,
                            color: Colors.grey,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
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
              icon: Icon(Icons.message_outlined),
              backgroundColor: Colors.indigo.shade900,
              onPressed: () async {
                List<String> recipients = ["${data["Contact"]}"];
                String result = await sendSMS(
                        message:
                            "Hey, I came across your property named ${data["name"]}.I am interested ",
                        recipients: recipients)
                    .catchError((onError) {
                  print(onError.toString());
                });
                Fluttertoast.showToast(msg: result);
              },
              label: Text(
                "Message",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: 15,
            ),
            FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.send),
              backgroundColor: Colors.indigo.shade900,
              onPressed: () {},
              label: Text(
                "Request Lease",
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

  Future<dynamic> setData(BuildContext context) async {
    setState(() {
      dest = new LatLng(data["latitude"], data["longitude"]);
    });
    //print("Called");
    firebase_storage.ListResult result = await firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child(
            "images/property/${FirebaseAuth.instance.currentUser.uid}/${data["name"]}")
        .listAll();
    result.items.forEach((firebase_storage.Reference ref) {
      // print(ref.getDownloadURL().toString());
      setState(() {
        firebase_storage.FirebaseStorage.instance
            .ref()
            .child("${ref.fullPath}")
            .getDownloadURL()
            .then((value) {
          imagesList.add(new NetworkImage(value.toString()));
        });
      });
    });
    setState(() {
      try {
        if (imagesList[0] == null) {}
      } catch (Exception) {
        print("not updated");
      }
      length = imagesList.length;
    });
    // print("Called");
  }
}
