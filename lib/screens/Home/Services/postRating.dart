import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/components/confirmDialog.dart';
import 'package:online_real_estate_management_system/components/roundedInputField.dart';
import 'package:online_real_estate_management_system/constants.dart';

class PostRating extends StatefulWidget {
  static const idScreen = "PostRating";
  const PostRating({Key key}) : super(key: key);

  @override
  _PostRatingState createState() => _PostRatingState();
}

class _PostRatingState extends State<PostRating> {
  Map<String, dynamic> userData = {};
  double r = 0, rc = 0, rating = 0;
  bool isRated = false;
  TextEditingController titleController = new TextEditingController();
  TextEditingController descController = new TextEditingController();
  List<bool> selected = [false, false, false, false, false];
  Size size;
  void rateUser(double index) {
    rating = index;
    for (int i = 0; i < 5; i++) {
      if (i <= index) {
        selected[i] = true;
      } else {
        selected[i] = false;
      }
    }
    isRated = true;
  }

  Future<void> postReview(
      double rating, double ratingCout, double totalRating) async {
    await FirebaseFirestore.instance
        .collection("Remarks")
        .doc(userData["uid"])
        .set({"${titleController.text}": "${descController.text}"},
            SetOptions(merge: true)).whenComplete(() async {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userData["uid"])
          .update({
        "Rating": rating,
        "ratingCount": ratingCout,
        "totalRating": totalRating,
      }).whenComplete(() {
        showPostedDialog();
      });
    });
  }

  void showPostedDialog() {
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
              height: size.height * .4,
              width: size.width * .4,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/posted.svg",
                    width: size.width * .4,
                    height: size.height * .2,
                  ),
                  Text(
                    "Posted !",
                    style: GoogleFonts.lobster(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.blue,
                      fontSize: size.width * .055,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: size.height * .015,
                  ),
                  Flexible(
                    child: Text(
                      "Your review has been successfully posted ❤️",
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
                    height: size.height * .015,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
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
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    userData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        height: size.height,
        width: size.width,
        color: Color(0xFF1B222E),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: size.height * .04,
              ),
              Row(
                children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: size.width * .015,
                  ),
                  Container(
                    width: size.width * .25,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.redAccent, width: 3.0),
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * 0.4,
                    height: size.height * 0.19,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.redAccent,
                        width: 3,
                      ),
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(userData["ProfilePicture"]),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    width: size.width * .23,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(color: Colors.redAccent, width: 3.0),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .035,
              ),
              Text(
                "${userData["name"]}",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.blue,
                  fontSize: size.width * .065,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Rate the user out of five ! " +
                    "And describe him in few lines",
                maxLines: 2,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.blue,
                  fontSize: size.width * .047,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Help us know ${userData["name"]} better. " +
                    "Your review matters alot 😃",
                maxLines: 2,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: size.width * .045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                if (selected[0])
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      setState(() {
                        rateUser(0);
                      });
                    },
                    color: Colors.yellowAccent,
                    iconSize: size.width * .095,
                  ),
                if (!selected[0])
                  IconButton(
                    icon: Icon(Icons.star_outline),
                    onPressed: () {
                      setState(() {
                        rateUser(0);
                      });
                    },
                    color: Colors.white,
                    iconSize: size.width * .095,
                  ),
                if (selected[1])
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      setState(() {
                        rateUser(1);
                      });
                    },
                    color: Colors.yellowAccent,
                    iconSize: size.width * .095,
                  ),
                if (!selected[1])
                  IconButton(
                    icon: Icon(Icons.star_outline),
                    onPressed: () {
                      setState(() {
                        rateUser(1);
                      });
                    },
                    color: Colors.white,
                    iconSize: size.width * .095,
                  ),
                if (selected[2])
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      setState(() {
                        rateUser(2);
                      });
                    },
                    color: Colors.yellowAccent,
                    iconSize: size.width * .095,
                  ),
                if (!selected[2])
                  IconButton(
                    icon: Icon(Icons.star_outline),
                    onPressed: () {
                      setState(() {
                        rateUser(2);
                      });
                    },
                    color: Colors.white,
                    iconSize: size.width * .095,
                  ),
                if (selected[3])
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      setState(() {
                        rateUser(3);
                      });
                    },
                    color: Colors.yellowAccent,
                    iconSize: size.width * .095,
                  ),
                if (!selected[3])
                  IconButton(
                    icon: Icon(Icons.star_outline),
                    onPressed: () {
                      setState(() {
                        rateUser(3);
                      });
                    },
                    color: Colors.white,
                    iconSize: size.width * .095,
                  ),
                if (selected[4])
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: () {
                      setState(() {
                        rateUser(4);
                      });
                    },
                    color: Colors.yellowAccent,
                    iconSize: size.width * .095,
                  ),
                if (!selected[4])
                  IconButton(
                    icon: Icon(Icons.star_outline),
                    onPressed: () {
                      setState(() {
                        rateUser(4);
                      });
                    },
                    color: Colors.white,
                    iconSize: size.width * .095,
                  ),
              ]),
              RoundedInputField(
                hintText: "Title",
                lines: 1,
                onChanged: (value) {
                  setState(() {
                    titleController.text = value;
                  });
                },
              ),
              SizedBox(
                height: size.height * .015,
              ),
              RoundedInputField(
                lines: 4,
                hintText: "Description",
                onChanged: (value) {
                  setState(() {
                    descController.text = value;
                  });
                },
              ),
              SizedBox(
                height: size.height * .025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                    onPressed: () async {
                      final action = await AlertDialogs.confirmDialog(
                          context, "Clear", "Do you wanna clear out everything",
                          yes: "Yes", cancel: "Cancel");
                      if (action == DialogAction.Yes) {
                        setState(() {
                          titleController.text = "";
                          descController.text = "";
                          for (int i = 0; i < 5; i++) {
                            selected[i] = false;
                          }
                          isRated = false;
                          rating = 0;
                        });
                      }
                    },
                    child: Text(
                      "Clear",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * .045),
                    ),
                  ),
                  SizedBox(
                    width: size.width * .035,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: greenThick,
                    ),
                    onPressed: () async {
                      // final action = await AlertDialogs.confirmDialog(
                      //     context, "Post", "Do you wanna post the review ?",
                      //     yes: "Yes", cancel: "Cancel");
                      // if (action == DialogAction.Yes) {
                      if (titleController.text.isEmpty ||
                          descController.text.isEmpty ||
                          !isRated) {
                        Fluttertoast.showToast(
                            msg: "Please write a review and rate the user");
                      } else {
                        r = userData["totalRating"].toDouble();
                        rc = userData["ratingCount"].toDouble();
                        r += rating;
                        rc += 1;
                        rating = r / rc;
                        await postReview(rating, rc, r);
                      }
                      //}
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                          color: Colors.white, fontSize: size.width * .045),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
