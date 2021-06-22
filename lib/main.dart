import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:online_real_estate_management_system/components/bioMetricAuth.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';
import 'package:online_real_estate_management_system/screens/Home/models/ClientProfileCheck.dart';
import 'package:online_real_estate_management_system/screens/Home/models/profileView.dart';
import 'package:online_real_estate_management_system/screens/Signup/additionalInfo.dart';
import 'package:online_real_estate_management_system/screens/Signup/components/verifyUser.dart';
import 'package:online_real_estate_management_system/screens/Signup/signup_screen.dart';
import 'package:online_real_estate_management_system/screens/Tenant/TenantHS.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/favourites.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/navigateProperty.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/property.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/searchProperty.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addImages.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addProperty.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/addfromMap.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/listProperties.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/managableProperties.dart';
import 'package:online_real_estate_management_system/screens/landlord/landlordHome.dart';
import 'package:online_real_estate_management_system/screens/landlord/services/addDataFromMap.dart';
import 'package:online_real_estate_management_system/screens/login/login_screen.dart';
import 'package:online_real_estate_management_system/screens/welcome/welcome_screen.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:rxdart/rxdart.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

AndroidNotificationChannel channel;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
BehaviorSubject<String> selectedNotificationSubject;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  if (!kIsWeb) {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
      playSound: true,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    //Remove from here if problem occurs
    selectedNotificationSubject = BehaviorSubject<String>();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      print("Notification payload $payload");
      selectedNotificationSubject.add(payload);
      navService.pushNamed(ListProperty.idScreen);
    });
    //To here
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }
  runApp(MyApp());
}

DatabaseReference userRef =
    FirebaseDatabase.instance.reference().child("Users");

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
          : BioAuth.idScreen,
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
        TenantScreen.idScreen: (context) => TenantScreen(),
        ManageProperty.idScreen: (context) => ManageProperty(),
        BioAuth.idScreen: (context) => BioAuth(),
        Favourites.idScreen: (context) => Favourites(),
        ProfileCheck.idScreen: (context) => ProfileCheck(),
      },
    );
  }
}
