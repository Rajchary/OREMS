import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:online_real_estate_management_system/assets/CustomeIcons.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/navigateProperty.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:http/http.dart' as http;

class PropertyView extends StatefulWidget {
  static const idScreen = "Property View";
  @override
  _PropertyViewState createState() => _PropertyViewState();
}

class _PropertyViewState extends State<PropertyView> {
  bool wishlisted = false;
  bool checked = false;
  int length = 0;
  Icon done = Icon(Icons.done);
  Icon cancel = Icon(Icons.cancel);
  Map<String, dynamic> data;
  List<NetworkImage> imagesList = [];
  LatLng dest;
  firebase_storage.Reference propertyDatabase;

  static Future<void> sendNotification(receiver, String pName) async {
    // var postUrl = "http://fcm.googleapis.com/fcm/send";
    String serverKey =
        "Paste your server key here";
    final prefs = await SharedPreferences.getInstance();
    var token = await getToken(receiver);
    print("Token $token");
    try {
      //   Uri.parse("https://api.rnfirebase.io/messaging/send"),
      final response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body':
                  '${prefs.getString("name")} is willing to connect with you',
              'title': '$pName'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'sound': 'default',
              'color': 'blue',
              'id': '1',
              'status': 'done',
              'screen': 'Engage',
              'uid': '${FirebaseAuth.instance.currentUser.uid}'
            },
            'to': token,
          },
        ),
      ); //Dio(options).post(postUrl, data: data);
      print('FCM request for device sent!');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Request Sent To Owner');
      } else {
        print('notification sending failed with code ${response.statusCode}');
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
    }
  }

  static Future<String> getToken(userId) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    var token;
    await _db
        .collection('users')
        .doc(userId)
        .collection('tokens')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        token = doc.id;
      });
    });

    return token;
  }

  Future<void> addToFavourites(String docId, String purpose) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid.toString())
        .update({
      "Favourites.$docId": "$purpose",
    }).then((_) => Fluttertoast.showToast(msg: "Added to favourites"));
  }

  Future<void> removeFromFavourites(String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid.toString())
        .update({
      "Favourites.$docId": FieldValue.delete(),
    }).then((_) => Fluttertoast.showToast(msg: "Removed from favourites"));
  }

  Future<void> checkIfFavourite(String docId) async {
    setState(() {
      checked = true;
    });
    Map<String, dynamic> favList;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid.toString())
        .get()
        .then((doc) {
      setState(() {
        favList = doc.data()["Favourites"];
      });
    });
    if (favList != null) {
      if (favList.containsKey(docId)) {
        setState(() {
          wishlisted = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    data = ModalRoute.of(context).settings.arguments;
    if (!checked) checkIfFavourite(data["docId"]);
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
              height: size.height * .68,
              width: size.width,
              decoration: BoxDecoration(
                  color: Colors.white, //[50],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(75),
                      topRight: Radius.circular(0)),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(.99),
                        offset: Offset(5, -25),
                        blurRadius: 50),
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
                              fontSize: size.width * 0.1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            setState(() {
                              HapticFeedback.vibrate();
                              wishlisted = !wishlisted;
                            });
                            if (wishlisted) {
                              await addToFavourites(
                                  data["docId"], data["Purpose"]);
                            } else {
                              await removeFromFavourites(data["docId"]);
                            }
                          },
                          icon: Icon(
                            wishlisted
                                ? CustomIcons.favorite
                                : CustomIcons.favorite_border,
                            color: wishlisted ? Colors.red : Colors.black,
                            size: size.width * 0.09,
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
                            fontSize: size.width * 0.07,
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
                            width: size.width * 0.3,
                            height: size.width * 0.2,
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
                                    fontSize: size.width * 0.045,
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
                            width: size.width * 0.3,
                            height: size.width * 0.2,
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
                                    fontSize: size.width * 0.045,
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
                              width: size.width * 0.3,
                              height: size.width * 0.2,
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
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.directions,
                                    size: size.width * 0.07,
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
                              width: size.width * 0.3,
                              height: size.width * 0.2,
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
                                      fontSize: size.width * 0.045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Icon(
                                    Icons.call,
                                    size: size.width * 0.07,
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
                                fontSize: size.width * 0.045,
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
                                      fontSize: size.width * 0.045,
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
                  fontSize: size.width * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              width: size.width * 0.04,
            ),
            FloatingActionButton.extended(
              heroTag: null,
              icon: Icon(Icons.send),
              backgroundColor: Colors.indigo.shade900,
              onPressed: () {
                sendNotification(data["uid"], data["name"]);
              },
              label: Text(
                "Request Lease",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: size.width * 0.045,
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
        // print("not updated");
      }
      length = imagesList.length;
    });
  }
}
