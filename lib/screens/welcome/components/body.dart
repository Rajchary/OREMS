import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:online_real_estate_management_system/components/roundedButton.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Signup/signup_screen.dart';
import 'package:online_real_estate_management_system/screens/login/login_screen.dart';
import 'package:online_real_estate_management_system/screens/welcome/components/background.dart';
import 'package:google_fonts/google_fonts.dart';

class Body extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    //Returns total height and width of the screen
    var white = Colors.white;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to OREMS",
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
              "assets/icons/front_home.svg",
              width: size.width * 0.6,
            ),
            SizedBox(height: size.height * 0.03),
            RoundedButton(
              white: white,
              text: "Signin",
              press: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, LoginScreen.idScreen, (route) => false);
              },
            ),
            RoundedButton(
                white: white,
                text: "Sign up free",
                press: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, SignupScreen.idScreen, (route) => false);
                }),
          ],
        ),
      ),
    );
  }
}
