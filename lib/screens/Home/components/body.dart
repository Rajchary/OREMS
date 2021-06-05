import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/searchProperty.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/listProperties.dart';
import 'package:online_real_estate_management_system/services/actionBanner.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      //scrollDirection: Axis.horizontal,
      //padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Container(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Quick Actions !!",
              style: GoogleFonts.rajdhani(
                textStyle: Theme.of(context).textTheme.headline4,
                color: greenThick,
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 30,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: greenThick),
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.black,
                ),
                padding: EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      width: 25,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, SearchProperty.idScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: greenThick,
                      ),
                      icon: Icon(Icons.search),
                      label: Text(
                        "Search Property",
                        style: GoogleFonts.rajdhani(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, ListProperty.idScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        primary: greenThick,
                      ),
                      icon: Icon(Icons.home),
                      label: Text(
                        "Property",
                        style: GoogleFonts.rajdhani(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.white,
                          fontSize: 19,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        primary: greenThick,
                      ),
                      icon: Icon(Icons.payment),
                      label: Text(
                        "Pay rent",
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
            SizedBox(
              height: 25,
            ),
            ActionBanner(
              title: "Sell Property!",
              content:
                  "Now selling your property was made easy. you can easily sell your property by clicking below",
              buttonText: "Sell My Property",
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => ListProperty()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
