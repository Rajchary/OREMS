import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/services/Notification.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProfileCheck extends StatefulWidget {
  static const idScreen = "ProfileCheck";
  const ProfileCheck({Key key}) : super(key: key);

  @override
  _ProfileCheckState createState() => _ProfileCheckState();
}

class _ProfileCheckState extends State<ProfileCheck> {
  double one = 1, two = 2, three = 3, four = 4, five = 5;
  Size size;
  String imageUrl = "https://www.woolha.com/media/2020/03/eevee.png";
  Map<String, dynamic> userData = {};
  Map<String, dynamic> propertyData = {};
  Iterable<String> issues = [];
  Iterable<dynamic> description = [];
  Map<String, dynamic> data = {};

  Future<void> getPropertyData(String docId, String purpose) async {
    await FirebaseFirestore.instance
        .collection("Property")
        .doc("General")
        .collection(purpose)
        .doc(docId)
        .get()
        .then((value) {
      setState(() {
        propertyData = value.data();
      });
    });
  }

  Future<void> getUserData(String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(docId)
        .get()
        .then((value) {
      setState(() {
        userData = value.data();

        // imageUrl = userData["ProfilePicture"];
      });
    });
  }

  Future<void> getRemarksOfUser(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection("Remarks")
          .doc(userId)
          .get()
          .then((value) async {
        setState(() {
          if (value != null) {
            print("Came here");
            setState(() {
              issues = value.data().keys;
              print("Came here $issues");
              print("Values are ${value.data().values}");
              description = value.data().values;
            });
          } else {
            print("Data not available");
          }
        });
      });
    } catch (error) {
      print("Error occured $error");
    }
  }

  @override
  void initState() {
    // userData["Rating"] = 3;
    //  getUserData(data["uid"]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (userData.isEmpty) {
      String data1 = ModalRoute.of(context).settings.arguments;
      data = jsonDecode(data1);
      getUserData(data["uid"]);
      getPropertyData(data["docId"], data["Purpose"]);
      getRemarksOfUser(data["uid"]);
    }

    print(issues.length);
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(0xFF1B222E),
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * 0.015,
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      size: size.width * 0.075,
                      color: Colors.yellowAccent,
                    ),
                  ),
                ],
              ),
              Container(
                width: size.width * 0.4,
                height: size.height * 0.19,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.teal,
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Divider(
                color: Colors.grey,
                height: 2,
                thickness: 2,
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "User Details",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.yellowAccent,
                    fontSize: size.width * .045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              Row(
                children: [
                  Text(
                    "Name : ",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.blue,
                      fontSize: size.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: size.width * .015,
                  ),
                  Text(
                    "${userData["name"]}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.teal,
                      fontSize: size.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Row(
                children: [
                  Text(
                    "Contact : ",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.blue,
                      fontSize: size.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: size.width * .015,
                  ),
                  Text(
                    "${userData["phone"]}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.teal,
                      fontSize: size.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * 0.015,
              ),
              Row(
                children: [
                  Text(
                    "Occupation : ",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.blue,
                      fontSize: size.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: size.width * .015,
                  ),
                  Text(
                    "${userData["occupation"]}",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.teal,
                      fontSize: size.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Row(
                children: [
                  Icon(
                    one <= userData["Rating"]
                        ? Icons.star
                        : Icons.star_border_sharp,
                    color: Colors.yellowAccent,
                  ),
                  SizedBox(
                    width: size.width * .011,
                  ),
                  Icon(
                    two <= userData["Rating"]
                        ? Icons.star
                        : Icons.star_border_sharp,
                    color: Colors.yellowAccent,
                  ),
                  SizedBox(
                    width: size.width * .011,
                  ),
                  Icon(
                    three <= userData["Rating"]
                        ? Icons.star
                        : Icons.star_border_sharp,
                    color: Colors.yellowAccent,
                  ),
                  SizedBox(
                    width: size.width * .011,
                  ),
                  Icon(
                    four <= userData["Rating"]
                        ? Icons.star
                        : Icons.star_border_sharp,
                    color: Colors.yellowAccent,
                  ),
                  SizedBox(
                    width: size.width * .011,
                  ),
                  Icon(
                    five <= userData["Rating"]
                        ? Icons.star
                        : Icons.star_border_sharp,
                    color: Colors.yellowAccent,
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Container(
                height: 100,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: size.width / (size.height / 9)),
                    itemCount: (issues == null || issues.length == 0)
                        ? 1
                        : issues.length,
                    itemBuilder: (ctxt, index) {
                      return (issues == null || issues.length == 0)
                          ? Text(
                              "No remarks available ",
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.teal,
                                fontSize: size.width * .065,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : Container(
                              child: Column(
                                children: [
                                  Text(
                                    "${issues.elementAt(index)}",
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.yellowAccent,
                                      fontSize: size.width * .045,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Flexible(
                                    child: Text(
                                      "${description.elementAt(index)}",
                                      overflow: TextOverflow.visible,
                                      softWrap: true,
                                      maxLines: 3,
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.teal,
                                        fontSize: size.width * .045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.grey,
                                    thickness: 1.5,
                                    height: 1.5,
                                  ),
                                ],
                              ),
                            );
                    }),
              ),
              Divider(
                color: Colors.grey,
                height: 2,
                thickness: 2,
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "Property Details",
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.yellowAccent,
                    fontSize: size.width * .045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ]),
              ExpansionTile(
                collapsedIconColor: Colors.white,
                backgroundColor: Colors.black,
                title: Text(
                  "${propertyData["name"]}",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.teal,
                    fontSize: size.width * .065,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                children: [
                  Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * .015,
                        ),
                        Text(
                          propertyData["Purpose"] == "Sale"
                              ? "₹ ${propertyData["Value"]}"
                              : "₹ ${propertyData["Rent"]}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rajdhani(
                            textStyle: Theme.of(context).textTheme.headline4,
                            color: Colors.teal,
                            fontSize: size.width * .055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * .015,
                        ),
                        Text(
                          "${propertyData["Description"]}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rajdhani(
                            textStyle: Theme.of(context).textTheme.headline4,
                            color: Colors.teal,
                            fontSize: size.width * .055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: size.height * .015,
                        ),
                        Text(
                          "Purpose is to : ${propertyData["Purpose"]}",
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.rajdhani(
                            textStyle: Theme.of(context).textTheme.headline4,
                            color: Colors.teal,
                            fontSize: size.width * .055,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: size.height * .055,
                      width: size.width * 0.65,
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () async {
                        final action = await AlertDialogs.confirmDialog(context,
                            "Reject ?", "Are you sure you wanna do that",
                            yes: "Yes", cancel: "No");
                        if (action == DialogAction.Yes) {
                          Navigator.pop(context);
                        }
                      },
                      label: Text(
                        "Cancel",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rajdhani(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.red,
                          fontSize: size.width * .075,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(
                        Icons.cancel_outlined,
                        color: Colors.red,
                        size: size.width * .065,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .017,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints.tightFor(
                      height: size.height * .055,
                      width: size.width * 0.65,
                    ),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black,
                      ),
                      onPressed: () async {
                        final action = await AlertDialogs.confirmDialog(context,
                            "Approve ?", "Are you sure you wanna do that",
                            yes: "Yes", cancel: "No");
                        if (action == DialogAction.Yes) {
                          await sendNotification(
                              data["uid"],
                              propertyData["name"],
                              data["docId"],
                              propertyData["Purpose"]);
                          // CustomNotification.notifyUser(
                          //     data["uid"],
                          //     data["name"],
                          //     data["docId"],
                          //     propertyData["Purpose"],
                          //     "has approved your request",
                          //     "Tenant",
                          //     "002",
                          //     "Acknowledgement sent!");
                        }
                      },
                      label: Text(
                        "Approve",
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.rajdhani(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: greenThick,
                          fontSize: size.width * .075,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      icon: Icon(
                        Icons.done,
                        color: greenThick,
                        size: size.width * .065,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * .015,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> sendNotification(
      receiver, String pName, String docId, String purpose) async {
    String serverKey =
        "AAAAQc2YwIo:APA91bFEi7E37NseKuYFm1iOXwiYEZuudjiZzNY27HkBzhG8sjiPf3QPV1V2w8XA7Vf8XmE7vq5JrxRObveM5cFAsJry1-r1jM_EzvLkyCIoWC-l0H0397xLxjPV6sLQiIQ4pM-_5U8l";
    final prefs = await SharedPreferences.getInstance();
    var token = await getToken(receiver);
    print("Token $token");
    Map<String, dynamic> postData = {
      "uid": "${FirebaseAuth.instance.currentUser.uid}",
      "docId": "$docId",
      "Purpose": "$purpose",
      "to": "Tenant",
    };
    try {
      final response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '${prefs.getString("name")} has approved your request',
              'title': '$pName'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'sound': 'default',
              'color': 'blue',
              'id': '002',
              'status': 'done',
              'screen': 'To Tenant',
              'postData': postData,
              // 'docId': "$docId",
              // 'uid': '${FirebaseAuth.instance.currentUser.uid}'
            },
            'to': token,
          },
        ),
      );
      print('FCM request for device sent!');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Acknowledgement Sent To Tenant');
      } else {
        print('notification sending failed with code ${response.statusCode}');
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
}
