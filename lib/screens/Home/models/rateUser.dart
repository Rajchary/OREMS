import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/Services/postRating.dart';

class RateUser extends StatefulWidget {
  static const String idScreen = "rateUser";
  const RateUser({Key key}) : super(key: key);

  @override
  _RateUserState createState() => _RateUserState();
}

class _RateUserState extends State<RateUser> {
  int userCount = 0;
  Size size;
  List<Map<String, dynamic>> usersData = [];
  Future<void> getUsers() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((value) async {
      if (value.data()["Tenants"] != null) {
        print(value.data()["Tenants"]);
        await addUsersData(value.data()["Tenants"], "Tenant");
      }
      if (value.data()["Landlords"] != null) {
        print(value.data()["Landlords"]);
        await addUsersData(value.data()["Landlords"], "Landlord");
      }
    });
  }

  Future<void> addUsersData(Map<String, dynamic> users, String type) async {
    Map<String, dynamic> userData = {};
    if (users != null && users.isNotEmpty) {
      users.forEach((key, value) async {
        userData = await getUserData(key, value, type);
        //print(userData);
        setState(() {
          if (userData.isNotEmpty) {
            ++userCount;
            usersData.add(userData);
            //print(usersData);
          } //getUserData(key, value, type) as Map<String, dynamic>);
        });
      });
    }
    //print(usersData);
  }

  Future<Map<String, dynamic>> getUserData(
      String key, dynamic pName, String type) async {
    Map<String, dynamic> userData = {};
    await FirebaseFirestore.instance
        .collection("users")
        .doc(key)
        .get()
        .then((value) {
      userData = value.data();
      userData["PropertyName"] = pName;
      userData["Type"] = type;
      userData["uid"] = key;
      print(userData);
    });
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    if (usersData.isEmpty) {
      getUsers();
    }
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Color(0xFF1B222E),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height * .055,
              ),
              Row(
                children: [
                  SizedBox(
                    width: size.width * .035,
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.arrow_back_ios_new,
                        size: size.width * .075,
                        color: greenThick,
                      )),
                ],
              ),
              Text(
                "Rating !",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: size.width * .065,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (userCount != 0)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  height: size.height,
                  child: GridView.builder(
                      itemCount: userCount,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          childAspectRatio: size.width / (size.height / 7)),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.all(5),
                          child: GestureDetector(
                            onTap: () async {
                              Navigator.pushNamed(context, PostRating.idScreen,
                                  arguments: usersData[index]);
                            },
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        CircleAvatar(
                                          radius: 30,
                                          backgroundImage: NetworkImage(
                                              usersData[index]
                                                  ["ProfilePicture"]),
                                        ),
                                        Text(
                                          " ${usersData[index]["name"]}",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            color: Colors.blue,
                                            fontSize: size.width * .055,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(
                                          width: usersData[index]["name"]
                                                      .toString()
                                                      .length <=
                                                  4
                                              ? size.width * .45
                                              : size.width * .3,
                                        ),
                                        Text(
                                          "${usersData[index]["Type"]}",
                                          style: GoogleFonts.rajdhani(
                                            textStyle: Theme.of(context)
                                                .textTheme
                                                .headline4,
                                            color: usersData[index]["Type"] ==
                                                    "Tenant"
                                                ? Colors.red
                                                : greenThick,
                                            fontSize: size.width * .055,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          textAlign: TextAlign.right,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    " ${usersData[index]["PropertyName"]}",
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.white,
                                      fontSize: size.width * .048,
                                      //  fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
