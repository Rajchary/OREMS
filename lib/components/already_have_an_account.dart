import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class AlreadyHaveAnAccount extends StatelessWidget {
  final bool login;
  final Function press;
  const AlreadyHaveAnAccount({
    Key key,
    this.login = true,
    this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          login ? "Don't have an account ? " : "Already have an account ? ",
          style: GoogleFonts.rajdhani(
            textStyle: Theme.of(context).textTheme.headline4,
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.normal,
            letterSpacing: .2,
          ),
        ),
        GestureDetector(
          onTap: press,
          child: Text(
            login ? "Sign Up" : "Sign In",
            style: GoogleFonts.rajdhani(
              textStyle: Theme.of(context).textTheme.headline4,
              color: greenThick,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: .2,
            ),
          ),
        ),
      ],
    );
  }
}
