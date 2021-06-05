import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/bottomNavigation.dart';

class ListProperty extends StatefulWidget {
  static const String idScreen = "ListProperty";
  @override
  _ListPropertyState createState() => _ListPropertyState();
}

class _ListPropertyState extends State<ListProperty>
    with WidgetsBindingObserver {
  int properties = 0;
  List<Map<String, dynamic>> _propertyData = [];
  @override
  void initState() {
    FirebaseFirestore.instance
        .collection('Property')
        .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
        .collection("PropertyDetails")
        .get()
        .then((QuerySnapshot snap) {
      setState(() {
        properties = snap.docs.length;
        snap.docs.forEach((record) {
          _propertyData.add(record.data());
        });
      });
      FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Sale')
          .where("uid",
              isEqualTo: "${FirebaseAuth.instance.currentUser.uid.toString()}")
          .get()
          .then((QuerySnapshot snap) {
        setState(() {
          properties += snap.docs.length;
          snap.docs.forEach((element) {
            _propertyData.add(element.data());
          });
        });
      });
      FirebaseFirestore.instance
          .collection('Property')
          .doc('General')
          .collection('Lease')
          .where("uid",
              isEqualTo: "${FirebaseAuth.instance.currentUser.uid.toString()}")
          .get()
          .then((QuerySnapshot snap) {
        setState(() {
          properties += snap.docs.length;
          snap.docs.forEach((element) {
            //  print(element.id);
            _propertyData.add(element.data());
          });
        });
      });
      // for (int i = 0; i < _propertyData.length; i++) {
      //   print("From for loop ${_propertyData[i]["name"]}");
      // }
    });
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  void setPropertyCount() async {
    await FirebaseFirestore.instance
        .collection('Property')
        .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
        .collection("PropertyDetails")
        .get()
        .then((QuerySnapshot snap) {
      setState(() {
        properties = snap.docs.length;
      });
    });
    //Fluttertoast.showToast(msg: "Called");
    print("Property Count is $properties");
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setPropertyCount();
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.indigo,
              Colors.teal,
            ],
          ),
        ),
        child: GridView.builder(
            itemCount: properties,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, index) {
              return
                  //index == 0
                  //     ? IconButton(
                  //         icon: Icon(
                  //           Icons.refresh,
                  //           color: greenThick,
                  //           size: 35,
                  //         ),
                  //         onPressed: () {
                  //           setPropertyCount();
                  //         },
                  //       )
                  //     :
                  Padding(
                padding: const EdgeInsets.all(25.0),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  margin: EdgeInsets.all(3),
                  width: double.infinity,
                  height: 700,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.white,
                        Colors.grey,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8.0),
                            topRight: Radius.circular(8.0),
                          ),
                          //errorBuilder: (BuildContext context, Object exception, StackTrace stackTrace) {
                          //     return Text('Your error widget...');
                          // },
                          child: Image.network(
                              //'https://media.istockphoto.com/photos/beautiful-luxury-home-exterior-at-twilight-picture-id1026205392?k=6&m=1026205392&s=612x612&w=0&h=pe0Pqbm7GKHl7cmEjf9Drc7Fp-JwJ6aTywsGfm5eQm4=',
                              _propertyData[index]["Image"],
                              width: 300,
                              height: 150,
                              fit: BoxFit.fill),
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Name : ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              _propertyData[index]["name"],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.teal,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Description : ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                _propertyData[index]["Description"],
                                overflow: TextOverflow.visible,
                                softWrap: true,
                                maxLines: 3,
                                style: GoogleFonts.rajdhani(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  color: Colors.teal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Address : ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Flexible(
                              child: Text(
                                _propertyData[index]["Address"],
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
                                style: GoogleFonts.rajdhani(
                                  textStyle:
                                      Theme.of(context).textTheme.headline4,
                                  color: Colors.teal,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Purpose : ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              _propertyData[index]["Purpose"],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.teal,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              _propertyData[index]["Value"] != null
                                  ? "Value : "
                                  : "Rent : ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              "₹ ${_propertyData[index]["Value"] != null ? _propertyData[index]["Value"] : _propertyData[index]["Rent"]}",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.red,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Furnished : ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              _propertyData[index]["isFurnished"],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.teal,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              "Negotiable : ",
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.blue,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text(
                              _propertyData[index]["isNegotiable"],
                              overflow: TextOverflow.ellipsis,
                              style: GoogleFonts.rajdhani(
                                textStyle:
                                    Theme.of(context).textTheme.headline4,
                                color: Colors.teal,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
      bottomNavigationBar: BottomNavigation(),
    );
  }
}
