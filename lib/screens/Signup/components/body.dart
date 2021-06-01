import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/already_have_an_account.dart';
import 'package:online_real_estate_management_system/components/roundedButton.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/components/roundedPasswordField.dart';
import 'package:online_real_estate_management_system/screens/Signup/additionalInfo.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/background.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/orDevider.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/socialMediaContainer.dart';
import 'package:online_real_estate_management_system/screens/login/login_screen.dart';
import 'package:online_real_estate_management_system/screens/userProperties.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
                  if (!validateEmpty(value, context)) {
                    user.setName = value;
                  }
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
            RoundedButton(
                text: "Proceed",
                press: () {
                  if (finalValidation() == true) {
                    Navigator.pushNamed(context, AddInfo.idScreen);
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

  bool finalValidation() {
    if (password.text != cpassword.text) {
      Fluttertoast.showToast(msg: "Both the passwords should match");
      return false;
    } else if (name.text.isEmpty || email.text.isEmpty || phone.text.isEmpty)
      return false;
    else {
      _saveUserData();
      return true;
    }
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    user.setName = name.text;
    prefs.setString("name", name.text.trim());
    user.setEmail = email.text;
    prefs.setString("email", email.text.trim());
    user.setMobile = phone.text;
    prefs.setString("phone", phone.text.trim());
    user.setPassword = password.text;
    prefs.setString("password", password.text.trim());
    user.setCpassword = cpassword.text;
    prefs.setString(
        'profileUrl', "https://www.woolha.com/media/2020/03/eevee.png");
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
