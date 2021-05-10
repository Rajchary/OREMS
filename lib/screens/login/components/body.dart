import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/already_have_an_account.dart';
import 'package:online_real_estate_management_system/components/roundedButton.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/components/roundedPasswordField.dart';
import 'package:online_real_estate_management_system/components/textFieldContainer.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Signup/signup_screen.dart';
import 'package:online_real_estate_management_system/screens/login/components/background.dart';

class Body extends StatelessWidget {
  const Body({
    Key key,
    //@required this.size,
  }) : super(key: key);

  //final Size size;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Background(
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
            hintText: "Username",
            onChanged: (value) {},
            icon:Icons.person
          ),
          RoundedPasswordField(
            hintText: "Password",
            onChanged: (value) {},
          ),
          RoundedButton(text: "Signin", press: () {}, white: Colors.white),
          SizedBox(height: size.height * 0.03),
          AlreadyHaveAnAccount(
            press: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return SignupScreen();
                  },
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
