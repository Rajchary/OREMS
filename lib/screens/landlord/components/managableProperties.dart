import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/progressDialog.dart';
import 'package:online_real_estate_management_system/screens/Home/homeScreen.dart';

class ManageProperty extends StatefulWidget {
  static const idScreen = "ManageProperty";
  const ManageProperty({Key key}) : super(key: key);

  @override
  _ManagePropertyState createState() => _ManagePropertyState();
}

class _ManagePropertyState extends State<ManageProperty>
    with WidgetsBindingObserver {
  int properties = 0;
  List<Map<String, dynamic>> _propertyData = [];
  @override
  void initState() {
    getManagableProperties();
    super.initState();
  }

  Future<void> getManagableProperties() async {
    await FirebaseFirestore.instance
        .collection('Property')
        .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
        .collection("PropertyDetails")
        .get()
        .then((QuerySnapshot snap) {
      setState(() {
        int i = 0;
        properties = snap.docs.length;
        snap.docs.forEach((record) {
          String docId = record.id.toString();
          _propertyData.add(record.data());
          _propertyData[i]["docId"] = docId;
          ++i;
        });
      });
      if (properties == 0) {
        showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(45)),
                elevation: 16,
                child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Color(0xFF1B222E),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 400,
                  width: 400,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SvgPicture.asset(
                        "assets/images/Astronaut-01.svg",
                        width: 400,
                        height: 200,
                      ),
                      Text(
                        "Ouch !",
                        style: GoogleFonts.lobster(
                          textStyle: Theme.of(context).textTheme.headline4,
                          color: Colors.blue,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Flexible(
                        child: Text(
                          "Their aren't any properties available to sell in your managing basket",
                          overflow: TextOverflow.visible,
                          softWrap: true,
                          maxLines: 3,
                          style: GoogleFonts.rajdhani(
                            textStyle: Theme.of(context).textTheme.headline4,
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style:
                                ElevatedButton.styleFrom(primary: Colors.white),
                            onPressed: () {
                              // Navigator.pushNamedAndRemoveUntil(context,
                              //     HomeScreen.idScreen, (route) => false);
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                            },
                            child: Text(
                              "OK",
                              style: TextStyle(
                                  fontSize: 15, color: Colors.pink[400]),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            });
      }
    });
  }

  void showUpdateSuccess() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return Dialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(45)),
            elevation: 16,
            child: Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF1B222E),
                borderRadius: BorderRadius.circular(30),
              ),
              height: 400,
              width: 400,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/update_done.svg",
                    width: 400,
                    height: 200,
                  ),
                  Text(
                    "Updated !",
                    style: GoogleFonts.lobster(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.blue,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Flexible(
                    child: Text(
                      "Your property was successfully added into Sale list",
                      overflow: TextOverflow.visible,
                      softWrap: true,
                      maxLines: 3,
                      style: GoogleFonts.rajdhani(
                        textStyle: Theme.of(context).textTheme.headline4,
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(
                              context, HomeScreen.idScreen, (route) => false);
                        },
                        child: Text(
                          "OK",
                          style:
                              TextStyle(fontSize: 15, color: Colors.pink[400]),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    getManagableProperties();
    super.didChangeAppLifecycleState(state);
  }

  Future<void> addFromManageToSale(
      BuildContext context, Map<String, dynamic> map) async {
    await FirebaseFirestore.instance
        .collection('Property')
        .doc('General')
        .collection("Sale")
        .add({
      "name": map["name"],
      "Address": map["Address"],
      "Landmark": map["Landmark"],
      "Description": map["Description"],
      "Contact": map["Contact"],
      "Purpose": map["Purpose"],
      "RoomType": map["RoomType"],
      "Area": map["Area"],
      "Value": map["Value"],
      "Image": map["Image"],
      "GeoLocation": map["GeoLocation"],
      "latitude": map["latitude"],
      "longitude": map["longitude"],
      "isNegotiable": map["isNegotiable"],
      "isFurnished": map["isFurnished"],
      "uid": map["uid"],
    }).then((value) async {
      await FirebaseFirestore.instance
          .collection('Property')
          .doc("${FirebaseAuth.instance.currentUser.uid.toString()}")
          .collection("PropertyDetails")
          .doc(map["docId"])
          .delete()
          .then((value) => Navigator.pop(context));
      showUpdateSuccess();
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        color: Color(0xFF1B222E),
        child: GridView.builder(
            itemCount: properties,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(25.0),
                child: GestureDetector(
                  onTap: () async {
                    final action = await AlertDialogs.confirmDialog(
                        context,
                        "Update ?",
                        "Are you sure you wanna make this property to sale",
                        yes: "Yes",
                        cancel: "Cancel");
                    // ignore: unrelated_type_equality_checks
                    if (action == DialogAction.Yes) {
                      Fluttertoast.showToast(msg: _propertyData[index]["name"]);
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return ProgressDialog(
                              message: "Updating..",
                            );
                          });
                      await addFromManageToSale(context, _propertyData[index])
                          .whenComplete(
                              () => Fluttertoast.showToast(msg: "Update done"));
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.all(3),
                    width: double.infinity,
                    height: 700,
                    decoration: BoxDecoration(
                      color: Color(0xFF1B222E),
                      border: Border.all(color: Colors.white),
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
                ),
              );
            }),
      ),
    );
  }
}
