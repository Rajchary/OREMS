import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostTxn extends StatefulWidget {
  static const String idScreen = "Post_transaction";
  const PostTxn({Key key}) : super(key: key);

  @override
  _PostTxnState createState() => _PostTxnState();
}

class _PostTxnState extends State<PostTxn> {
  bool done = false;
  String purpose = "Sale";
  Map<String, dynamic> propertyData = {};
  Map<String, dynamic> userData = {};
  Map<String, dynamic> postTxnData = {};
  Size size;
  var colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];
  @override
  Widget build(BuildContext context) {
    if (postTxnData.isEmpty) {
      postTxnData = ModalRoute.of(context).settings.arguments;
      purpose = postTxnData["purpose"];
      changePropertyPrevilages(postTxnData["docId"], purpose);
    }
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: double.infinity,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: size.height * .015,
            ),
            if (done)
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      "assets/images/congo.svg",
                      height: size.height * .21,
                      width: size.width * .25,
                    ),
                    SizedBox(
                      height: size.height * .015,
                    ),
                    SizedBox(
                      width: size.width * .7, //250.0,
                      child: TextLiquidFill(
                        text: 'And We Made It',
                        waveColor: Colors.indigo[900],
                        boxBackgroundColor: Colors.white,
                        textStyle: TextStyle(
                          fontSize: size.width * .17,
                          fontWeight: FontWeight.bold,
                        ),
                        boxHeight: size.height * .2, //300.0,
                      ),
                    ),
                    SizedBox(
                      width: size.width * .7,
                      child: AnimatedTextKit(
                        animatedTexts: [
                          ColorizeAnimatedText(
                            purpose == "Sale"
                                ? "Congratulations Home sweet home!"
                                : "Congratulations on your new lease",
                            colors: colorizeColors,
                            textStyle: GoogleFonts.lobster(
                              textStyle: Theme.of(context).textTheme.headline4,
                              fontSize: size.width * .1,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * .015),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Color(0xFF1B222E),
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * .15,
                            vertical: size.height * .012),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Ok",
                        style: GoogleFonts.rajdhani(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.redAccent,
                          fontSize: size.width * .075,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            if (!done)
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      width: 250.0,
                      child: DefaultTextStyle(
                        style: GoogleFonts.lobster(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: size.width * .17,
                          color: Colors.indigo[900],
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        child: AnimatedTextKit(
                          animatedTexts: [
                            ScaleAnimatedText('Please Wait'),
                            ScaleAnimatedText('While we get'),
                            ScaleAnimatedText('Things ready for you !'),
                          ],
                          onTap: () {
                            print("Tap Event");
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> changePropertyPrevilages(String docId, String purpose) async {
    if (purpose == "Lease") {
      await FirebaseFirestore.instance
          .collection("Property")
          .doc("General")
          .collection(purpose)
          .doc(docId)
          .get()
          .then((value) {
        setState(() {
          propertyData = value.data();
          propertyData["leasedTo"] = FirebaseAuth.instance.currentUser.uid;
          propertyData["paidDate"] =
              "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}";
          propertyData["dueDate"] =
              "${DateTime.now().add(const Duration(days: 30))}";
        });
      });
      FirebaseFirestore.instance
          .collection("Property")
          .doc("General")
          .collection("Leased_Out")
          .doc(docId)
          .set(propertyData)
          .whenComplete(() async {
        await FirebaseFirestore.instance
            .collection("Property")
            .doc("General")
            .collection(purpose)
            .doc(docId)
            .get()
            .then((value) {
          value.reference.delete();
        });
        await connectTenantAndLandlord(postTxnData["uid"]);
      });
    } else if (purpose == "Sale") {
      await FirebaseFirestore.instance
          .collection("Property")
          .doc("General")
          .collection(purpose)
          .doc(docId)
          .get()
          .then((value) {
        setState(() {
          propertyData = value.data();
          propertyData["uid"] = "${FirebaseAuth.instance.currentUser.uid}";
          propertyData["Purpose"] = "Manage";
          //print(propertyData);
        });
      });
      await FirebaseFirestore.instance
          .collection("Property")
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection("PropertyDetails")
          .doc("${propertyData["name"]}")
          .set(propertyData)
          .whenComplete(() async {
        await FirebaseFirestore.instance
            .collection("Property")
            .doc("General")
            .collection(purpose)
            .doc(docId)
            .get()
            .then((value) {
          value.reference.delete();
        });
      });
    }
    await FirebaseFirestore.instance
        .collection("users")
        .doc(postTxnData["uid"])
        .get()
        .then((value) {
      setState(() {
        userData = value.data();
      });
    });
    await FirebaseFirestore.instance
        .collection("Property")
        .doc("General")
        .collection("MovedOuts")
        .doc(docId)
        .set(propertyData)
        .whenComplete(() async {
      await saveTransaction();
    });
  }

  Future<void> connectTenantAndLandlord(String uid) async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "Tenants.${FirebaseAuth.instance.currentUser.uid}":
          "${propertyData["name"]}"
    });
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .update({"Landlords.$uid": "${propertyData["name"]}"});
  }

  Future<void> saveTransaction() async {
    final prefs = await SharedPreferences.getInstance();
    await FirebaseFirestore.instance
        .collection("Transactions")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("Sent")
        .doc(postTxnData["txnId"])
        .set({
      "TxnId": "${postTxnData["txnId"]}",
      "TxnRef": "${postTxnData["txnRef"]}",
      "Status": "${postTxnData["Status"]}",
      "Date": "${postTxnData["Date"]}",
      "To": "${userData["name"]}",
      "ProfilePicture": "${userData["ProfilePicture"]}",
      "Amount": "${postTxnData["amount"]}",
      "TxnNote": purpose == "Lease"
          ? "For leasing ${propertyData["name"]}"
          : "For buying the property ${propertyData["name"]}",
      "upi_id": "${userData["upi_id"]}"
    }).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("Transactions")
          .doc(postTxnData["uid"])
          .collection("Recieved")
          .doc(postTxnData["txnId"])
          .set({
        "TxnId": "${postTxnData["txnId"]}",
        "TxnRef": "${postTxnData["txnRef"]}",
        "Status": "${postTxnData["Status"]}",
        "Date": "${postTxnData["Date"]}",
        "From": "${prefs.getString("name")}",
        "ProfilePicture": "${prefs.getString("profileUrl")}",
        "Amount": "${postTxnData["amount"]}",
        "TxnNote": purpose == "Lease"
            ? "For leasing out ${propertyData["name"]}"
            : "For selling the property ${propertyData["name"]}",
        "upi_id": "${userData["upi_id"]}"
      }).whenComplete(() async {
        setState(() {
          done = true;
        });
      });
    });
  }
}
