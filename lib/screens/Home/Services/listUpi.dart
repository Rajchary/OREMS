import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:online_real_estate_management_system/screens/Home/Services/postUpiTxn.dart';
import 'package:upi_pay/upi_pay.dart';

class ListUpi extends StatefulWidget {
  static const idScreen = "listUpis";
  @override
  _ListUpiState createState() => _ListUpiState();
}

class _ListUpiState extends State<ListUpi> {
 
  List<ApplicationMeta> _apps;
  Map<String, dynamic> transactionData = {};
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(milliseconds: 0), () async {
      _apps = await UpiPay.getInstalledUpiApplications(
          statusType: UpiApplicationDiscoveryAppStatusType.all);
      setState(() {});
    });
  }

  Future<void> _onTap(ApplicationMeta app) async {
    final transactionRef = Random.secure().nextInt(1 << 32).toString();
    Fluttertoast.showToast(msg: "Initiating transactions");
    final a = await UpiPay.initiateTransaction(
      amount: transactionData["amount"],
      app: app.upiApplication,
      receiverName: transactionData["Reciever_name"],
      receiverUpiAddress: transactionData["Reciever_upi"],
      transactionRef: transactionRef,
      transactionNote: transactionData["note"],
      // merchantCode: '7372',
    );
    if (a.status == UpiTransactionStatus.success) {
      var timeH = DateTime.now().hour > 12
          ? DateTime.now().hour - 12
          : DateTime.now().hour;
      String meridiam = DateTime.now().hour >= 12 ? "PM" : "AM";
      Map<String, dynamic> transactionDetails = {
        "txnId": a.txnId.toString(),
        "txnRef": a.txnRef.toString(),
        "Status": a.status.toString(),
        "respoonseCode": a.responseCode,
        "uid": transactionData["uid"],
        "docId": transactionData["docId"],
        "purpose": transactionData["purpose"],
        "amount": transactionData["amount"],
        "Date":
            "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}" +
                "-$timeH : ${DateTime.now().minute} $meridiam",
      };
      print(transactionDetails);
      Navigator.pushNamed(context, PostTxn.idScreen,
          arguments: transactionDetails);
    } else {
      print(a.rawResponse.split("&"));
    }
  }

  @override
  Widget build(BuildContext context) {
    transactionData = ModalRoute.of(context).settings.arguments;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: ListView(
        children: <Widget>[
          _androidApps(),
        ],
      ),
    );
  }

  Widget _androidApps() {
    return Container(
      margin: EdgeInsets.only(top: 32, bottom: 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 12),
            child: Text(
              'Pay Using',
              style: Theme.of(context).textTheme.bodyText1,
            ),
          ),
          if (_apps != null) _appsGrid(_apps.map((e) => e).toList()),
        ],
      ),
    );
  }

  GridView _appsGrid(List<ApplicationMeta> apps) {
    apps.sort((a, b) => a.upiApplication
        .getAppName()
        .toLowerCase()
        .compareTo(b.upiApplication.getAppName().toLowerCase()));
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      // childAspectRatio: 1.6,
      physics: NeverScrollableScrollPhysics(),
      children: apps
          .map(
            (it) => Material(
              key: ObjectKey(it.upiApplication),
              // color: Colors.grey[200],
              child: InkWell(
                onTap: Platform.isAndroid ? () async => await _onTap(it) : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    it.iconImage(48),
                    Container(
                      margin: EdgeInsets.only(top: 4),
                      alignment: Alignment.center,
                      child: Text(
                        it.upiApplication.getAppName(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
