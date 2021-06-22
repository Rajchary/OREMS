import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/assets/CustomeIcons.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/screens/Home/Services/listUpi.dart';
import 'package:upi_pay/upi_pay.dart';

class MakePayment extends StatefulWidget {
  static const String idScreen = "paymentScreen";
  const MakePayment({Key key}) : super(key: key);

  @override
  _MakePaymentState createState() => _MakePaymentState();
}

class _MakePaymentState extends State<MakePayment> {
  Map<String, dynamic> userData = {};
  Map<String, dynamic> propertyData = {};
  Map<String, dynamic> data = {};
  String imageUrl = "https://www.woolha.com/media/2020/03/eevee.png";
  Size size;
  TextEditingController moneyController = new TextEditingController();
  List<ApplicationMeta> appMetaList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    moneyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (userData.isEmpty) {
      String data1 = ModalRoute.of(context).settings.arguments;
      data = jsonDecode(data1);
      getUserData(data["uid"]);
      getPropertyData(data["docId"], data["Purpose"]);
    }
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
                      color: Colors.redAccent,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * .015,
                  ),
                  Container(
                    width: size.width * .25,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.redAccent, width: 3.0),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.4,
                    height: size.height * 0.19,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.redAccent,
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * .25,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.redAccent, width: 3.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Owner Details",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.yellowAccent,
                      fontSize: size.width * .045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * .015),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Name : ",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.redAccent,
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
                height: size.height * .015,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Phone : ",
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.redAccent,
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
                collapsedTextColor: Colors.teal,
                backgroundColor: Colors.black,
                title: Text(
                  "${propertyData["name"]}",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.redAccent,
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
                          // "₹ 1150",
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
                          // "Some description will show here",
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
                          // "Purpose is to : Sale",
                          "${propertyData["Purpose"]}",
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
              TextField(
                controller: moneyController,
                keyboardType: TextInputType.number,
                readOnly: true,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.blue,
                  fontSize: size.width * .055,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    CustomIcons.rupee,
                    color: Colors.blue,
                  ),
                ),
              ),
              SizedBox(
                height: size.height * .015,
              ),
              // RoundedInputField(
              //   hintText: "money to be paid",
              //   textcontroller: moneyController,
              //   textInputType: TextInputType.number,
              //   lines: 1,
              //   icon: CustomIcons.rupee,
              //   onChanged: (value) async {
              //     if (value.isEmpty)
              //       Fluttertoast.showToast(msg: "Type some amount");
              //   },
              // ),
              SizedBox(
                height: size.height * .015,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.height * .15,
                      vertical: size.height * .009),
                  primary: Colors.redAccent,
                ),
                onPressed: () async {
                  if (moneyController.text.isNotEmpty) {
                    print(moneyController.text.trim());
                    Map<String, dynamic> transactionData = {
                      "amount": moneyController.text.trim(),
                      "Reciever_name": userData["name"],
                      "Reciever_upi": userData["upi_id"],
                      "note": propertyData["purpose"] == "Sale"
                          ? "For buying property ${propertyData["name"]}"
                          : "For taking lease of the property ${propertyData["name"]}",
                      "refId": Random.secure().nextInt(1 << 32).toString(),
                      "uid": data["uid"],
                      "docId": data["docId"],
                      "purpose": data["Purpose"],
                    };
                    Navigator.pushNamed(context, ListUpi.idScreen,
                        arguments: transactionData);
                  } else {
                    Fluttertoast.showToast(msg: "Please provide some amount");
                  }
                },
                child: Text(
                  "Pay",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.white,
                    fontSize: size.width * .075,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getUserData(String uid) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .get()
        .then((value) {
      setState(() {
        userData = value.data();
      });
    });
  }

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
        moneyController.text = propertyData["Purpose"] == "Sale"
            ? "${propertyData["Value"]}"
            : "${propertyData["Rent"]}";
      });
    });
  }

  Future<void> setCreds() async {
    final List<ApplicationMeta> _appMetaList =
        await UpiPay.getInstalledUpiApplications();
    setState(() {
      appMetaList = _appMetaList;
    });
  }
}
