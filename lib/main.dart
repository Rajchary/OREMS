import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Home/models/profileView.dart';
import 'package:online_real_estate_management_system/screens/Signup/additionalInfo.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/verifyUser.dart';
import 'package:online_real_estate_management_system/screens/Signup/signup_screen.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/navigateProperty.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/property.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/searchProperty.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addImages.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addProperty.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addfromMap.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/listProperties.dart';
import 'package:online_real_estate_management_system/screens/landlord/landlordHome.dart';
import 'package:online_real_estate_management_system/screens/landlord/services/addDataFromMap.dart';
import 'package:online_real_estate_management_system/screens/login/login_screen.dart';
import 'package:online_real_estate_management_system/screens/welcome/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("Users");

var userDatavalues = {'name': '', 'phone': '', 'occupatio': ''};

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Online Real Estate Management System',
      theme:
          ThemeData(primaryColor: greenThick, scaffoldBackgroundColor: blackC),
      initialRoute: FirebaseAuth.instance.currentUser == null
          ? WelcomeScreen.idScreen
          : HomeScreen.idScreen,
      routes: {
        LoginScreen.idScreen: (context) => LoginScreen(),
        SignupScreen.idScreen: (context) => SignupScreen(),
        HomeScreen.idScreen: (context) => HomeScreen(),
        WelcomeScreen.idScreen: (context) => WelcomeScreen(),
        LandlordHomeScreen.idScreen: (context) => LandlordHomeScreen(),
        AddMyProperty.idScreen: (context) => AddMyProperty(),
        AddImages.idScreen: (context) => AddImages(),
        VerifyUser.idScreen: (context) => VerifyUser(),
        AddMap.idScreen: (context) => AddMap(),
        ProfileView.idScreen: (context) => ProfileView(),
        SearchProperty.idScreen: (context) => SearchProperty(),
        AddInfo.idScreen: (context) => AddInfo(),
        AddDataFromMap.idScreen: (context) => AddDataFromMap(),
        PropertyView.idScreen: (context) => PropertyView(),
        NavigateToProperty.idScreen: (context) => NavigateToProperty(),
        ListProperty.idScreen: (context) => ListProperty(),
      },
    );
  }
}
