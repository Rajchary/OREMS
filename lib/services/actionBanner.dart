import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/constants.dart';

class ActionBanner extends StatelessWidget {
  final String title, content, buttonText;
  final Function press;
  const ActionBanner({
    Key key,
    @required this.title,
    @required this.content,
    @required this.buttonText,
    @required this.press,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.white,
      decoration: BoxDecoration(
        border: Border.all(color: greenThick),
        borderRadius: BorderRadius.circular(25),
        color: Colors.black,
      ),
      padding: EdgeInsets.all(10),
      child: SingleChildScrollView(
        //scrollDirection: Axis.horizontal,
        child: Column(
          children: <Widget>[
            Text(
              title,
              style: GoogleFonts.rajdhani(
                textStyle: Theme.of(context).textTheme.headline4,
                color: greenThick,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            Text(
              content,
              style: GoogleFonts.rajdhani(
                textStyle: Theme.of(context).textTheme.headline4,
                color: Colors.white,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 25,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: greenThick,
              ),
              onPressed: press,
              child: Text(
                buttonText,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: 19,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
