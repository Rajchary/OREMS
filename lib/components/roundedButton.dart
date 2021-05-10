import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/constants.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final Function press;
  final Color color, textColor;
  const RoundedButton({
    Key key,
    //@required this.size,
    @required this.white,
    this.text,
    this.press,
    this.color = greenThick,
    this.textColor,
  }) : super(key: key);

  //final Size size;
  final Color white;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      width: size.width * 0.8,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(29),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40),
            backgroundColor: greenThick,
          ),
          onPressed: press,
          child: Text(
            text,
            style: GoogleFonts.rajdhani(
              textStyle: Theme.of(context).textTheme.headline4,
              color: white,
              fontSize: 25,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.normal,
              letterSpacing: .2,
            ),
          ),
        ),
      ),
    );
  }
}
