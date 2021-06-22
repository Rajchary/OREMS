import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/assets/CustomeIcons.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/screens/Tenant/components/property.dart';

class Favourites extends StatefulWidget {
  static const idScreen = "Favourites";
  const Favourites({Key key}) : super(key: key);

  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  List<Map<String, dynamic>> _propertyData = [];
  String unAvailableImage = "https://img.pngio.com/lighting-and-home-furnishi" +
      "ng-products-represented-by-bostrom-png-unavailable-300_300.png";
  int properties = 0;
  Size size;
  bool wishlisted = true;
  Future<void> getFavourites() async {
    Map<String, dynamic> favList;
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid.toString())
        .get()
        .then((doc) {
      setState(() {
        favList = doc.data()["Favourites"];
      });
    });
    if (favList == null || favList.length == 0) {
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
                height: size.height * 0.45,
                width: size.width * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/No message.svg",
                      width: size.width * 0.4,
                      height: size.height * 0.2,
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
                        "Their aren't any properties added to your favourites yet",
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
    } else {
      favList.forEach((key, value) async {
        if (value == "Lease") {
          await addLeasedProperties(key);
        } else if (value == "Sale") {
          await addSaleProperties(key).whenComplete(() {
            print("Properties length till now are ${_propertyData.length}");
          });
        }
      });
      print("Properties added till now are $properties");
    }
  }

  Future<void> addLeasedProperties(String docId) async {
    await FirebaseFirestore.instance
        .collection("Property")
        .doc("General")
        .collection("Lease")
        .doc(docId)
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          ++properties;
          _propertyData.add(value.data());
          _propertyData[properties - 1]["docId"] = docId;
          _propertyData[properties - 1]["Status"] = "Available";
        });
      } else {
        await addMissedOutProperties(docId);
      }
    });
  }

  Future<void> addSaleProperties(String docId) async {
    await FirebaseFirestore.instance
        .collection("Property")
        .doc("General")
        .collection("Sale")
        .doc(docId)
        .get()
        .then((value) async {
      if (value.exists) {
        setState(() {
          ++properties;
          _propertyData.add(value.data());
          _propertyData[properties - 1]["docId"] = docId;
          _propertyData[properties - 1]["Status"] = "Available";
        });
      } else {
        await addMissedOutProperties(docId);
      }
    });
  }

  Future<void> addMissedOutProperties(String docId) async {
    await FirebaseFirestore.instance
        .collection("Property")
        .doc("General")
        .collection("MovedOuts")
        .doc(docId)
        .get()
        .then((value) async {
      setState(() {
        ++properties;
        _propertyData.add(value.data());
        _propertyData[properties - 1]["docId"] = docId;
        _propertyData[properties - 1]["Status"] = "NotAvailable";
      });
    });
  }

  @override
  void initState() {
    getFavourites();
    super.initState();
  }

  Future<void> removeFromFavourites(String docId) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser.uid.toString())
        .update({
      "Favourites.$docId": FieldValue.delete(),
    }).then((_) => Fluttertoast.showToast(msg: "Removed from favourites"));
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
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
                    if (_propertyData[index]["Status"] == "Available") {
                      Navigator.pushNamed(context, PropertyView.idScreen,
                          arguments: _propertyData[index]);
                    } else {
                      final action = await AlertDialogs.confirmDialog(
                          context,
                          "Pardon",
                          "This property is currently unavailable.It is " +
                              "either leased out or sold out please try removing this property",
                          yes: "Remove");
                      if (action == DialogAction.Yes) {
                        await removeFromFavourites(
                            _propertyData[index]["docId"]);
                        setState(() {
                          wishlisted = true;
                          properties = 0;
                          getFavourites();
                        });
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    margin: EdgeInsets.all(3),
                    width: double.infinity,
                    height: size.height * 0.7,
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () async {
                                  setState(() {
                                    HapticFeedback.vibrate();
                                    wishlisted = !wishlisted;
                                  });
                                  if (!wishlisted) {
                                    final action = await AlertDialogs.confirmDialog(
                                        context,
                                        "Remove ?",
                                        "Are you sure you wanna remove this property from your favourites",
                                        yes: "Yes",
                                        cancel: "No");
                                    if (action == DialogAction.Yes) {
                                      await removeFromFavourites(
                                          _propertyData[index]["docId"]);
                                      setState(() {
                                        wishlisted = true;
                                        properties = 0;
                                        getFavourites();
                                      });
                                    } else {
                                      setState(() {
                                        wishlisted = true;
                                      });
                                    }
                                  }
                                },
                                icon: Icon(
                                  wishlisted
                                      ? CustomIcons.favorite
                                      : CustomIcons.favorite_border,
                                  color: wishlisted ? Colors.red : Colors.black,
                                  size: size.width * 0.09,
                                ),
                              ),
                            ],
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
                                _propertyData[index]["Status"] == "Available"
                                    ? _propertyData[index]["Image"]
                                    : unAvailableImage,
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
