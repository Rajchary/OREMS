import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class OrDevider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: size.height * 0.02),
      width: size.width * 0.8,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Divider(
              color: greenThick,
              height: size.height * 0.02,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              "Or",
              style: GoogleFonts.rajdhani(
                textStyle: Theme.of(context).textTheme.headline4,
                color: Colors.deepOrange,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.normal,
                letterSpacing: .2,
              ),
            ),
          ),
          Expanded(
            child: Divider(
              color: greenThick,
              height: size.height * 0.02,
            ),
          ),
        ],
      ),
    );
  }
}
