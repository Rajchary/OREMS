import 'package:flutter/material.dart';

class Notification {
  String reciever;
  String propertyName;
  String documentId;
  String purpose;
  Notification(
      {@required this.reciever,
      @required this.documentId,
      @required this.propertyName,
      @required this.purpose});
  Future<void> notifyUser(String reciever, String propertyName,
      String documentId, String purpose) {
        
      }
}
