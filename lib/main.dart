import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/welcome/welcome_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Real Estate Management System',
      theme:
          ThemeData(primaryColor: greenThick, scaffoldBackgroundColor: blackC),
      home: WelcomeScreen(),
    );
  }
}
