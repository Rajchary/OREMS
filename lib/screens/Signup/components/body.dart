// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/already_have_an_account.dart';
import 'package:online_real_estate_management_system/components/roundedButton.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/components/roundedPasswordField.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/background.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/orDevider.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/socialMediaContainer.dart';
import 'package:online_real_estate_management_system/screens/login/login_screen.dart';

import '../../../constants.dart';

class Body extends StatelessWidget {
  final Widget child;
  var currentOccupation = "You are ";
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
                onChanged: (value) {},
                icon: Icons.person),
            RoundedInputField(
                hintText: "Username(or)e-mail",
                onChanged: (value) {},
                icon: Icons.email),
            RoundedPasswordField(
              hintText: "Password",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              hintText: "Confirm Password",
              onChanged: (value) {},
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
                onChanged: (value) {},
                icon: Icons.message),
            RoundedButton(text: "Singup", press: () {}, white: Colors.white),
            SizedBox(height: size.height * 0.05),
            AlreadyHaveAnAccount(
                login: false,
                press: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) {
                      return LoginScreen();
                    }),
                  );
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
}
