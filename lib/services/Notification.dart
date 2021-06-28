import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class CustomNotification {
  static Future<void> notifyUser(
      String receiver,
      String propertyName,
      String docId,
      String purpose,
      String body,
      String to,
      String id,
      String succesMessage,
      {String errorMessage =
          "Acknowledgement not sent please try after some time!!"}) async {
    String serverKey =
        "AAAAQc2YwIo:APA91bFEi7E37NseKuYFm1iOXwiYEZuudjiZzNY27HkBzhG8sjiPf3QPV1V2w8XA7Vf8XmE7vq5JrxRObveM5cFAsJry1-r1jM_EzvLkyCIoWC-l0H0397xLxjPV6sLQiIQ4pM-_5U8l";
    final prefs = await SharedPreferences.getInstance();
    var token = await getToken(receiver);
    print("Token $token");
    Map<String, dynamic> postData = {
      "uid": "${FirebaseAuth.instance.currentUser.uid}",
      "docId": "$docId",
      "Purpose": "$purpose",
      "to": "$to",
    };
    try {
      final response = await http.post(
        Uri.parse("https://fcm.googleapis.com/fcm/send"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'key=$serverKey',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '${prefs.getString("name")}' + ' $body',
              'title': '$propertyName'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'sound': 'default',
              'color': 'blue',
              'id': '$id',
              'status': 'done',
              'screen': 'To Tenant',
              'postData': postData,
            },
            'to': token,
          },
        ),
      );
      print('FCM request for device sent!');
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: '$succesMessage');
      } else {
        Fluttertoast.showToast(msg: '$errorMessage');
        print('notification sending failed with code ${response.statusCode}');
      }
    } catch (e) {
      print('exception $e');
    }
  }

  static Future<String> getToken(userId) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;
    var token;
    await _db
        .collection('users')
        .doc(userId)
        .collection('tokens')
        .get()
        .then((snapshot) {
      snapshot.docs.forEach((doc) {
        token = doc.id;
      });
    });
    return token;
  }
}
