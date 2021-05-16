// import 'dart:html';

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:online_real_estate_management_system/components/already_have_an_account.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/components/roundedButton.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/components/roundedPasswordField.dart';
import 'package:online_real_estate_management_system/main.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/background.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/orDevider.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/socialMediaContainer.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/verifyUser.dart';
import 'package:online_real_estate_management_system/screens/login/login_screen.dart';
import 'package:online_real_estate_management_system/screens/userProperties.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  final Widget child;
  var currentOccupation = "You are ";
  Person user = new Person();
  bool validateEmpty(String value, BuildContext context,
      [bool isPass = false]) {
    if (!isPass) {
      if (value.isEmpty) {
        showToast("Feilds Shouldn't be left empty!! ", context);
      } else {
        return false;
      }
    } else {
      if (value.isNotEmpty && user.getPassword == value)
        return false;
      else {
        if (user.getPassword.length == value.length) {
          showToast("Both the passwords should match !! ", context);
        }
      }
    }
    return true;
  }

  //TextEditing Controllers

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController cpassword = TextEditingController();
  TextEditingController occupation = TextEditingController();

  //TextInoutType Keyboard

  TextInputType text = TextInputType.text;
  TextInputType emailAddress = TextInputType.emailAddress;
  TextInputType phonetype = TextInputType.phone;

  Body({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<String> occupation = [
    //   "You are",
    //   "Tenant",
    //   "Land lord",
    //   "Organization representative"
    // ];

    Size size = MediaQuery.maybeOf(context).size;

    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: size.height * 0.15),
            Text(
              "OREMS !",
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
            RoundedInputField(
                hintText: "Your good name",
                textInputType: text,
                textcontroller: name,
                onChanged: (value) {
                  if (!validateEmpty(value, context)) user.setName = value;
                },
                icon: Icons.person),
            RoundedInputField(
                hintText: "Username(or)e-mail",
                textInputType: emailAddress,
                textcontroller: email,
                onChanged: (value) {
                  if (!validateEmpty(value, context)) user.setEmail = value;
                },
                icon: Icons.email),
            RoundedInputField(
                hintText: "Your mobile no",
                textInputType: phonetype,
                textcontroller: phone,
                onChanged: (value) {
                  if (!validateEmpty(value, context)) user.setMobile = value;
                },
                icon: Icons.phone),
            RoundedPasswordField(
              hintText: "Password",
              passwordController: password,
              onChanged: (value) {
                if (!validateEmpty(value, context)) user.setPassword = value;
              },
            ),
            RoundedPasswordField(
              hintText: "Confirm Password",
              passwordController: cpassword,
              onChanged: (value) {
                if (!validateEmpty(value, context, true)) {
                  user.setCpassword = value;
                }
              },
            ),
            Text(
              "What describes you best",
              style: GoogleFonts.rajdhani(
                textStyle: Theme.of(context).textTheme.headline4,
                color: greenThick,
                fontSize: 19,
                fontWeight: FontWeight.bold,
                //fontStyle: FontStyle.normal,
                //letterSpacing: .2,
              ),
            ),
            // DropDown(),
            // Center(
            //   child: DropdownButton<String>(

            //     underline: Container(
            //       height: 2.5,
            //       color: greenThick,
            //     ),
            //     icon: const Icon(Icons.arrow_downward,color: greenThick,),
            //     iconSize: 24,
            //     elevation: 16,
            //     hint: Text("What describes you best"),
            //     onChanged: (String newOccupation) {
            //       setState(() {
            //         currentOccupation = newOccupation;
            //       });
            //       value:
            //       currentOccupation;
            //     },
            //     items: occupation.map((String ddStringItem) {
            //       return DropdownMenuItem<String>(
            //         value: ddStringItem,
            //         child: Text(ddStringItem),
            //       );
            //     }).toList(),
            //   ),
            // ),
            RoundedInputField(
                hintText:
                    "You are ? [ Landlord, Tenant, Organization representative ]",
                textcontroller: occupation,
                onChanged: (value) {
                  if (!validateEmpty(value, context))
                    user.setOccupation = value;
                },
                icon: Icons.message),
            // Row(
            //   children: <Widget>[
            //     Text(
            //       "Upload your image",
            //       style: GoogleFonts.rajdhani(
            //         textStyle: Theme.of(context).textTheme.headline4,
            //         color: greenThick,
            //         fontSize: 19,
            //         fontWeight: FontWeight.bold,
            //         //fontStyle: FontStyle.normal,
            //         //letterSpacing: .2,
            //       ),
            //     ),
            //     SizedBox(
            //       width: 25,
            //     ),
            //     IconButton(
            //       onPressed: () async {
            //         ImagePicker picker;
            //         final pickedFile = await ImagePicker()
            //             .getImage(source: ImageSource.gallery);
            //         File image = File(pickedFile.path);

            //       },
            //       icon: Icon(
            //         Icons.add_a_photo_rounded,
            //         color: greenThick,
            //         size: 35,
            //       ),
            //     ),
            //   ],
            // ),

            RoundedButton(
                text: "Signup",
                press: () {
                  if (finalValidation()) {
                    registerNewUser(context);
                  } else {
                    showToast(
                        "None of the fields should left empty !!", context);
                  }
                },
                white: Colors.white),
            SizedBox(height: size.height * 0.05),
            AlreadyHaveAnAccount(
                login: false,
                press: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, LoginScreen.idScreen, (route) => false);
                }),
            SizedBox(height: size.height * 0.02),
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
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  Future<void> registerNewUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Registering..",
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: email.text, password: password.text)
            .catchError((errormsg) {
      Navigator.pop(context);
      showToast("Error " + errormsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      //User created successfully

      Map userDataMap = {
        "name": user.getName.trim(),
        "email": user.getEmail.trim(),
        "phone": user.getMobile.trim(),
        "password": user.getPassword.trim(),
        "occupation": user.getOccupation.trim(),
      };
      userRef.child(firebaseUser.uid).set(userDataMap);
      showToast("Validate your emil id !!..", context);
      Navigator.pushNamedAndRemoveUntil(
          context, VerifyUser.idScreen, (route) => false);
    } else {
      Navigator.pop(context);
      showToast("Oops! Something went wrong..", context);
    }
  }

  bool finalValidation() {
    if (password.text != cpassword.text) {
      Fluttertoast.showToast(msg: "Both the passwords should match");
      return false;
    } else if (name.text.isEmpty ||
        email.text.isEmpty ||
        phone.text.isEmpty ||
        occupation.text.isEmpty)
      return false;
    else {
      user.setName = name.text;
      user.setEmail = email.text;
      user.setMobile = phone.text;
      user.setPassword = password.text;
      user.setCpassword = cpassword.text;
      user.setOccupation = occupation.text;
      return true;
    }
  }

  void showToast(String message, BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: 1, milliseconds: 500),
      action:
          SnackBarAction(label: 'Ok', onPressed: scaffold.hideCurrentSnackBar),
    ));
  }
}
