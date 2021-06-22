import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileCheck extends StatefulWidget {
  static const idScreen = "ProfileCheck";
  const ProfileCheck({Key key}) : super(key: key);

  @override
  _ProfileCheckState createState() => _ProfileCheckState();
}

class _ProfileCheckState extends State<ProfileCheck> {
  double one = 1, two = 2, three = 3, four = 4, five = 5;
  String uid = "tRml8y7IIQYPa43HobAzZbawtf02";
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
              // ElevatedButton(
              //     onPressed: () async {
              //       getRemarksOfUser(uid);
              //     },
              //     child: Text("Get")),
              Container(
                height: 100,
                child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: size.width / (size.height / 9)),
                    // scrollDirection: Axis.vertical,
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
            ],
          ),
        ),
      ),
    );
  }
}
