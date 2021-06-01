import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Signup/signup_screen.dart';
import 'package:online_real_estate_management_system/screens/userProperties.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyUser extends StatefulWidget {
  static const String idScreen = "verifyUser";
  @override
  _VerifyUserState createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  final auth = FirebaseAuth.instance;
  User user;
  Timer timer;
  String email;
  @override
  void initState() {
    user = auth.currentUser;
    user.sendEmailVerification();

    email = user.email;
    timer = Timer.periodic(Duration(seconds: 2), (timer) {
      checkEmailVerified();
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(25),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'An email has been sent to ${user.email} please verify....',
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  //fontStyle: FontStyle.normal,
                  //letterSpacing: .2,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final action = await AlertDialogs.confirmDialog(
                      context, "Proceed ?", "Are you sure");
                  if (action == DialogAction.Yes) {
                    Navigator.pushNamedAndRemoveUntil(
                        context, SignupScreen.idScreen, (route) => false);
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                ),
                icon: Icon(Icons.arrow_left),
                label: Text(
                  "Cancel",
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.white,
                    fontSize: 19,
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

  Future<void> checkEmailVerified() async {
    user = auth.currentUser;

    await user.reload();
    if (user.emailVerified) {
      timer.cancel();
      registerUser();
    }
  }

  Future<void> registerUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Fluttertoast.showToast(msg: " ${prefs.getString("name")} signing in..");
    print(" ${prefs.getString("name")} signing in..");
    Navigator.pushNamedAndRemoveUntil(
        context, HomeScreen.idScreen, (route) => false);
  }
}
