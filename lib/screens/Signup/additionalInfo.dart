import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/already_have_an_account.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/components/roundedButton.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/main.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/background.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/firestoreUser.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/orDevider.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/socialMediaContainer.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/verifyUser.dart';
import 'package:online_real_estate_management_system/screens/login/login_screen.dart';
import 'package:online_real_estate_management_system/screens/userProperties.dart';
import 'package:online_real_estate_management_system/services/addOns.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AddInfo extends StatefulWidget {
  static const String idScreen = "AddInfo";
  @override
  _AddInfoState createState() => _AddInfoState();
}

class _AddInfoState extends State<AddInfo> {
  String currentOccupation = 'What describes you best';
  String currentDoccument = "I have ";
  Person user = new Person();
  bool selected = false;
  SharedPreferences prefs;
  TextEditingController kycId;
  TextEditingController paddress;
  TextEditingController upiController = new TextEditingController();
  TextInputType textInputType = TextInputType.text;
  @override
  void initState() {
    kycId = new TextEditingController();
    paddress = new TextEditingController();
    // print(user.getName);
    service();
    super.initState();
  }

  Future<void> service() async {
    prefs = await SharedPreferences.getInstance();
    print(prefs.getString("name"));
  }

  bool validate(String word) {
    if (word.isEmpty) {
      Fluttertoast.showToast(msg: "Thats an empty field");
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      //backgroundColor: Colors.white,
      body: Background(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(height: size.height * 0.15),
              Text(
                "OREMS",
                style: GoogleFonts.lobster(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.deepPurple,
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  fontStyle: FontStyle.italic,
                  letterSpacing: .9,
                ),
              ),
              SvgPicture.asset(
                "assets/icons/login_screen.svg",
                height: size.height * 0.35,
              ),
              Text(
                "Please fill in more details",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.deepOrange, //greenThick,
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 15),
              Center(
                child: DropdownButton<String>(
                  value: currentOccupation,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: greenThick,
                    size: 25,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                  underline: Container(height: 2, color: Colors.white),
                  onChanged: (String newValue) {
                    setState(() {
                      currentOccupation = newValue;
                      // selected =
                      //     (currentOccupation != "What describes you best")
                      //         ? true
                      //         : false;
                      prefs.setString("occupation", currentOccupation);
                    });
                  },
                  items: <String>[
                    'What describes you best',
                    "Landlord",
                    "Tenant",
                    "Organization representative",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: greenThick),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              RoundedInputField(
                hintText: "Your Permanent address",
                textInputType: textInputType,
                textcontroller: paddress,
                lines: 3,
                onChanged: (value) {
                  validate(value);
                },
                icon: Icons.home,
              ),
              SizedBox(
                height: 10,
              ),
              RoundedInputField(
                hintText: "@Upi_id",
                textInputType: textInputType,
                textcontroller: upiController,
                lines: 1,
                onChanged: (value) {
                  validate(value);
                },
                icon: Icons.payment,
              ),
              SizedBox(height: 10),
              Center(
                child: DropdownButton<String>(
                  value: currentDoccument,
                  icon: const Icon(
                    Icons.arrow_drop_down,
                    color: greenThick,
                    size: 25,
                  ),
                  iconSize: 24,
                  elevation: 16,
                  style: const TextStyle(color: Colors.black, fontSize: 25),
                  underline: Container(height: 2, color: Colors.white),
                  onChanged: (String newValue) {
                    setState(() {
                      currentDoccument = newValue;
                      selected = (currentDoccument != "I have ") ? true : false;
                      if (selected)
                        prefs.setString("kycDocument", currentDoccument.trim());
                    });
                  },
                  items: <String>[
                    "I have ",
                    "Aadhaar Card",
                    "Passport",
                    "PAN Card",
                    "Voter's Identity Card",
                    "Driving License",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: greenThick),
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 15),
              selected
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RoundedInputField(
                          hintText: "KYC Document ID ",
                          textInputType: textInputType,
                          textcontroller: kycId,
                          onChanged: (value) {
                            validate(value);
                          },
                          icon: Icons.document_scanner,
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        RoundedButton(
                            text: "Signup",
                            press: () async {
                              if (finalValidation()) {
                                int result = await registerNewUser(context);
                                //Future<int> expected = Future<int>.parse(1);
                                if (result == 1) {
                                  Navigator.pushNamedAndRemoveUntil(context,
                                      VerifyUser.idScreen, (route) => false);
                                }
                              }
                            },
                            white: Colors.white),
                        SizedBox(height: size.height * 0.03),
                      ],
                    )
                  : Container(),
              SizedBox(height: size.height * 0.02),
              AlreadyHaveAnAccount(
                  login: false,
                  press: () async {
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    prefs.clear();
                    Navigator.pushNamedAndRemoveUntil(
                        context, LoginScreen.idScreen, (route) => false);
                  }),
              SizedBox(
                height: 15,
              ),
              OrDevider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(width: size.width * 0.1),
                  SocialMediaContainer(
                    iconSrc: "assets/icons/facebook.svg",
                    press: () {},
                  ),
                  SocialMediaContainer(
                    iconSrc: "assets/icons/google-plus.svg",
                    press: () {},
                  ),
                  SocialMediaContainer(
                    iconSrc: "assets/icons/twitter.svg",
                    press: () {},
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  bool finalValidation() {
    if (paddress.text.isEmpty ||
        kycId.text.isEmpty ||
        upiController.text.isEmpty) {
      Fluttertoast.showToast(msg: "That's an empty field");
      return false;
    } else if (!upiController.text.contains("@") ||
        upiController.text.split("@").length != 2) {
      Fluttertoast.showToast(msg: "Please provide a valid UPI id");
      return false;
    } else if (currentOccupation == 'What describes you best') {
      Fluttertoast.showToast(msg: "Please select the occupation");
      return false;
    }
    return true;
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Future<int> registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Registering..",
          );
        });
    UserCredential firebaseUser;
    try {
      firebaseUser = await _firebaseAuth.createUserWithEmailAndPassword(
          email: prefs.getString("email"),
          password: prefs.getString("password"));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Fluttertoast.showToast(msg: 'The password provided is too weak.');
        Navigator.pop(context);
        return 0;
      } else if (e.code == 'email-already-in-use') {
        Fluttertoast.showToast(
            msg: 'The account already exists for that email.');
        Navigator.pop(context);
        return 0;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Occured");
      Navigator.pop(context);
      return 0;
    }
    // final UserCredential firebaseUser = await _firebaseAuth
    //         .createUserWithEmailAndPassword(
    //             email: prefs.getString("email"),
    //             password: prefs.getString("password"))
    //         .catchError((errormsg) {
    //   Navigator.pop(context);
    //   showToast("Error " + errormsg.toString(), context);
    // }).user;
    if (firebaseUser != null) {
      //User created successfully
      prefs.setString("userAddress", paddress.text.trim());
      prefs.setString("kycdocument", currentDoccument.trim());
      prefs.setString("kycid", kycId.text.trim());
      prefs.setString("upiId", upiController.text.trim());
      Map userDataMap = {
        "name": prefs.getString("name").trim(),
        "email": prefs.getString("email").trim(),
        "phone": prefs.getString("phone").trim(),
        "password": prefs.getString("password").trim(),
        "occupation": prefs.getString("occupation").trim(),
        "Address": paddress.text.trim(),
        "KYCDocument": currentDoccument.trim(),
        "KYCid": kycId.text.trim(),
      };
      // if (!kIsWeb) {
      //   await userRef.child(firebaseUser.uid).set(userDataMap);
      //   showToast("Validate your emil id !!..", context);
      // }
      DocumentReference documentReferencer = userCollection
          .doc(FirebaseAuth.instance.currentUser.uid); //firebaseUser.uid);
      UserData userC = UserData(
        email: prefs.getString("email").trim(),
        name: prefs.getString("name").trim(),
        occupation: prefs.getString("occupation").trim(),
        password: prefs.getString("password").trim(),
        mobile: prefs.getString("phone").trim(),
        paddress: prefs.getString("userAddress").trim(),
        kycdocument: prefs.getString("kycdocument").trim(),
        kycid: prefs.getString("kycid").trim(),
        upi_id: prefs.getString("upiId"),
        profilePicture: "https://www.woolha.com/media/2020/03/eevee.png",
        rating: 5,
        ratingCount: 1,
      );
      var data = userC.toJson();
      await documentReferencer
          .set(data)
          .whenComplete(() => {})
          .onError((error, stackTrace) {
        Fluttertoast.showToast(
            msg: "Some technical error we are working on it..");
        Navigator.pop(context);
        return 0;
      });
      await _saveUserData(context);
    } else {
      Navigator.pop(context);
      showToast("Oops! Something went wrong..", context);
      return 0;
    }
    return 1;
  }

  _saveUserData(BuildContext context) {
    prefs.setString("password", "");
    prefs.setString("UserAddress", "");
    prefs.setString("kycid", "");
    prefs.setString("kycdocument", "");
    prefs.setString("email", "");
    prefs.setString("upiId", "");
  }
}
