import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/already_have_an_account.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/components/roundedButton.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/components/roundedPasswordField.dart';
import 'package:online_real_estate_management_system/components/textFieldContainer.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/main.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Signup/signup_screen.dart';
import 'package:online_real_estate_management_system/screens/login/components/background.dart';
import 'package:online_real_estate_management_system/screens/userProperties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Body extends StatelessWidget {
////Intialzing TextEditing Controllers
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  Person person = new Person();
  Body({
    Key key,
    //@required this.size,
  }) : super(key: key);

  //final Size size;
  var fill = true;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Signin",
              style: GoogleFonts.lobster(
                textStyle: Theme.of(context).textTheme.headline4,
                color: greenThick,
                fontSize: 35,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                letterSpacing: .9,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login_screen.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
                hintText: "Username (Email)",
                textcontroller: email,
                textInputType: TextInputType.emailAddress,
                onChanged: (value) {
                  if (value.isEmpty) {
                    showToast("Fields shouldn't be left empty!! ", context);
                  }
                  // if (value == "n") showAlertDialog(context);
                },
                icon: Icons.person),
            // SizedBox(
            //   height: size.height * 0.015,
            // ),
            // // Padding(
            //   padding: const EdgeInsets.symmetric(horizontal: 37),
            //   child: TextFormField(
            //     style: TextStyle(
            //       color: greenThick,
            //     ),
            //     decoration: InputDecoration(
            //         labelText: "Username",
            //         hintText: "Username",
            //         hintStyle: TextStyle(color: Colors.grey),
            //         fillColor: Colors.white,
            //         filled: false,
            //         prefixIcon: Padding(
            //           padding:
            //               EdgeInsets.symmetric(horizontal: size.width * 0.05),
            //           child: Icon(
            //             Icons.person,
            //             color: greenThick,
            //           ),
            //         ),
            //         focusedBorder: OutlineInputBorder(
            //           borderSide:
            //               const BorderSide(color: greenThick, width: 3.0),
            //           borderRadius: BorderRadius.circular(25),
            //         ),
            //         enabledBorder: OutlineInputBorder(
            //           borderSide: BorderSide(color: Colors.grey, width: 3.0),
            //           borderRadius: BorderRadius.circular(20),
            //         )),
            //     validator: (value) {
            //       if (value.isEmpty) {
            //         return "required";
            //       } else
            //         return null;
            //     },
            //   ),
            // ),
            // //textcontroller : _username,
            // SizedBox(
            //   height: size.height * 0.015,
            // ),
            RoundedPasswordField(
              hintText: "Password",
              passwordController: password,
              onChanged: (value) {
                if (value.isEmpty)
                  showToast("Fields Shouldn't be left empty !!", context);
              },
            ),
            RoundedButton(
                text: "Signin",
                press: () {
                  if (email.text.isEmpty || password.text.isEmpty) {
                    showToast("Fields shouldn't be left empty !!", context);
                  } else if (!email.text.contains("@"))
                    showToast("Invalid Email", context);
                  else if (password.text.length < 6)
                    showToast("Invalid password", context);
                  else {
                    //Todo Implementation for validation
                    loginAndAuthenticate(context);
                  }
                },
                white: Colors.white),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccount(
              press: () {
                //showAlertDialog(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, SignupScreen.idScreen, (route) => false);
                //}
              },
            )
          ],
        ),
      ),
    );
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

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> loginAndAuthenticate(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Validating..",
          );
        });
    final User firebaseUser = (await _firebaseAuth
            .signInWithEmailAndPassword(
                email: email.text, password: password.text)
            .catchError((errormsg) {
      Navigator.pop(context);
      showToast("" + errormsg.toString(), context);
    }))
        .user;
    if (firebaseUser != null) {
      //User authenticated successfully
      if (!kIsWeb) {
        userRef.child(firebaseUser.uid).once().then((DataSnapshot snap) {
          if (snap.value != null) {
            var values = snap.value;
            userDatavalues['name'] = values['name'];
            userDatavalues['phone'] = values['phone'];
            userDatavalues['occupation'] = values['occupation'];
          //  _saveUserData(context);
          //  showToast("Hola!! You are in..", context);
          } else {
            Navigator.pop(context);
            showToast("Invalid Credentials !!", context);
          }
        });
      } //End of platfomr check condition
      final firestoreInstance = FirebaseFirestore.instance;
      firestoreInstance
          .collection("users")
          .doc(firebaseUser.uid)
          .get()
          .then((value) {
        userDatavalues['name'] = value['name'];
        userDatavalues['phone'] = value['phone'];
        userDatavalues['occupation'] = value['occupation'];
        _saveUserData(context);
        showToast("Hola!! You are in..", context);
      });
    } //End if
    else {
      Navigator.pop(context);
      showToast(
          "Ouch! User does not exist please recheck or do register", context);
    }
  }
}

_saveUserData(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final nameKey = 'name';
  final occKey = 'occupation';
  final phoneKey = 'phone';
  prefs.setString(nameKey, userDatavalues['name']);
  prefs.setString(occKey, userDatavalues['occupation']);
  prefs.setString(phoneKey, userDatavalues['phone']);
  prefs.setString(
      'profileUrl', "https://www.woolha.com/media/2020/03/eevee.png");
  //String profileUrl = prefs.getString('profileUrl');
  //if(url==)

  firebase_storage.Reference propertyDatabase;
  try {
    propertyDatabase = firebase_storage.FirebaseStorage.instance.ref().child(
        'images/profiles/${FirebaseAuth.instance.currentUser.uid.toString()}');
    await propertyDatabase.getDownloadURL().then((value) {
      prefs.setString('profileUrl', value.toString());
    });
    //Fluttertoast.showToast(msg: "value added");
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.idScreen, (route) => false);
  } catch (e) {
    //Fluttertoast.showToast(msg: "error raised");
    prefs.setString(
        'profileUrl', "https://www.woolha.com/media/2020/03/eevee.png");
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.idScreen, (route) => false);
  }
}

showAlertDialog(BuildContext context) {
  return AlertDialog(
    title: Text('AlertDialog Title'),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text('This is a demo alert dialog.'),
          Text('Would you like to approve of this message?'),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        child: Text('Approve'),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}
