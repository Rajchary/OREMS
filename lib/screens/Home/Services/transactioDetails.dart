import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constants.dart';

class TxnDetails extends StatefulWidget {
  static const String idScreen = "TxnDetails";
  const TxnDetails({Key key}) : super(key: key);

  @override
  _TxnDetailsState createState() => _TxnDetailsState();
}

class _TxnDetailsState extends State<TxnDetails> {
  Map<String, dynamic> txnData = {};
  Size size;
  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    txnData = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Color(0xFF1B222E),
        child: SingleChildScrollView(
          child: Column(
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
                "Transaction Details",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: size.width * .065,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * .035,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(txnData["ProfilePicture"]),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .025,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${txnData["TxnNote"]}",
                    maxLines: 2,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.white,
                      fontSize: size.width * .065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${txnData["Date"]}",
                    maxLines: 2,
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.red,
                      fontSize: size.width * .065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Text(
                "₹ ${txnData["Amount"]}",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: size.width * .1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    txnData["From"] != null ? "From  : " : "To  : ",
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.white,
                      fontSize: size.width * .065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: size.width * .035,
                  ),
                  Text(
                    txnData["From"] != null
                        ? "${txnData["From"]}"
                        : "${txnData["To"]}",
                    style: GoogleFonts.rajdhani(
                      textStyle: Theme.of(context).textTheme.headline4,
                      color: Colors.blue,
                      fontSize: size.width * .065,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: size.height * .015,
              ),
              Text(
                "Transaction Id",
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: Colors.white,
                  fontSize: size.width * .045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: size.height * .005,
              ),
              Text(
                "${txnData["TxnId"]}",
                maxLines: 2,
                style: GoogleFonts.rajdhani(
                  textStyle: Theme.of(context).textTheme.headline4,
                  color: greenThick,
                  fontSize: size.width * .045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (txnData["To"] != null)
                Text(
                  "To UPI ID ",
                  maxLines: 2,
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: Colors.white,
                    fontSize: size.width * .045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              SizedBox(
                height: size.height * .015,
              ),
              if (txnData["To"] != null)
                Text(
                  "${txnData["upi_id"]}",
                  maxLines: 2,
                  style: GoogleFonts.rajdhani(
                    textStyle: Theme.of(context).textTheme.headline4,
                    color: greenThick,
                    fontSize: size.width * .045,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
