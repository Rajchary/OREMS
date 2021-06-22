import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/main.dart';
import 'package:online_real_estate_management_system/screens/Home/components/body.dart';
import 'package:online_real_estate_management_system/screens/Home/models/ClientProfileCheck.dart';
import 'package:online_real_estate_management_system/screens/Home/models/profileView.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/favourites.dart';
import 'package:online_real_estate_management_system/screens/landlord/components/managableProperties.dart';
import 'package:online_real_estate_management_system/screens/welcome/welcome_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  static const String idScreen = "home";
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  //Stable from here
  firebase_storage.Reference propertyDatabase;
  String name = " ",
      phone = "",
      occupatio = "",
      imageUrl = "https://www.woolha.com/media/2020/03/eevee.png",
      profileName = " ";
  File imageFile;
  bool visited = false;
  DatabaseReference userReference =
      FirebaseDatabase.instance.reference().child("Users");
  SharedPreferences pref;
  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> getInitialMessage() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      print("Recieved new notification  $payload");
      selectNotification(payload);
    });

    RemoteMessage initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage?.data["screen"] == "Engage") {
      print("message data is ${initialMessage?.data["screen"]}");
      final action = await AlertDialogs.confirmDialog(
          context, "New message", "You have recieved a new message",
          yes: "Show message", cancel: "");
      if (action == DialogAction.Yes) {
        Navigator.pushNamed(context, ManageProperty.idScreen);
      }
    }
  }

  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }
    if (!visited) {
      await Navigator.pushNamed(context, ManageProperty.idScreen);
      setState(() {
        visited = true;
      });
    }
  }

  void _configureSelectNotification() {
    selectedNotificationSubject.stream.listen((String payload) async {
      print(payload);
      if (!visited) {
        await Navigator.pushNamed(context, ProfileCheck.idScreen,
            arguments: payload);
        setState(() {
          visited = true;
        });
      }
    });
  }

  @override
  void dispose() {
    selectedNotificationSubject.close();
    super.dispose();
  }

  @override
  void initState() {
    _saveDeviceToken();
    _getUserData();
    getUserLocation();
    super.initState();
    getInitialMessage();
    _configureSelectNotification();
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      'This channel is used for important notifications.', // description
      importance: Importance.max,
      playSound: true,
      enableLights: true,
      showBadge: true,
      ledColor: Colors.red,
    );

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Message recieved with payload ${message.data["postData"]}");
      //   print("Message ${message.data["postData"].runtimeType}");
      setState(() {
        visited = false;
        print(visited);
      });
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: "@mipmap/ic_launcher",
              playSound: true,
              // other properties...
            ),
          ),
          payload: "${message.data["postData"]}",
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      Navigator.pushNamed(context, ManageProperty.idScreen,
          arguments: MessageArguments(message, true));
    });
  }

  Future getUserLocation() async {
    Location location = new Location();
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }
    final result = await location.getLocation();
    return result;
  }

  _getUserData() async {
    pref = await SharedPreferences.getInstance();
    setState(() {
      name = pref.getString('name');
      occupatio = pref.getString('occupation');
      phone = pref.getString('phone');
      imageUrl = pref.getString('profileUrl');
      // Fluttertoast.showToast(msg: "Initiated");
    });
  }

  _saveDeviceToken() async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    // FirebaseUser user = await _auth.currentUser();

    // Get the token for this device
    String fcmToken = await _fcm.getToken();

    // Save it to Firestore
    if (fcmToken != null) {
      var tokens = _db
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser.uid)
          .collection('tokens')
          .doc(fcmToken);

      await tokens.set({
        'token': fcmToken,
        'createdAt': FieldValue.serverTimestamp(), // optional
        'platform': Platform.operatingSystem // optional
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Home page"),
      ),
      drawer: Container(
        width: 260.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[400],
          ),
        ),
        child: Drawer(
          child: ListView(
            children: [
              Container(
                color: Colors.black,
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () async {
                          final action = await AlertDialogs.confirmDialog(
                              context,
                              "Upload",
                              "DO you wanna update new profile image");
                          if (action == DialogAction.Yes) {
                            _chooseImage();
                          }
                        },
                        child: CircleAvatar(
                          radius: 50.0,
                          backgroundImage: NetworkImage(imageUrl),
                          onBackgroundImageError: (_, __) {
                            setState(() {
                              profileName = name;
                            });
                          },
                          child: ClipRRect(
                            child: Text(
                              profileName[0].toString(),
                              style: TextStyle(
                                color: Colors.black, //greenThick,
                                fontSize: 40,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 16.0,
                      ),
                      Column(
                        children: [
                          SizedBox(height: 50.0),
                          Flexible(
                            child: Text(
                              name,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Brand-Bold",
                                  color: greenThick),
                            ),
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 3.0,
                color: greenThick,
              ),
              SizedBox(height: 6.0),
              ListTile(
                leading: Icon(Icons.person),
                title: Text(
                  "My Profile",
                  style: TextStyle(color: greenThick),
                ),
                onTap: () {
                  Fluttertoast.showToast(msg: "Profile view");
                  Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (BuildContext context) => ProfileView()),
                  );
                }, //viewProfile(),
              ),
              ListTile(
                leading: Icon(Icons.favorite),
                title: Text(
                  "Wishlist",
                  style: TextStyle(color: greenThick),
                ),
                onTap: () async {
                  Navigator.pushNamed(context, Favourites.idScreen);
                },
              ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text(
                  "Signout",
                  style: TextStyle(color: greenThick),
                ),
                onTap: () async {
                  final action = await AlertDialogs.confirmDialog(
                      context, "Signout ?", "Are you sure you wanna do it");
                  if (action == DialogAction.Yes) {
                    signoutUser();
                  }
                },
              ),
            ],
          ),
        ),
      ),
      body: Body(),
      bottomNavigationBar: BottomNavigation(),
    );
  }

  viewProfile() {
    //print(person.getName);
    Fluttertoast.showToast(msg: "Profile view");
  }

  _chooseImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedFile.path);
    });
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return ProgressDialog(
            message: "Uploading..",
          );
        });
    uploadProfilePhoto(context).whenComplete(() => Navigator.of(context).pop());
  }

  Future uploadProfilePhoto(BuildContext context) async {
    String fileName = FirebaseAuth.instance.currentUser.uid;
    propertyDatabase = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/profiles/$fileName');

    await propertyDatabase.putFile(imageFile).whenComplete(() async {
      await propertyDatabase.getDownloadURL().then((value) async {
        await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser.uid)
            .set({
          "ProfilePicture": value,
        });
        pref.setString('profileUrl', value.toString());
        Fluttertoast.showToast(msg: "Profile updated");
        setState(() {
          imageUrl = pref.getString("profileUrl");
        });
      });
    });
    setState(() {
      profileName = " ";
    });
  }

  Future<void> signoutUser() async {
    FirebaseAuth.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
        context, WelcomeScreen.idScreen, (route) => false);
    Fluttertoast.showToast(msg: "Logged out Succeffully");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', "");
    prefs.setString('phone', "");
    prefs.setString('occupation', "");
  }
}

class MessageArguments {
  MessageArguments(RemoteMessage message, bool bool);
}
