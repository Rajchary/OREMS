import 'package:flutter/material.dart';

import 'package:online_real_estate_management_system/components/bottomNavigation.dart';

class LandlordHomeScreen extends StatefulWidget {
  static const String idScreen = "landlordHomeScreen";
  @override
  _LandlordHomeScreenState createState() => _LandlordHomeScreenState();
}

class _LandlordHomeScreenState extends State<LandlordHomeScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.maybeOf(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.blue[400],
              Colors.blue[900],
            ],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
