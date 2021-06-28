import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:online_real_estate_management_system/constants.dart';
import 'package:online_real_estate_management_system/screens/Home/Services/transactioDetails.dart';

class CashFlows extends StatefulWidget {
  static const idScreen = "CashFlows";
  const CashFlows({Key key}) : super(key: key);

  @override
  _CashFlowsState createState() => _CashFlowsState();
}

class _CashFlowsState extends State<CashFlows> {
  Size size;
  int transactionCount = 0;
  List<Map<String, dynamic>> transactionsData = [];
  Future<void> getTransactions() async {
    await FirebaseFirestore.instance
        .collection("Transactions")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("Sent")
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          if (element.exists) {
            setState(() {
              ++transactionCount;
              transactionsData.add(element.data());
              transactionsData[transactionCount - 1]["Type"] = "Sent";
            });
          }
        });
      }
    });
    await FirebaseFirestore.instance
        .collection("Transactions")
        .doc(FirebaseAuth.instance.currentUser.uid)
        .collection("Recieved")
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        value.docs.forEach((element) {
          if (element.exists) {
            setState(() {
              ++transactionCount;
              transactionsData.add(element.data());
              transactionsData[transactionCount - 1]["Type"] = "Recieve";
            });
          }
        });
      }
    });
    if (transactionsData.isNotEmpty) {
      sortTransactions();
    } else {
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
                height: size.height * .4,
                width: size.width * .4,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SvgPicture.asset(
                      "assets/images/no_transactions.svg",
                      width: size.width * .4,
                      height: size.height * .2,
                    ),
                    Text(
                      "No Transactions !",
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
                        "You have not made any transactions yet !!",
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
                          style:
                              ElevatedButton.styleFrom(primary: Colors.white),
                          onPressed: () {
                            Navigator.pop(context);
                            Navigator.pop(context);
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
  }

  Future<void> sortTransactions() async {
    //  print(transactionsData);
    transactionsData
        .sort((a, b) => a["Date"].toString().compareTo(b["Date"].toString()));
    //  print(transactionsData);
  }

  @override
  Widget build(BuildContext context) {
    if (transactionsData.isEmpty) getTransactions();
    size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        color: Color(0xFF1B222E),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
              "Transaction history",
              style: GoogleFonts.rajdhani(
                textStyle: Theme.of(context).textTheme.headline4,
                color: greenThick,
                fontSize: size.width * .065,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (transactionCount != 0)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                height: size.height,
                child: GridView.builder(
                    itemCount: transactionCount,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1,
                        childAspectRatio: size.width / (size.height / 7)),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.all(10),
                        child: GestureDetector(
                          onTap: () async {
                            Navigator.pushNamed(context, TxnDetails.idScreen,
                                arguments: transactionsData[index]);
                          },
                          child: Container(
                            child: Column(children: [
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundImage: NetworkImage(
                                          transactionsData[index]
                                              ["ProfilePicture"]),
                                    ),
                                    Text(
                                      transactionsData[index]["Type"] == "Sent"
                                          ? "${transactionsData[index]["To"]}"
                                          : "${transactionsData[index]["From"]}",
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: Colors.blue,
                                        fontSize: size.width * .045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(
                                      width: size.width * .4,
                                    ),
                                    Text(
                                      transactionsData[index]["Type"] == "Sent"
                                          ? "- ₹${transactionsData[index]["Amount"]}"
                                          : "+ ₹${transactionsData[index]["Amount"]}",
                                      style: GoogleFonts.rajdhani(
                                        textStyle: Theme.of(context)
                                            .textTheme
                                            .headline4,
                                        color: transactionsData[index]
                                                    ["Type"] ==
                                                "Sent"
                                            ? Colors.red
                                            : greenThick,
                                        fontSize: size.width * .045,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                  ]),
                              SizedBox(height: size.height * .015),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${transactionsData[index]["Date"]}",
                                    style: GoogleFonts.rajdhani(
                                      textStyle:
                                          Theme.of(context).textTheme.headline4,
                                      color: Colors.white,
                                      fontSize: size.width * .045,
                                      //  fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ]),
                          ),
                        ),
                      );
                    }),
              ),
          ]),
        ),
      ),
    );
  }
}
